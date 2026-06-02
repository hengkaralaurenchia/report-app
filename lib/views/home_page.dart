// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/views/detail_report_page.dart';
import 'package:report_app/views/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:report_app/views/add_report_page.dart';
import 'package:report_app/services/auth_service.dart';
import 'package:report_app/views/login_page.dart';
import 'package:report_app/services/report_service.dart';
import 'package:report_app/utils/string_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = "";
  List<dynamic> _reports = [];
  bool _isLoading = true;
  int _totalLaporan = 0;
  int _totalDiproses = 0;
  int _totalSelesai = 0;
  int _totalPending = 0;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchReports();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('name') ?? 'User';
    });
  }

  void _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ReportService.getReports(
      sortBy: 'createdAt',
      order: 'DESC',
    );

    if (result['status'] == 200) {
      final List<dynamic> data = result['data'];
      setState(() {
        _reports = data;
        _totalLaporan = data.length;
        _totalPending = data.where((r) => r['status'] == 'pending').length;
        _totalDiproses = data.where((r) => r['status'] == 'processed').length;
        _totalSelesai = data.where((r) => r['status'] == 'done').length;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal mengambil data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // welcome text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome ${StringHelper.getFirstName(_username)}! 👋🏻", 
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Laporkan kerusakan fasilitas dengan mudah",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // buat laporan
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: fromCssColor("#547792"),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Buat Laporan Baru",
                            style: GoogleFonts.poppins(
                              color: fromCssColor("#FFFFFF"),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Laporkan kerusakan fasilitas",
                            style: GoogleFonts.poppins(
                              color: fromCssColor("#FFFFFF"),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(width: 5),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: fromCssColor("#FAB95B"),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddReportPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: fromCssColor("#FAB95B"),
                            fixedSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Statistik Saya
              Text(
                "Statistik Saya",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              // Statistik cards
              Row(
                children: [
                  _buildStatCard(
                    "Laporan",
                    _totalLaporan,
                    fromCssColor("#1E3A8A"),
                    Colors.blue[50]!,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    "Pending",
                    _totalPending,
                    Colors.orange[600]!,
                    Colors.orange[50]!,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    "Diproses",
                    _totalDiproses,
                    Colors.amber[600]!,
                    Colors.amber[50]!,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    "Selesai",
                    _totalSelesai,
                    Colors.green[600]!,
                    Colors.green[50]!,
                  ),
                ],
              ),
              // Laporan terbaru
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Laporan Terbaru",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportHistoryPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 3,
                      ),
                      child: Text(
                        "Lihat semua",
                        style: GoogleFonts.poppins(
                          color: fromCssColor("#547792"),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // List laporan terbaru
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reports.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            "Belum ada laporan",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reports.length > 3 ? 3 : _reports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailReportPage(report: report),
                              ),
                            ).then((_) {
                              _fetchReports();
                            });
                          },
                          child: _buildReportCard(report),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    Color textColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    Color statusColor;
    String statusText;

    if (report['status'] == 'pending') {
      statusColor = Colors.orange;
      statusText = 'Pending';
    } else if (report['status'] == 'processed') {
      statusColor = Colors.blue;
      statusText = 'Diproses';
    } else {
      statusColor = Colors.green;
      statusText = 'Selesai';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  report['type'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    report['location'] ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                _formatDate(report['createdAt'] ?? ''),
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    if (dateTime.isEmpty) return '';
    try {
      final date = DateTime.parse(dateTime);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateTime;
    }
  }
}
