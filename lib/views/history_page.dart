import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/services/report_service.dart';
import 'package:report_app/views/detail_report_page.dart';

class ReportHistoryPage extends StatefulWidget {
  const ReportHistoryPage({super.key});

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  String _selectedSort = 'Terbaru';
  String _selectedFilter = 'Semua';
  List<dynamic> _reports = [];
  bool _isLoading = true;

  final List<String> _sortOptions = [
    'Terbaru',
    'Terlama',
    'Jenis A-Z',
    'Jenis Z-A',
    'Lokasi A-Z',
    'Lokasi Z-A',
  ];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    // mapping filter ke status
    String? status;
    if (_selectedFilter == 'Pending') status = 'pending';
    if (_selectedFilter == 'Diproses') status = 'processed';
    if (_selectedFilter == 'Selesai') status = 'done';

    // mapping sorting
    String? sortBy;
    String? order;
    switch (_selectedSort) {
      case 'Terbaru':
        sortBy = 'createdAt';
        order = 'DESC';
        break;
      case 'Terlama':
        sortBy = 'createdAt';
        order = 'ASC';
        break;
      case 'Jenis A-Z':
        sortBy = 'type';
        order = 'ASC';
        break;
      case 'Jenis Z-A':
        sortBy = 'type';
        order = 'DESC';
        break;
      case 'Lokasi A-Z':
        sortBy = 'location';
        order = 'ASC';
        break;
      case 'Lokasi Z-A':
        sortBy = 'location';
        order = 'DESC';
        break;
    }

    final result = await ReportService.getReports(
      status: status,
      sortBy: sortBy,
      order: order,
    );

    if (result['status'] == 200) {
      setState(() {
        _reports = result['data'];
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

  void _onSortChanged(String value) {
    setState(() {
      _selectedSort = value;
    });
    _fetchReports();
  }

  void _onFilterChanged(String value) {
    setState(() {
      _selectedFilter = value;
    });
    _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Laporan",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: Colors.black),
              onSelected: _onSortChanged,
              itemBuilder: (context) {
                return _sortOptions.map((option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Row(
                      children: [
                        if (_selectedSort == option)
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                        if (_selectedSort != option) const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(option),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            labelColor: const Color(0xFF547792),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF547792),
            onTap: (index) {
              String filter = '';
              if (index == 0) filter = 'Semua';
              if (index == 1) filter = 'Pending';
              if (index == 2) filter = 'Diproses';
              if (index == 3) filter = 'Selesai';
              _onFilterChanged(filter);
            },
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Pending'),
              Tab(text: 'Diproses'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reports.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada laporan',
                      style: GoogleFonts.poppins(color: Colors.grey[400]),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _reports.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return GestureDetector(
                    onTap: () {
                      // ke history
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
