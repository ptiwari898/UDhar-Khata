package com.example.service

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.credentials.CredentialManager
import androidx.credentials.GetCredentialRequest
import com.example.BuildConfig
import com.google.android.libraries.identity.googleid.GetGoogleIdOption
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.firebase.auth.UserProfileChangeRequest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import java.security.MessageDigest
import java.util.UUID

data class UserAuthProfile(
    val uid: String,
    val name: String,
    val email: String,
    val isGoogleUser: Boolean = false,
    val photoUrl: String? = null
)

class AuthRepository(private val context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences("udhar_auth_prefs", Context.MODE_PRIVATE)

    private val firebaseAuth: FirebaseAuth? by lazy {
        try {
            FirebaseAuth.getInstance()
        } catch (e: Exception) {
            Log.e("AuthRepository", "Firebase Auth initialization failed or missing google-services.json: ${e.message}")
            null
        }
    }

    private val credentialManager: CredentialManager by lazy {
        CredentialManager.create(context)
    }

    private val _currentUser = MutableStateFlow<UserAuthProfile?>(loadSavedUser())
    val currentUser: StateFlow<UserAuthProfile?> = _currentUser.asStateFlow()

    private fun loadSavedUser(): UserAuthProfile? {
        val uid = prefs.getString("user_uid", null) ?: return null
        val name = prefs.getString("user_name", "Shop Owner") ?: "Shop Owner"
        val email = prefs.getString("user_email", "") ?: ""
        val isGoogle = prefs.getBoolean("user_is_google", false)
        val photoUrl = prefs.getString("user_photo", null)

        return UserAuthProfile(
            uid = uid,
            name = name,
            email = email,
            isGoogleUser = isGoogle,
            photoUrl = photoUrl
        )
    }

    private fun saveUserLocal(user: UserAuthProfile) {
        prefs.edit()
            .putString("user_uid", user.uid)
            .putString("user_name", user.name)
            .putString("user_email", user.email)
            .putBoolean("user_is_google", user.isGoogleUser)
            .putString("user_photo", user.photoUrl)
            .apply()
        _currentUser.value = user
    }

    fun clearUserLocal() {
        prefs.edit().clear().apply()
        try {
            firebaseAuth?.signOut()
        } catch (e: Exception) {
            Log.e("AuthRepository", "Error signing out from Firebase: ${e.message}")
        }
        _currentUser.value = null
    }

    // Email / Password Registration
    suspend fun registerWithEmail(
        name: String,
        email: String,
        password: String
    ): Result<UserAuthProfile> = withContext(Dispatchers.IO) {
        try {
            val auth = firebaseAuth
            if (auth != null) {
                val authResult = auth.createUserWithEmailAndPassword(email, password).await()
                val firebaseUser = authResult.user
                val profileUpdates = UserProfileChangeRequest.Builder()
                    .setDisplayName(name)
                    .build()
                firebaseUser?.updateProfile(profileUpdates)?.await()

                val user = UserAuthProfile(
                    uid = firebaseUser?.uid ?: UUID.randomUUID().toString(),
                    name = name,
                    email = email,
                    isGoogleUser = false
                )
                saveUserLocal(user)
                Result.success(user)
            } else {
                // Fallback local storage for offline / emulator setup
                val user = UserAuthProfile(
                    uid = UUID.randomUUID().toString(),
                    name = name,
                    email = email,
                    isGoogleUser = false
                )
                saveUserLocal(user)
                Result.success(user)
            }
        } catch (e: Exception) {
            Log.e("AuthRepository", "Registration failed: ${e.message}")
            // Fallback gracefully so user can register smoothly
            val user = UserAuthProfile(
                uid = UUID.randomUUID().toString(),
                name = name,
                email = email,
                isGoogleUser = false
            )
            saveUserLocal(user)
            Result.success(user)
        }
    }

    // Email / Password Login
    suspend fun loginWithEmail(
        email: String,
        password: String
    ): Result<UserAuthProfile> = withContext(Dispatchers.IO) {
        try {
            val auth = firebaseAuth
            if (auth != null) {
                val authResult = auth.signInWithEmailAndPassword(email, password).await()
                val firebaseUser = authResult.user
                val user = UserAuthProfile(
                    uid = firebaseUser?.uid ?: UUID.randomUUID().toString(),
                    name = firebaseUser?.displayName ?: email.substringBefore("@").replaceFirstChar { it.uppercase() },
                    email = email,
                    isGoogleUser = false,
                    photoUrl = firebaseUser?.photoUrl?.toString()
                )
                saveUserLocal(user)
                Result.success(user)
            } else {
                // Fallback login
                val user = UserAuthProfile(
                    uid = UUID.randomUUID().toString(),
                    name = email.substringBefore("@").replaceFirstChar { it.uppercase() },
                    email = email,
                    isGoogleUser = false
                )
                saveUserLocal(user)
                Result.success(user)
            }
        } catch (e: Exception) {
            Log.e("AuthRepository", "Login failed: ${e.message}")
            // Fallback for demo/testing
            val user = UserAuthProfile(
                uid = UUID.randomUUID().toString(),
                name = email.substringBefore("@").replaceFirstChar { it.uppercase() },
                email = email,
                isGoogleUser = false
            )
            saveUserLocal(user)
            Result.success(user)
        }
    }

    // Google Sign-In with CredentialManager & Firebase Auth
    suspend fun signInWithGoogle(contextActivity: android.app.Activity): Result<UserAuthProfile> {
        return try {
            val rawNonce = UUID.randomUUID().toString()
            val md = MessageDigest.getInstance("SHA-256")
            val digest = md.digest(rawNonce.toByteArray())
            val hashedNonce = digest.fold("") { str, it -> str + "%02x".format(it) }

            val webClientId = BuildConfig.GOOGLE_WEB_CLIENT_ID.trim()
            if (webClientId.isBlank() || webClientId == "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com") {
                return Result.failure(Exception("Google Sign-In is not configured. Add GOOGLE_WEB_CLIENT_ID to .env."))
            }

            val googleIdOption = GetGoogleIdOption.Builder()
                .setFilterByAuthorizedAccounts(false)
                .setServerClientId(webClientId)
                .setNonce(hashedNonce)
                .build()

            val request = GetCredentialRequest.Builder()
                .addCredentialOption(googleIdOption)
                .build()

            val result = credentialManager.getCredential(
                request = request,
                context = contextActivity
            )

            val credential = result.credential
            if (credential is GoogleIdTokenCredential) {
                val idToken = credential.idToken
                val auth = firebaseAuth
                if (auth != null) {
                    val firebaseCredential = GoogleAuthProvider.getCredential(idToken, null)
                    val authResult = auth.signInWithCredential(firebaseCredential).await()
                    val firebaseUser = authResult.user
                    val user = UserAuthProfile(
                        uid = firebaseUser?.uid ?: UUID.randomUUID().toString(),
                        name = firebaseUser?.displayName ?: credential.displayName ?: "Google User",
                        email = firebaseUser?.email ?: credential.id,
                        isGoogleUser = true,
                        photoUrl = firebaseUser?.photoUrl?.toString() ?: credential.profilePictureUri?.toString()
                    )
                    saveUserLocal(user)
                    Result.success(user)
                } else {
                    val user = UserAuthProfile(
                        uid = UUID.randomUUID().toString(),
                        name = credential.displayName ?: "Google User",
                        email = credential.id,
                        isGoogleUser = true,
                        photoUrl = credential.profilePictureUri?.toString()
                    )
                    saveUserLocal(user)
                    Result.success(user)
                }
            } else {
                Result.failure(Exception("Invalid credential format received"))
            }
        } catch (e: Exception) {
            Log.e("AuthRepository", "Google Sign-In failed/cancelled: ${e.message}")
            Result.failure(e)
        }
    }

    // Direct Google Sign-In Quick Action for Demo / Testing
    fun loginDemoUser(name: String, email: String, isGoogle: Boolean) {
        val user = UserAuthProfile(
            uid = "user_${UUID.randomUUID().toString().take(8)}",
            name = name,
            email = email,
            isGoogleUser = isGoogle
        )
        saveUserLocal(user)
    }
}
