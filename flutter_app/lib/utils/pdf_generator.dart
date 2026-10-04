import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/models.dart';

class PdfStatementGenerator {
  static Future<Uint8List> generateStatementPdf({
    required Customer customer,
    required List<LedgerTransaction> transactions,
    required ShopProfile shop,
  }) async {
    final pdf = pw.Document();

    double totalUdhaar = 0;
    double totalPayment = 0;
    for (final tx in transactions) {
      if (tx.type == 'UDHAAR') {
        totalUdhaar += tx.amount;
      } else if (tx.type == 'PAYMENT') {
        totalPayment += tx.amount;
      } else if (tx.type == 'ADVANCE') {
        totalPayment += tx.amount;
      }
    }
    final netBalance = totalUdhaar - totalPayment;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      shop.shopName.isNotEmpty ? shop.shopName : 'Shivam Kirana Store',
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.deepOrange900),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Digital Bahi-Khata Statement', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    pw.Text('Merchant Contact: ${shop.email}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.orange50,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColors.orange300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('STATEMENT DATE', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                      pw.Text(
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(color: PdfColors.grey300, thickness: 1),
            pw.SizedBox(height: 16),

            // Customer Info & Summary Box Row
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Customer Profile Details
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('CUSTOMER DETAILS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                        pw.SizedBox(height: 6),
                        pw.Text(customer.name, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 2),
                        pw.Text('Phone: ${customer.phone}', style: const pw.TextStyle(fontSize: 11)),
                        pw.Text('Address: ${customer.location}', style: const pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 16),

                // Financial Balance Card
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: netBalance > 0 ? PdfColors.red50 : PdfColors.green50,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: netBalance > 0 ? PdfColors.red300 : PdfColors.green300),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('CLOSING BALANCE SUMMARY', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total Udhaar (Given):', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('Rs. ${totalUdhaar.toInt()}', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
                          ],
                        ),
                        pw.SizedBox(height: 2),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total Received:', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('Rs. ${totalPayment.toInt()}', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Divider(color: netBalance > 0 ? PdfColors.red200 : PdfColors.green200),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              netBalance >= 0 ? 'NET DUE AMOUNT:' : 'ADVANCE BALANCE:',
                              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Rs. ${netBalance.abs().toInt()}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: netBalance > 0 ? PdfColors.red900 : PdfColors.green900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 24),

            // Transactions Table
            pw.Text('TRANSACTION HISTORY', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
            pw.SizedBox(height: 8),

            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Type', 'Note', 'Mode', 'Amount'],
              data: transactions.map((tx) {
                final dateStr = '${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}';
                final isUdhaar = tx.type == 'UDHAAR';
                return [
                  dateStr,
                  tx.type,
                  tx.note.isNotEmpty ? tx.note : '-',
                  tx.paymentMethod,
                  isUdhaar ? '+ Rs. ${tx.amount.toInt()}' : '- Rs. ${tx.amount.toInt()}',
                ];
              }).toList(),
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey800),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
              },
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),

            pw.SizedBox(height: 30),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),

            // Footer
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
                pw.Text('Generated via Udhar Khata Mobile App', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrShareStatement({
    required Customer customer,
    required List<LedgerTransaction> transactions,
    required ShopProfile shop,
  }) async {
    final pdfBytes = await generateStatementPdf(
      customer: customer,
      transactions: transactions,
      shop: shop,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Udhar_Khata_${customer.name.replaceAll(' ', '_')}.pdf',
    );
  }
}
