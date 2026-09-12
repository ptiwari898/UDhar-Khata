package com.example.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Shapes
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.unit.dp

private val DarkColorScheme = darkColorScheme(
    primary = PrimaryBlue,
    onPrimary = Color(0xFF062622),
    primaryContainer = PrimaryBlueBg,
    onPrimaryContainer = Color(0xFFB6F6EA),
    secondary = GreenUdharRepaid,
    onSecondary = Color(0xFF062622),
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
    surfaceVariant = Color(0x75173B42),
    onSurfaceVariant = TextSecondary,
    outline = BorderLight
)

private val AppShapes = Shapes(
    extraSmall = RoundedCornerShape(10.dp),
    small = RoundedCornerShape(12.dp),
    medium = RoundedCornerShape(16.dp),
    large = RoundedCornerShape(16.dp),
    extraLarge = RoundedCornerShape(20.dp)
)

@Composable
fun UdharKhataTheme(
    darkTheme: Boolean = true,
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        typography = Typography,
        shapes = AppShapes,
        content = content
    )
}

val GlassSurface = Color.White.copy(alpha = 0.08f)
val GlassHighlight = Color.White.copy(alpha = 0.14f)

