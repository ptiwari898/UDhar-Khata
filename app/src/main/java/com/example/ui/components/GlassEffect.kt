package com.example.ui.components

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.chrisbanes.haze.HazeState
import dev.chrisbanes.haze.hazeEffect
import dev.chrisbanes.haze.hazeSource
import dev.chrisbanes.haze.materials.ExperimentalHazeMaterialsApi
import dev.chrisbanes.haze.materials.HazeMaterials
import dev.chrisbanes.haze.rememberHazeState

/** Shared blur source; wrap the screen's background content with [glassSource]. */
@Composable
fun rememberGlassState(): HazeState = rememberHazeState()

private val LocalGlassState = staticCompositionLocalOf<HazeState> {
    error("Glass surfaces must be rendered inside GlassBackdrop")
}

/** Returns the app-wide blur state supplied by [GlassBackdrop]. */
@Composable
fun currentGlassState(): HazeState = LocalGlassState.current

/**
 * Shared atmospheric canvas with animated aurora orbs that creates a dynamic,
 * living refraction effect through all overlaid glass surfaces.
 */
@Composable
fun GlassBackdrop(content: @Composable () -> Unit) {
    val glassState = rememberGlassState()
    val infiniteTransition = rememberInfiniteTransition(label = "aurora_ambient")

    val pulse1 by infiniteTransition.animateFloat(
        initialValue = 0.85f,
        targetValue = 1.15f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 6500, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "pulse_1"
    )

    val shiftX by infiniteTransition.animateFloat(
        initialValue = -0.08f,
        targetValue = 0.08f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 8000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "shift_x"
    )

    val shiftY by infiniteTransition.animateFloat(
        initialValue = -0.06f,
        targetValue = 0.06f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 9500, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "shift_y"
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.linearGradient(
                    colors = listOf(
                        Color(0xFF040E14),
                        Color(0xFF08222B),
                        Color(0xFF0D1B36)
                    ),
                    start = Offset(0f, 0f),
                    end = Offset(1000f, 2000f)
                )
            )
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .glassSource(glassState)
        ) {
            // Orb 1: Vibrant Aqua / Teal Top-Left
            drawRect(
                brush = Brush.radialGradient(
                    colors = listOf(
                        Color(0xFF21C7B7).copy(alpha = 0.24f * pulse1),
                        Color(0xFF21C7B7).copy(alpha = 0.08f),
                        Color.Transparent
                    ),
                    center = Offset(
                        size.width * (0.12f + shiftX),
                        size.height * (0.08f + shiftY)
                    ),
                    radius = size.minDimension * 0.82f * pulse1
                )
            )

            // Orb 2: Electric Azure Blue Mid-Right
            drawRect(
                brush = Brush.radialGradient(
                    colors = listOf(
                        Color(0xFF3D72D9).copy(alpha = 0.22f),
                        Color(0xFF1E40AF).copy(alpha = 0.06f),
                        Color.Transparent
                    ),
                    center = Offset(
                        size.width * (0.92f - shiftX),
                        size.height * (0.42f + shiftY)
                    ),
                    radius = size.minDimension * 0.78f
                )
            )

            // Orb 3: Deep Royal Purple Bottom-Center
            drawRect(
                brush = Brush.radialGradient(
                    colors = listOf(
                        Color(0xFF7C4DCC).copy(alpha = 0.18f * pulse1),
                        Color(0xFF4C1D95).copy(alpha = 0.05f),
                        Color.Transparent
                    ),
                    center = Offset(
                        size.width * 0.5f,
                        size.height * (0.92f - shiftY)
                    ),
                    radius = size.minDimension * 0.72f * pulse1
                )
            )
        }

        CompositionLocalProvider(LocalGlassState provides glassState) {
            content()
        }
    }
}

/** Marks the content behind glass surfaces as the blur source. */
fun Modifier.glassSource(state: HazeState): Modifier = this.hazeSource(state = state)

