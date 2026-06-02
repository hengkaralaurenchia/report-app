import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/services/report_service.dart';
import 'package:report_app/utils/string_helper.dart';
import 'package:report_app/views/admin/update_status_page.dart';
import 'package:report_app/services/auth_service.dart';
import 'package:report_app/views/login_page.dart';
import 'package:report_app/services/export_service.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<dynamic> _reports = [];
  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  String _selectedSort = 'Terbaru';

  final List<String> _filterOptions = [
    'Semua',
    'Pending',
    'Diproses',
    'Selesai',
  ];
  final List<String> _sortOptions = [
    'Terbaru',
    'Terlama',
    'Jenis A-Z',
    'Lokasi A-Z',
  ];

  int get _totalReports => _reports.length;
  int get _totalPending =>
      _reports.where((r) => r['status'] == 'pending').length;
  int get _totalProcessed =>
      _reports.where((r) => r['status'] == 'processed').length;
  int get _totalDone => _reports.where((r) => r['status'] == 'done').length;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    String? status;
    if (_selectedFilter == 'Pending') status = 'pending';
    if (_selectedFilter == 'Diproses') status = 'processed';
    if (_selectedFilter == 'Selesai') status = 'done';

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
      case 'Lokasi A-Z':
        sortBy = 'location';
        order = 'ASC';
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

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _fetchReports();
  }

  void _updateSort(String sort) {
    setState(() {
      _selectedSort = sort;
    });
    _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Dashboard Admin",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            onPressed: () => ExportService.exportToPdf(
              _reports,
              'Laporan Kerusakan Fasilitas',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statistik Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    "Total",
                    _totalReports,
                    const Color(0xFF547792),
                    Colors.blue[50]!,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    "Pending",
                    _totalPending,
                    Colors.orange,
                    Colors.orange[50]!,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    "Diproses",
                    _totalProcessed,
                    const Color(0xFFFAB95B),
                    const Color(0xFFFAB95B).withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    "Selesai",
                    _totalDone,
                    Colors.green,
                    Colors.green[50]!,
                  ),
                ],
              ),
            ),

            // pie chart
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statistik Status Laporan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: _totalPending.toDouble(),
                            title: 'Pending',
                            color: Colors.orange,
                            radius: 60,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: _totalProcessed.toDouble(),
                            title: 'Diproses',
                            color: const Color(0xFFFAB95B),
                            radius: 60,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: _totalDone.toDouble(),
                            title: 'Selesai',
                            color: Colors.green,
                            radius: 60,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend("Pending", Colors.orange),
                      const SizedBox(width: 16),
                      _buildLegend("Diproses", const Color(0xFFFAB95B)),
                      const SizedBox(width: 16),
                      _buildLegend("Selesai", Colors.green),
                    ],
                  ),
                ],
              ),
            ),

            //bar chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporan per Bulan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _getMaxReportCount().toDouble(),
                        barGroups: _getBarGroups(),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'Mei',
                                  'Jun',
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: GoogleFonts.poppins(fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter & Sort
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          icon: const Icon(Icons.filter_list, size: 18),
                          isExpanded: true,
                          items: _filterOptions.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(
                                filter,
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) _updateFilter(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSort,
                          icon: const Icon(Icons.sort, size: 18),
                          isExpanded: true,
                          items: _sortOptions.map((sort) {
                            return DropdownMenuItem(
                              value: sort,
                              child: Text(
                                sort,
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) _updateSort(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // List Laporan
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reports.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tidak ada laporan'),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final report = _reports[index];
                      return _buildReportCard(report);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final monthlyData = _getMonthlyReportCount();
    return List.generate(6, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthlyData[index].toDouble(),
            color: const Color(0xFF547792),
            width: 30,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  List<int> _getMonthlyReportCount() {
    List<int> monthlyCount = List.filled(6, 0);
    for (var report in _reports) {
      final createdAt = report['createdAt'];
      if (createdAt != null) {
        try {
          final month = DateTime.parse(createdAt).month;
          if (month >= 1 && month <= 6) {
            monthlyCount[month - 1]++;
          }
        } catch (e) {}
      }
    }
    return monthlyCount;
  }

  double _getMaxReportCount() {
    final monthlyData = _getMonthlyReportCount();
    return monthlyData.isEmpty
        ? 10
        : (monthlyData.reduce((a, b) => a > b ? a : b) + 2).toDouble();
  }

  Widget _buildStatCard(String title, int count, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
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
    bool isDone = report['status'] == 'done';

    if (report['status'] == 'pending') {
      statusColor = Colors.orange;
      statusText = 'Pending';
    } else if (report['status'] == 'processed') {
      statusColor = const Color(0xFFFAB95B);
      statusText = 'Diproses';
    } else {
      statusColor = Colors.green;
      statusText = 'Selesai';
    }

    String userName = StringHelper.getFirstName(report['user']?['name'] ?? '-');

    return GestureDetector(
      onTap: isDone
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateStatusPage(report: report),
                ),
              );
              if (result == true) {
                _fetchReports();
              }
            },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    report['location'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
