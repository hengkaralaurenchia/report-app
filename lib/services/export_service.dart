import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportToPdf(List<dynamic> reports, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('No'),
                      pw.Text('Jenis Kerusakan'),
                      pw.Text('Lokasi'),
                      pw.Text('Status'),
                      pw.Text('Tanggal'),
                    ],
                  ),
                  ...List.generate(reports.length, (index) {
                    final report = reports[index];
                    final statusText = report['status'] == 'pending'
                        ? 'Pending'
                        : report['status'] == 'processed'
                        ? 'Diproses'
                        : 'Selesai';
                    final date = report['createdAt'] != null
                        ? DateTime.parse(
                            report['createdAt'],
                          ).toString().substring(0, 10)
                        : '-';
                    return pw.TableRow(
                      children: [
                        pw.Text('${index + 1}'),
                        pw.Text(report['type'] ?? '-'),
                        pw.Text(report['location'] ?? '-'),
                        pw.Text(statusText),
                        pw.Text(date),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Dicetak pada: ${DateTime.now().toString().substring(0, 19)}',
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/laporan_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Laporan Kerusakan Fasilitas');
  }
}
