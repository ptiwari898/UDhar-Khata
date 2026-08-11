package com.example.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.CustomerFinancialSummary
import com.example.ui.theme.CardSurface
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.SliceBlue1
import com.example.ui.theme.SliceBlue2
import com.example.ui.theme.SliceGreen1
import com.example.ui.theme.SliceOrange1
import com.example.ui.theme.SlicePurple1
import com.example.ui.theme.SliceRed1
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

val sliceColors = listOf(SliceBlue1, SliceBlue2, SliceGreen1, SliceOrange1, SliceRed1, SlicePurple1)

@Composable
fun OutstandingPieChartCard(
    summaries: List<CustomerFinancialSummary>,
    totalOutstanding: Double,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = CardSurface),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Outstanding Breakdown (By Individual)",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Pie Chart Donut Canvas
                Box(
                    modifier = Modifier.size(150.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Canvas(modifier = Modifier.size(150.dp)) {
                        var startAngle = -90f
                        val strokeWidth = 32.dp.toPx()
                        val arcSize = Size(size.width - strokeWidth, size.height - strokeWidth)
                        val topLeft = Offset(strokeWidth / 2, strokeWidth / 2)

                        summaries.take(5).forEachIndexed { index, item ->
                            val sweepAngle = ((item.percentageShare / 100.0) * 360f).toFloat()
                            val color = sliceColors[index % sliceColors.size]

                            if (sweepAngle > 0f) {
                                drawArc(
                                    color = color,
                                    startAngle = startAngle,
                                    sweepAngle = sweepAngle - 2f, // gap
                                    useCenter = false,
                                    topLeft = topLeft,
                                    size = arcSize,
                                    style = Stroke(width = strokeWidth)
                                )
                                startAngle += sweepAngle
                            }
                        }
                    }

                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            text = "Total",
                            style = MaterialTheme.typography.bodySmall,
                            color = TextSecondary
                        )
                        Text(
                            text = "₹${totalOutstanding.toInt()}",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )
                    }
                }

                Spacer(modifier = Modifier.width(16.dp))

                // Breakdown Legend List
                Column(
                    modifier = Modifier.weight(1f),
                    verticalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    summaries.take(5).forEachIndexed { index, item ->
                        val color = sliceColors[index % sliceColors.size]
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(10.dp)
                                    .background(color, CircleShape)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = item.customer.name,
                                style = MaterialTheme.typography.bodySmall,
                                fontWeight = FontWeight.Medium,
                                color = TextSecondary,
                                modifier = Modifier.weight(1f)
                            )
                            Text(
                                text = "₹${item.currentOutstanding.toInt()} (${String.format("%.1f", item.percentageShare)}%)",
                                style = MaterialTheme.typography.bodySmall,
                                fontWeight = FontWeight.Bold,
                                color = TextPrimary
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun TrendLineChartCard(
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = CardSurface),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Outstanding Trend",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Spacer(modifier = Modifier.height(12.dp))

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(130.dp)
            ) {
                Canvas(modifier = Modifier.fillMaxWidth().height(100.dp)) {
                    val width = size.width
                    val height = size.height

                    val p1 = Offset(width * 0.15f, height * 0.8f)
                    val p2 = Offset(width * 0.50f, height * 0.5f)
                    val p3 = Offset(width * 0.85f, height * 0.15f)

                    val path = Path().apply {
                        moveTo(p1.x, p1.y)
                        lineTo(p2.x, p2.y)
                        lineTo(p3.x, p3.y)
                    }

                    val fillPath = Path().apply {
                        moveTo(p1.x, p1.y)
                        lineTo(p2.x, p2.y)
                        lineTo(p3.x, p3.y)
                        lineTo(p3.x, height)
                        lineTo(p1.x, height)
                        close()
                    }

                    // Gradient Fill under curve
                    drawPath(
                        path = fillPath,
                        brush = Brush.verticalGradient(
                            colors = listOf(Color(0xFFF2B8B5).copy(alpha = 0.25f), Color.Transparent)
                        )
                    )

                    // Curve Line
                    drawPath(
                        path = path,
                        color = Color(0xFFF2B8B5),
                        style = Stroke(width = 3.dp.toPx())
                    )

                    // Point Dots
                    val points = listOf(p1, p2, p3)
                    points.forEach { point ->
                        drawCircle(color = CardSurface, radius = 6.dp.toPx(), center = point)
                        drawCircle(color = Color(0xFFF2B8B5), radius = 4.dp.toPx(), center = point)
                    }
                }

                // Month Labels
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .align(Alignment.BottomCenter)
                        .padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Jun '26\n₹2,800", fontSize = 11.sp, color = TextSecondary)
                    Text("Jul '26\n₹4,200", fontSize = 11.sp, color = TextSecondary)
                    Text("Aug '26\n₹5,800", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = RedUdhar)
                }
            }
        }
    }
}
