import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportHistoryPage extends StatelessWidget {
  const ReportHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Riwayat Laporan",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelColor: const Color(0xFF547792),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF547792),
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Pending'),
              Tab(text: 'Diproses'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Semua")),
            Center(child: Text("Pending")),
            Center(child: Text("Diproses")),
            Center(child: Text("Selesai")),
          ],
        ),
      ),
    );
  }
}