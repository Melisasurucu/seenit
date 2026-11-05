// Flutter'ın hazır arayüz parçalarını projeye getirir.
import 'package:flutter/material.dart';
// Supabase paketini getirir. Giriş yapma işlemini bununla yapacağız.
import 'package:supabase_flutter/supabase_flutter.dart';
// Kayıt ekranı dosyasını bağlar. 'Kayıt ol' yazısına basınca o ekrana gideceğiz.
import 'kayit_ekrani.dart';
// Ana sayfa dosyasını bağlar. Giriş başarılı olunca o ekrana geçeceğiz.
import 'ana_sayfa_ekrani.dart';

// =============================================================================
// GİRİŞ EKRANI (LoginScreen)
// =============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _epostaController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  bool _yukleniyor = false;

  @override
  void dispose() {
    _epostaController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  void _mesajGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  // ---------------------------------------------------------------------------
  // GİRİŞ YAPMA İŞLEMİ (Supabase ile)
  // ---------------------------------------------------------------------------
  Future<void> _girisYap() async {
    final eposta = _epostaController.text.trim();
    final sifre = _sifreController.text;

    if (eposta.isEmpty || sifre.isEmpty) {
      _mesajGoster('E-posta ve şifreni yaz.');
      return;
    }

    setState(() => _yukleniyor = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: eposta,
        password: sifre,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on AuthException {
      _mesajGoster('Giriş yapılamadı: e-posta veya şifre hatalı.');
    } catch (_) {
      _mesajGoster('Bir sorun oluştu. İnternet bağlantını kontrol et.');
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // ---------------------------------------------------------------------------
  // ŞİFREMİ UNUTTUM AÇILIR PENCERESİ
  // ---------------------------------------------------------------------------
  void _sifremiUnuttumPenceresi() {
    final TextEditingController pencereEpostaController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E202C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Şifremi Unuttum',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesabınıza bağlı e-posta adresinizi girin. Size bir sıfırlama bağlantısı göndereceğiz.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pencereEpostaController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ornek@email.com',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF12141D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3B32A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final eposta = pencereEpostaController.text.trim();
              Navigator.pop(dialogContext);
              if (eposta.isEmpty) return;
              try {
                await Supabase.instance.client.auth.resetPasswordForEmail(eposta);
              } catch (_) {}
              if (!mounted) return;
              _mesajGoster('Adres kayıtlıysa sıfırlama bağlantısı gönderildi.');
            },
            child: const Text(
              'Gönder',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GİRİŞ EKRANI ARAYÜZÜ (BUILD)
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12151C),
      body: Stack(
        children: [
          // 1. KATMAN: Arka Plan Resmi
          Positioned.fill(
            child: Image.asset(
              'assets/images/arkaplan.jpg', // Resminin adı farklıysa burayı değiştir
              fit: BoxFit.cover,
            ),
          ),

          // 2. KATMAN: Koyu Karartma Overlay (Yazılar rahat okunsun diye)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),

          // 3. KATMAN: Ana Ekran Form İçeriği
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // ----- LOGO VE BAŞLIK ALANI -----
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3B32A),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Seenit',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'İzle, hisset, paylaş',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),

                          // ----- E-POSTA KUTUSU -----
                          const Text(
                            'E-posta',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _epostaController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'ornek@email.com',
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFF1E202C).withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ----- ŞİFRE KUTUSU -----
                          const Text(
                            'Şifre',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _sifreController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Şifren',
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFF1E202C).withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          // ----- ŞİFREMİ UNUTTUM BUTONU -----
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _sifremiUnuttumPenceresi,
                              child: const Text(
                                'Şifremi unuttum',
                                style: TextStyle(color: Color(0xFFF3B32A)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ----- GİRİŞ YAP BUTONU -----
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3B32A),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _yukleniyor ? null : _girisYap,
                            child: _yukleniyor
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Giriş yap',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),

                          // ----- KAYIT OL YÖNLENDİRMESİ -----
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Hesabın yok mu? ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Kayıt ol',
                                  style: TextStyle(
                                    color: Color(0xFFF3B32A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}