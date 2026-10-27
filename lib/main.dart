import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pencatat Menu Kantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const DaftarMenuPage(),
    );
  }
}

// =============================================================================
// SOAL 1: CUSTOM WIDGET TEKS
// =============================================================================

// Komentar Alasan Desain:
// Menggunakan font Poppins dari Google Fonts karena memiliki keterbacaan (legibility)
// yang sangat baik untuk antarmuka aplikasi mobile modern dan memberi kesan bersih.
// Custom widget ini fleksibel menerima parameter fontSize, fontWeight, dan color.
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

// =============================================================================
// SOAL 2: HALAMAN DAFTAR MENU (Sesuai Gambar 1)
// =============================================================================

class DaftarMenuPage extends StatefulWidget {
  const DaftarMenuPage({super.key});

  @override
  State<DaftarMenuPage> createState() => _DaftarMenuPageState();
}

class _DaftarMenuPageState extends State<DaftarMenuPage> {
  // Minimal 5 data awal
  final List<Map<String, dynamic>> menuList = [
    {'nama': 'Nasi Goreng Kantin', 'harga': 15000},
    {'nama': 'Mie Ayam Bakso', 'harga': 13000},
    {'nama': 'Ayam Geprek Sambal Ijo', 'harga': 16000},
    {'nama': 'Es Teh Manis', 'harga': 4000},
    {'nama': 'Jus Alpukat', 'harga': 8000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Kantin Untirta',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const CustomText(
              text: 'Daftar Menu Makanan & Minuman',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final item = menuList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.fastfood, color: Colors.deepOrange),
                    title: CustomText(
                      text: item['nama'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: CustomText(
                      text: 'Rp ${item['harga']}',
                      fontSize: 14,
                      color: Colors.grey[700]!,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Buka halaman detail menu
                      Get.to(() => DetailMenuPage(menu: item));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke Halaman Tambah Menu dan tunggu hasilnya
          final newMenu = await Get.to(() => const TambahMenuPage());
          if (newMenu != null && newMenu is Map<String, dynamic>) {
            setState(() {
              menuList.add(newMenu);
            });
          }
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// =============================================================================
// HALAMAN DETAIL MENU (Pelengkap Navigasi)
// =============================================================================

class DetailMenuPage extends StatelessWidget {
  final Map<String, dynamic> menu;

  const DetailMenuPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Detail Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange),
                  const SizedBox(height: 16),
                  CustomText(
                    text: menu['nama'],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: 'Harga: Rp ${menu['harga']}',
                    fontSize: 18,
                    color: Colors.grey[800]!,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const CustomText(text: 'Kembali', fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SOAL 3: HALAMAN TAMBAH MENU (Sesuai Gambar 2)
// =============================================================================

class TambahMenuPage extends StatefulWidget {
  const TambahMenuPage({super.key});

  @override
  State<TambahMenuPage> createState() => _TambahMenuPageState();
}

class _TambahMenuPageState extends State<TambahMenuPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _simpanMenu() {
    if (_formKey.currentState!.validate()) {
      final String nama = _namaController.text;
      final int harga = int.parse(_hargaController.text);

      // Mengirimkan data kembali menggunakan Get.back(result: ...)
      Get.back(result: {
        'nama': nama,
        'harga': harga,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Tambah Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanMenu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const CustomText(
                  text: 'Simpan',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}