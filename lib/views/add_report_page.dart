import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/views/detail_report.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<AddReportPage> {
  // Variabel untuk menyimpan nilai yang dipilih
  String? _selectedCategory;
  String? _selectedFacility;

  // Variabel untuk upload foto
  List<String> _selectedImages = [];

  // data buat dropdown
  final List<String> _categories = [
    'AC',
    'Kursi',
    'Lampu',
    'Meja',
    'Saluran Air',
    'Lainnya',
  ];

  final List<String> _facilities = [
    'Ruang Kelas',
    'Lapangan',
    'Laboratorium',
    'Aula',
    'Taman',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Buat Laporan",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Lengkapi informasi kerusakan",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),

              // Label Kategori
              Text(
                "Kategori Kerusakan",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown Kategori
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      hint: Text(
                        'Pilih Kategori',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Label Fasilitas
              Text(
                "Fasilitas",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown Fasilitas
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFacility,
                      hint: Text(
                        'Pilih Fasilitas',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      isExpanded: true,
                      items: _facilities.map((facility) {
                        return DropdownMenuItem(
                          value: facility,
                          child: Text(
                            facility,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFacility = value;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Label Detail Lokasi
              Text(
                "Detail Lokasi",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // TextField Detail Lokasi
              TextField(
                decoration: InputDecoration(
                  hintText: "Contoh: Lantai 2, dekat jendela",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: fromCssColor("#547792"),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Label Deskripsi
              Text(
                "Deskripsi",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 8),
              // TextField Deskripsi
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Jelaskan detail kerusakan",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: fromCssColor("#547792"),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 20),

              // Label Upload Foto
              Text(
                "Upload Foto",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // hitung ukuran kotak persegi (3 kolom)
                      double boxSize = (constraints.maxWidth - 16) / 3;

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Tombol upload (kotak persegi)
                          GestureDetector(
                            onTap: () {
                              _showImagePickerOptions();
                            },
                            child: Container(
                              width: boxSize,
                              height: boxSize,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 30,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Upload",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Preview foto yang sudah dipilih
                          ...List.generate(_selectedImages.length, (index) {
                            return Stack(
                              children: [
                                Container(
                                  width: boxSize,
                                  height: boxSize,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        _selectedImages[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 255, 58, 40),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),

                          // Tambahkan placeholder kosong untuk menjaga layout persegi
                          if (_selectedImages.length < 2)
                            ...List.generate(2 - _selectedImages.length, (
                              index,
                            ) {
                              return Container(
                                width: boxSize,
                                height: boxSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(color: Colors.grey[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  // Info maksimal foto
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Maksimal 2 foto",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_selectedCategory != null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("Laporan berhasil dibuat")),
                    //   );
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("Pilih kategori terlebih dahulu")),
                    //   );
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailReport()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fromCssColor("#FAB95B"),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Kirim Laporan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan opsi upload foto
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "Pilih Foto",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 36, 53, 80),
                ),
                title: Text("Ambil Foto", style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  // Tambahkan fungsi ambil foto dari kamera
                  print("Ambil foto dari kamera");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color.fromARGB(255, 36, 53, 80),
                ),
                title: Text("Pilih dari Galeri", style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  // Tambahkan fungsi pilih foto dari galeri
                  print("Pilih foto dari galeri");

                  // Contoh preview foto (sementara)
                  setState(() {
                    if (_selectedImages.length < 2) {
                      _selectedImages.add(
                        "https://picsum.photos/200/150?random=${_selectedImages.length}",
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Maksimal 2 foto")),
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
