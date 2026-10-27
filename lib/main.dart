import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-warms fragment shaders to prevent first-frame jank
  await LiquidGlassWidgets.initialize();

  runApp(
    LiquidGlassWidgets.wrap(
      adaptiveQuality: true,
      respectSystemAccessibility: true,
      brightnessResolver: Theme.maybeBrightnessOf,
      theme: GlassThemeData.simple(
        blur: 16,
        thickness: 25,
        quality: GlassQuality.standard,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kantin Untirta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF222E3F), // Moody slate-blue background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          surface: Color(0x1FFFFFFF),
        ),
      ),
      home: const DaftarMenuPage(),
    );
  }
}

// =============================================================================
// SOAL 1: CUSTOM WIDGET TEKS REUSABLE (GOOGLE FONTS)
// =============================================================================

// Komentar Alasan Desain UI/UX (Apple Liquid Glass):
// Menggunakan font Poppins dari Google Fonts dengan bobot bervariasi (bold, w600, w500)
// untuk memastikan keterbacaan (legibility) tetap jernih dan kontras di atas permukaan kaca.
// Dipadukan estetika Apple Liquid Glass (refleksi rim specular putih dan smoked glass transparan).
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: -0.3,
      ),
    );
  }
}

// Helper: Format nominal ke Rupiah
String formatRupiah(int nominal) {
  return nominal.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

// Helper: Ikon kuliner dinamis
IconData getMenuIcon(String nama) {
  final q = nama.toLowerCase();
  if (q.contains('teh') || q.contains('jus') || q.contains('kopi') || q.contains('es ')) {
    return Icons.local_cafe_rounded;
  } else if (q.contains('mie') || q.contains('bakso') || q.contains('soto')) {
    return Icons.ramen_dining_rounded;
  } else if (q.contains('ayam') || q.contains('geprek')) {
    return Icons.lunch_dining_rounded;
  }
  return Icons.fastfood_rounded;
}

// =============================================================================
// SOAL 2: HALAMAN DAFTAR MENU (Sesuai Diagram Gambar 1 + Liquid Glass)
// =============================================================================

class DaftarMenuPage extends StatefulWidget {
  const DaftarMenuPage({super.key});

  @override
  State<DaftarMenuPage> createState() => _DaftarMenuPageState();
}

class _DaftarMenuPageState extends State<DaftarMenuPage> {
  final List<Map<String, dynamic>> menuList = [
    {'nama': 'Nasi Goreng Kantin Spesial', 'harga': 15000},
    {'nama': 'Mie Ayam Bakso Jumbo', 'harga': 13000},
    {'nama': 'Ayam Geprek Sambal Ijo', 'harga': 16000},
    {'nama': 'Es Teh Manis Segar', 'harga': 4000},
    {'nama': 'Jus Alpukat Kocok', 'harga': 8000},
  ];

  @override
  Widget build(BuildContext context) {
    // Hierarki Widget Sesuai Gambar 1:
    // Scaffold (Induk Utama)
    // ├── AppBar -> Text
    // ├── Column -> [Padding -> Text, Expanded -> ListView.builder -> Card -> ListTile (leading, title, subtitle, trailing)]
    // └── FloatingActionButton -> Icon
    return Scaffold(
      backgroundColor: const Color(0xFF222E3F),
      appBar: AppBar(
        backgroundColor: const Color(0x1AFFFFFF),
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0x33FFFFFF), width: 1.2),
        ),
        title: const CustomText(
          text: 'Kantin Untirta',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: const CustomText(
              text: 'Daftar Menu Makanan & Minuman',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 96, top: 4),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final item = menuList[index];
                // Card membungkus GlassContainer.card dari liquid_glass_widgets
                return Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: GlassContainer.card(
                    surfaceStyle: GlassSurfaceStyle.glass,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      leading: Icon(
                        getMenuIcon(item['nama']),
                        color: const Color(0xFF93C5FD), // Ice Blue glow
                        size: 30,
                      ),
                      title: CustomText(
                        text: item['nama'],
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      subtitle: CustomText(
                        text: 'Rp ${formatRupiah(item['harga'])}   •   Tersedia',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFDBA74), // Warm glass amber
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Color(0x99FFFFFF),
                      ),
                      onTap: () {
                        Get.to(() => DetailMenuPage(menu: item));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // FloatingActionButton dengan gaya Glass
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMenu = await Get.to(
            () => const TambahMenuPage(),
            transition: Transition.downToUp,
          );
          if (newMenu != null && newMenu is Map<String, dynamic>) {
            setState(() {
              menuList.add(newMenu);
            });
            Get.snackbar(
              'Menu Ditambahkan',
              '${newMenu['nama']} berhasil disimpan.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xE61E293B),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 20,
              icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399)),
              duration: const Duration(seconds: 2),
            );
          }
        },
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0x99FFFFFF), width: 1.8),
        ),
        backgroundColor: const Color(0x33FFFFFF), // Liquid Glass FAB
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
    );
  }
}

