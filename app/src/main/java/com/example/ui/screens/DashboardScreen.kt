package com.example.ui.screens

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ExitToApp
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.OverallShopSummary
import com.example.data.ShopProfile
import com.example.ui.UdharViewModel
import com.example.ui.components.GlassCard
import com.example.ui.components.InteractiveGlassCard
import com.example.ui.components.OutstandingPieChartCard
import com.example.ui.components.QuickActionButton
import com.example.ui.components.bouncyClickable
import com.example.ui.components.currentGlassState
import com.example.ui.components.liquidGlass
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun DashboardScreen(
    summary: OverallShopSummary?,
    profile: ShopProfile?,
    viewModel: UdharViewModel,
    onOpenDrawer: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()
    val currentUser by viewModel.currentUser.collectAsState()
    val glassState = currentGlassState()

    Box(modifier = modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Transparent)
                .verticalScroll(scrollState)
                .padding(top = 76.dp, start = 16.dp, end = 16.dp, bottom = 24.dp)
        ) {
            // Owner Profile Card
            GlassCard(
                state = glassState,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                containerColor = Color.White.copy(alpha = 0.08f),
                borderColor = PrimaryBlue.copy(alpha = 0.35f),
                padding = 16.dp
            ) {
                Column {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(56.dp)
                                .clip(CircleShape)
                                .background(
                                    Brush.radialGradient(
                                        colors = listOf(
                                            PrimaryBlue.copy(alpha = 0.35f),
                                            PrimaryBlueBg
                                        )
                                    )
                                )
                                .border(1.dp, PrimaryBlue.copy(alpha = 0.5f), CircleShape),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = if (currentUser?.isGoogleUser == true) "🌐" else "🏪",
                                fontSize = 26.sp
                            )
                        }

                        Spacer(modifier = Modifier.width(14.dp))

                        Column(modifier = Modifier.weight(1f)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(
                                    text = currentUser?.name ?: profile?.ownerName ?: "Shivam Kirana",
                                    style = MaterialTheme.typography.titleMedium,
                                    fontWeight = FontWeight.Bold,
                                    color = TextPrimary
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Surface(
                                    color = if (currentUser?.isGoogleUser == true) Color(0xFF1E3A8A) else PrimaryBlueBg,
                                    shape = RoundedCornerShape(8.dp),
                                    modifier = Modifier.border(
                                        0.6.dp,
                                        PrimaryBlue.copy(alpha = 0.4f),
                                        RoundedCornerShape(8.dp)
                                    )
                                ) {
                                    Text(
                                        text = if (currentUser?.isGoogleUser == true) "Google Merchant" else "Firebase Auth",
                                        color = PrimaryBlue,
                                        fontSize = 10.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(3.dp))

                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.Email, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(12.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    text = currentUser?.email ?: "merchant@udharkhata.com",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = TextSecondary
                                )
                            }

                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.LocationOn, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(12.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    text = profile?.location ?: "Bhopal, Madhya Pradesh",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = TextSecondary
                                )
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedButton(
                        onClick = { viewModel.logout() },
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_logout_action")
                            .bouncyClickable(scaleDown = 0.96f) { viewModel.logout() },
                        shape = RoundedCornerShape(12.dp),
                        colors = ButtonDefaults.outlinedButtonColors(contentColor = RedUdhar)
                    ) {
                        Icon(Icons.AutoMirrored.Filled.ExitToApp, contentDescription = null, tint = RedUdhar, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Sign Out Account", color = RedUdhar, fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
                    }
                }
            }

            Spacer(modifier = Modifier.height(14.dp))

            // Large Current Outstanding Banner
            val outstandingAmt = summary?.currentOutstandingUdhar?.toInt() ?: 15000
            GlassCard(
                state = glassState,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(22.dp),
                containerColor = GreenAdvance.copy(alpha = 0.22f),
                borderColor = GreenAdvance.copy(alpha = 0.45f),
                padding = 22.dp
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "Current Outstanding (Udhar)",
                        color = Color.White.copy(alpha = 0.85f),
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Medium
                    )
                    Spacer(modifier = Modifier.height(6.dp))

                    AnimatedContent(
                        targetState = outstandingAmt,
                        transitionSpec = {
                            (slideInVertically { height -> height } + fadeIn()).togetherWith(
                                slideOutVertically { height -> -height } + fadeOut()
                            )
                        },
                        label = "outstanding_anim"
                    ) { targetAmount ->
                        Text(
                            text = "₹ $targetAmount",
                            color = Color.White,
                            fontSize = 32.sp,
                            fontWeight = FontWeight.ExtraBold,
                            letterSpacing = 0.5.sp
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // 3 Metrics Row
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                GlassCard(
                    state = glassState,
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    containerColor = Color.White.copy(alpha = 0.06f),
                    padding = 12.dp
                ) {
                    Column {
                        Text("Total Loaned", fontSize = 10.sp, color = TextSecondary)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "₹ ${summary?.totalLoanedTillDate?.toInt() ?: 125000}",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = RedUdhar
                        )
                    }
                }

                GlassCard(
                    state = glassState,
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    containerColor = Color.White.copy(alpha = 0.06f),
                    padding = 12.dp
                ) {
                    Column {
                        Text("Total Repaid", fontSize = 10.sp, color = TextSecondary)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "₹ ${summary?.totalRepaid?.toInt() ?: 110000}",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = GreenAdvance
                        )
                    }
                }

                GlassCard(
                    state = glassState,
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    containerColor = Color.White.copy(alpha = 0.06f),
                    padding = 12.dp
                ) {
                    Column {
                        Text("Advance", fontSize = 10.sp, color = TextSecondary)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "₹ ${summary?.advanceBalance?.toInt() ?: 18500}",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = PrimaryBlue
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Outstanding Breakdown Pie Chart
            OutstandingPieChartCard(
                summaries = summary?.customerBreakdown ?: emptyList(),
                totalOutstanding = summary?.currentOutstandingUdhar ?: 15000.0
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Quick Actions Row
            GlassCard(
                state = glassState,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                containerColor = Color.White.copy(alpha = 0.08f),
                padding = 16.dp
            ) {
                Column {
                    Text(
                        text = "Quick Actions",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(14.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        QuickActionButton(
                            icon = Icons.Default.ArrowUpward,
                            label = "Add Udhar",
                            tag = "quick_add_udhar",
                            color = RedUdhar,
                            modifier = Modifier.weight(1f),
                            onClick = { viewModel.selectTab("Record Entry") }
                        )
                        QuickActionButton(
                            icon = Icons.Default.ArrowDownward,
                            label = "Payment",
                            tag = "quick_receive_payment",
                            color = GreenAdvance,
                            modifier = Modifier.weight(1f),
                            onClick = { viewModel.selectTab("Record Entry") }
                        )
                        QuickActionButton(
                            icon = Icons.Default.Add,
                            label = "Advance",
                            tag = "quick_add_advance",
                            color = PrimaryBlue,
                            modifier = Modifier.weight(1f),
                            onClick = { viewModel.selectTab("Record Entry") }
                        )
                        QuickActionButton(
                            icon = Icons.Default.ShoppingCart,
                            label = "New Order",
                            tag = "quick_create_order",
                            color = Color(0xFFA78BFA),
                            modifier = Modifier.weight(1f),
                            onClick = { viewModel.isAddOrderOpen.value = true }
                        )
                        QuickActionButton(
                            icon = Icons.Default.Mic,
                            label = "AI Voice",
                            tag = "quick_voice_entry",
                            color = Color(0xFFFBBF24),
                            modifier = Modifier.weight(1f),
                            onClick = { viewModel.isVoiceEntryOpen.value = true }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Monthly Highlights
            GlassCard(
                state = glassState,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                containerColor = Color.White.copy(alpha = 0.08f),
                padding = 16.dp
            ) {
                Column {
                    Text(
                        text = "Summary (This Month)",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .background(RedBg.copy(alpha = 0.45f))
                                .border(0.8.dp, RedUdhar.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                                .padding(10.dp)
                        ) {
                            Column {
                                Text("Udhar Given", fontSize = 10.sp, color = RedUdhar)
                                Spacer(modifier = Modifier.height(2.dp))
                                Text("₹ 22,500", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = RedUdhar)
                            }
                        }

                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .background(GreenBg.copy(alpha = 0.45f))
                                .border(0.8.dp, GreenAdvance.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                                .padding(10.dp)
                        ) {
                            Column {
                                Text("Collection", fontSize = 10.sp, color = GreenAdvance)
                                Spacer(modifier = Modifier.height(2.dp))
                                Text("₹ 18,200", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GreenAdvance)
                            }
                        }

                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .background(PrimaryBlueBg.copy(alpha = 0.45f))
                                .border(0.8.dp, PrimaryBlue.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                                .padding(10.dp)
                        ) {
                            Column {
                                Text("Advance", fontSize = 10.sp, color = PrimaryBlue)
                                Spacer(modifier = Modifier.height(2.dp))
                                Text("₹ 9,500", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = PrimaryBlue)
                            }
                        }

                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .background(CardSurface)
                                .border(0.8.dp, Color.White.copy(alpha = 0.15f), RoundedCornerShape(12.dp))
                                .padding(10.dp)
                        ) {
                            Column {
                                Text("Orders", fontSize = 10.sp, color = TextSecondary)
                                Spacer(modifier = Modifier.height(2.dp))
                                Text("26", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                            }
                        }
                    }
                }
            }
        }

        // Floating liquid-glass top bar with real-time blur and border highlight
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .liquidGlass(
                    state = glassState,
                    shape = RoundedCornerShape(0.dp),
                    containerColor = Color(0x99071820),
                    borderColor = Color.White.copy(alpha = 0.18f),
                    shadowElevation = 6.dp
                )
                .drawBehind {
                    drawLine(
                        color = Color.White.copy(alpha = 0.12f),
                        start = androidx.compose.ui.geometry.Offset(0f, size.height),
                        end = androidx.compose.ui.geometry.Offset(size.width, size.height),
                        strokeWidth = 2f
                    )
                }
                .padding(horizontal = 16.dp, vertical = 10.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                IconButton(
                    onClick = onOpenDrawer,
                    modifier = Modifier
                        .testTag("hamburger_menu_btn")
                        .bouncyClickable(scaleDown = 0.88f, onClick = onOpenDrawer)
                ) {
                    Icon(Icons.Default.Menu, contentDescription = "Menu Drawer", tint = TextPrimary)
                }
                Spacer(modifier = Modifier.width(4.dp))
                Column {
                    Text(
                        text = "Merchant Dashboard",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Text(
                        text = profile?.shopName ?: "Shivam Kirana Store",
                        style = MaterialTheme.typography.bodySmall,
                        color = TextSecondary
                    )
                }
            }
            Row(verticalAlignment = Alignment.CenterVertically) {
                IconButton(
                    onClick = { viewModel.selectTab("Profile") },
                    modifier = Modifier
                        .testTag("header_profile_btn")
                        .bouncyClickable(scaleDown = 0.88f) { viewModel.selectTab("Profile") }
                ) {
                    Icon(Icons.Default.Person, contentDescription = "Merchant Profile", tint = PrimaryBlue)
                }
                IconButton(
                    onClick = { viewModel.logout() },
                    modifier = Modifier
                        .testTag("logout_btn")
                        .bouncyClickable(scaleDown = 0.88f) { viewModel.logout() }
                ) {
                    Icon(Icons.AutoMirrored.Filled.ExitToApp, contentDescription = "Logout", tint = RedUdhar)
                }
            }
        }
    }
}