/**
 * Spring-based tactile feedback modifier that smoothly scales down slightly on press
 * and springs back on release.
 */
fun Modifier.bouncyClickable(
    enabled: Boolean = true,
    scaleDown: Float = 0.95f,
    onClick: () -> Unit
): Modifier = composed {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()

    val scale by animateFloatAsState(
        targetValue = if (isPressed && enabled) scaleDown else 1.0f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessMedium
        ),
        label = "bouncy_scale"
    )

    this
        .graphicsLayer {
            scaleX = scale
            scaleY = scale
        }
        .clickable(
            interactionSource = interactionSource,
            indication = null,
            enabled = enabled,
            onClick = onClick
        )
}

/**
 * Frosted "liquid glass" surface utilizing Haze real-time backdrop blur,
 * specular top-edge illumination, and layered ambient depth.
 */
@OptIn(ExperimentalHazeMaterialsApi::class)
@Composable
fun Modifier.liquidGlass(
    state: HazeState,
    shape: Shape = RoundedCornerShape(22.dp),
    containerColor: Color = Color.White.copy(alpha = 0.09f),
    borderColor: Color = Color.White.copy(alpha = 0.22f),
    shadowElevation: Dp = 8.dp,
): Modifier {
    val specularBrush = Brush.verticalGradient(
        colors = listOf(
            borderColor.copy(alpha = (borderColor.alpha * 1.5f).coerceAtMost(0.55f)),
            borderColor.copy(alpha = borderColor.alpha * 0.6f),
            Color.White.copy(alpha = 0.04f)
        )
    )

    return this
        .shadow(
            elevation = shadowElevation,
            shape = shape,
            ambientColor = Color.Black.copy(alpha = 0.35f),
            spotColor = Color.Black.copy(alpha = 0.45f)
        )
        .clip(shape)
        .hazeEffect(
            state = state,
            style = HazeMaterials.regular()
        )
        .background(
            Brush.verticalGradient(
                colors = listOf(
                    Color.White.copy(alpha = 0.16f),
                    containerColor,
                    containerColor.copy(alpha = (containerColor.alpha * 0.75f).coerceAtLeast(0.04f))
                )
            ),
            shape = shape
        )
        .border(width = 1.dp, brush = specularBrush, shape = shape)
}

/** Glass card container with specular highlight and real-time backdrop blur. */
@Composable
fun GlassCard(
    state: HazeState,
    modifier: Modifier = Modifier,
    shape: Shape = RoundedCornerShape(22.dp),
    containerColor: Color = Color.White.copy(alpha = 0.09f),
    padding: Dp = 0.dp,
    margin: Dp = 0.dp,
    borderColor: Color = Color.White.copy(alpha = 0.22f),
    shadowElevation: Dp = 8.dp,
    content: @Composable () -> Unit,
) {
    Box(
        modifier = modifier
            .padding(margin)
            .liquidGlass(
                state = state,
                shape = shape,
                containerColor = containerColor,
                borderColor = borderColor,
                shadowElevation = shadowElevation
            )
            .padding(padding)
    ) {
        content()
    }
}

/** Interactive Glass card with spring touch feedback. */
@Composable
fun InteractiveGlassCard(
    state: HazeState,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    shape: Shape = RoundedCornerShape(22.dp),
    containerColor: Color = Color.White.copy(alpha = 0.09f),
    padding: Dp = 0.dp,
    margin: Dp = 0.dp,
    borderColor: Color = Color.White.copy(alpha = 0.22f),
    shadowElevation: Dp = 8.dp,
    content: @Composable () -> Unit,
) {
    Box(
        modifier = modifier
            .padding(margin)
            .bouncyClickable(scaleDown = 0.97f, onClick = onClick)
            .liquidGlass(
                state = state,
                shape = shape,
                containerColor = containerColor,
                borderColor = borderColor,
                shadowElevation = shadowElevation
            )
            .padding(padding)
    ) {
        content()
    }
}
