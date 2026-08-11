package com.example.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColorScheme = darkColorScheme(
    primary = PrimaryBlue,
    onPrimary = Color(0xFF381E72),
    primaryContainer = PrimaryBlueBg,
    onPrimaryContainer = Color(0xFFE8DEF8),
    secondary = GreenUdharRepaid,
    onSecondary = Color(0xFF003912),
    secondaryContainer = GreenBg,
    onSecondaryContainer = GreenUdharRepaid,
    error = RedUdhar,
    onError = Color(0xFF601410),
    errorContainer = RedBg,
    onErrorContainer = RedUdhar,
    background = BackgroundSlate,
    onBackground = TextPrimary,
    surface = CardSurface,
    onSurface = TextPrimary,
    surfaceVariant = Color(0xFF332D41),
    onSurfaceVariant = TextSecondary,
    outline = BorderLight
)

@Composable
fun UdharKhataTheme(
    darkTheme: Boolean = true,
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        typography = Typography,
        content = content
    )
}