// =============================================================================
// HALAMAN DETAIL MENU (Pelengkap Navigasi Get.to() & Get.back())
// =============================================================================

class DetailMenuPage extends StatelessWidget {
  final Map<String, dynamic> menu;

  const DetailMenuPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222E3F),
      appBar: AppBar(
        backgroundColor: const Color(0x1AFFFFFF),
        elevation: 0,
        title: const CustomText(
          text: 'Detail Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: GlassContainer.card(
            surfaceStyle: GlassSurfaceStyle.glass,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0x1FFFFFFF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x66FFFFFF), width: 2),
                    ),
                    child: Icon(
                      getMenuIcon(menu['nama']),
                      size: 64,
                      color: const Color(0xFF93C5FD),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: menu['nama'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x66FFFFFF), width: 1.5),
                    ),
                    child: CustomText(
                      text: 'Rp ${formatRupiah(menu['harga'])}',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFDBA74),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x33FFFFFF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Color(0x8CFFFFFF), width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const CustomText(
                      text: 'Kembali',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
// SOAL 3: HALAMAN TAMBAH MENU (Sesuai Diagram Gambar 2 + Liquid Glass)
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
      final String nama = _namaController.text.trim();
      final int harga = int.parse(_hargaController.text.trim());

      Get.back(result: {
        'nama': nama,
        'harga': harga,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hierarki Widget Sesuai Gambar 2:
    // Scaffold (Induk Utama)
    // ├── AppBar -> Text
    // └── Padding -> Form -> Column -> [TextFormField, SizedBox, TextFormField, SizedBox, ElevatedButton -> Text]
    return Scaffold(
      backgroundColor: const Color(0xFF222E3F),
      appBar: AppBar(
        backgroundColor: const Color(0x1AFFFFFF),
        elevation: 0,
        title: const CustomText(
          text: 'Tambah Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Nama Menu',
                  labelStyle: GoogleFonts.poppins(color: const Color(0xB3FFFFFF), fontSize: 14),
                  hintText: 'Contoh: Nasi Goreng Spesial',
                  hintStyle: GoogleFonts.poppins(color: const Color(0x66FFFFFF), fontSize: 14),
                  prefixIcon: const Icon(Icons.fastfood_outlined, color: Color(0xFF93C5FD)),
                  filled: true,
                  fillColor: const Color(0x1FFFFFFF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x66FFFFFF), width: 1.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x66FFFFFF), width: 1.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.6),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFF87171), width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _simpanMenu(),
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Harga Menu (Rp)',
                  labelStyle: GoogleFonts.poppins(color: const Color(0xB3FFFFFF), fontSize: 14),
                  hintText: 'Contoh: 15000',
                  hintStyle: GoogleFonts.poppins(color: const Color(0x66FFFFFF), fontSize: 14),
                  prefixIcon: const Icon(Icons.payments_outlined, color: Color(0xFF93C5FD)),
                  filled: true,
                  fillColor: const Color(0x1FFFFFFF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x66FFFFFF), width: 1.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x66FFFFFF), width: 1.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.6),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFF87171), width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _simpanMenu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x33FFFFFF), // Liquid Glass Button
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0x33000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0x8CFFFFFF), width: 1.6),
                  ),
                  minimumSize: const Size.fromHeight(54),
                ),
                child: const CustomText(
                  text: 'Simpan Menu Baru',
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
