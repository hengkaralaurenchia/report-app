import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/services/report_service.dart';
import 'package:report_app/views/edit_report_page.dart';

class DetailReportPage extends StatefulWidget {
  final Map<String, dynamic> report;

  const DetailReportPage({super.key, required this.report});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  late Map<String, dynamic> _report;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ReportService.getReportById(widget.report['id']);

    if (result['status'] == 200) {
      setState(() {
        _report = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil detail laporan')),
      );
    }
  }

  Future<void> _cancelReport() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          "Batalkan Laporan",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Apakah Anda yakin ingin membatalkan laporan ini?",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Tidak",
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); //tutup dialog

              setState(() {
                _isLoading = true;
              });

              // api delete report
              final result = await ReportService.deleteReport(_report['id']);

              setState(() {
                _isLoading = false;
              });

              if (result['status'] == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Laporan berhasil dibatalkan"),
                    backgroundColor: Colors.green,
                  ),
                );
                // kembali ke halaman sebelumnya
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result['message'] ?? 'Gagal membatalkan laporan',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Ya, Batalkan",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReportPage(report: widget.report),
      ),
    ).then((_) {
      // refresh detail setelah edit
      _fetchDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = _report['status'] ?? 'pending';
    final isPending = status == 'pending';
    final statusColor = status == 'pending'
        ? Colors.orange
        : status == 'processed'
        ? Colors.blue
        : status == 'done'
        ? Colors.green
        : Colors.grey;
    final statusText = status == 'pending'
        ? 'Pending'
        : status == 'processed'
        ? 'Diproses'
        : status == 'done'
        ? 'Selesai'
        : 'Dibatalkan';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Detail Laporan",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //bagde status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            "Jenis Kerusakan",
                            _report['type'] ?? '-',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow("Lokasi", _report['location'] ?? '-'),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            "Tanggal Dibuat",
                            _formatDate(_report['createdAt'] ?? ''),
                          ),
                          if (_report['estimated_completion'] != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              "Estimasi Selesai",
                              _formatDate(_report['estimated_completion']),
                            ),
                          ],
                          if (_report['completed_at'] != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              "Tanggal Selesai",
                              _formatDate(_report['completed_at']),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    Text(
                      "Deskripsi",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        _report['description'] ?? '-',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),

                    // Foto Laporan
                    const SizedBox(height: 20),
                    Text(
                      "Foto Laporan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _report['image'] != null &&
                            _report['image'].toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _report['image'],
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 250,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Text('Gagal memuat gambar'),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Text('Tidak ada foto')),
                          ),

                    // Foto Perbaikan
                    if (_report['fix_image'] != null &&
                        _report['fix_image'].toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        "Foto Perbaikan",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _report['fix_image'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Text('Gagal memuat gambar'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    // button edit dan hapus : ada kalau status nya pending
                    if (isPending) ...[
                      Row(
                        children: [
                          // button batalkan
                          Expanded(
                            flex: 4,
                            child: OutlinedButton(
                              onPressed: _cancelReport,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 148, 141),
                                  width: 3,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Batalkan",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // button edit
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _editReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFAB95B),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateTime) {
    if (dateTime.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateTime);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateTime;
    }
  }
}
