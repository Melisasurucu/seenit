// Flutter'ın hazır arayüz parçalarını projeye getirir.
import 'package:flutter/material.dart';
// Supabase paketini getirir. Hesap açma işlemini bununla yapacağız.
import 'package:supabase_flutter/supabase_flutter.dart';
// Ana sayfa dosyasını bağlar. Kayıt başarılı olunca o ekrana geçeceğiz.
import 'ana_sayfa_ekrani.dart';

// =============================================================================
// KAYIT OL EKRANI (RegisterScreen)
// =============================================================================
// 'StatefulWidget': yazılan bilgileri hatırlaması ve "yükleniyor" durumu için içeriği değişebilen ekran.
class RegisterScreen extends StatefulWidget {
  // Yapıcı metot: ekranı oluştururken kullanılır.
  const RegisterScreen({super.key});

  // Ekranın değişebilen kısmını (durumunu) yöneten sınıfı oluşturur.
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// Kayıt ekranının durumunu ve işlevlerini tutan sınıf.
class _RegisterScreenState extends State<RegisterScreen> {
  // Kullanıcı adı kutusuna yazılanı okumak için.
  final TextEditingController _kullaniciAdiController = TextEditingController();
  // E-posta kutusuna yazılanı okumak için.
  final TextEditingController _epostaController = TextEditingController();
  // Şifre kutusuna yazılanı okumak için.
  final TextEditingController _sifreController = TextEditingController();
  // Şifre tekrar kutusuna yazılanı okumak için.
  final TextEditingController _sifreTekrarController = TextEditingController();
  // Kayıt işlemi sürerken true olur. Butonu kilitler ve dönen simge gösterir.
  bool _yukleniyor = false;

  // Ekran kapanırken çalışır. Kutu yapılarını temizler.
  @override
  void dispose() {
    // Dört kutunun yapısını sırayla temizler.
    _kullaniciAdiController.dispose();
    _epostaController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    // Üst sınıfın temizlik işlemini de çalıştırır.
    super.dispose();
  }

  // Ekranın altında kısa süreli bir bilgi mesajı gösteren yardımcı fonksiyon.
  void _mesajGoster(String mesaj) {
    // Ekranın mesaj yöneticisini bulur ve verilen metni gösteren bir çubuk koyar.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  // ---------------------------------------------------------------------------
  // KAYIT OLMA İŞLEMİ (Supabase ile)
  // ---------------------------------------------------------------------------
  // 'async': internetten cevap beklenen bir işlem olduğunu gösterir.
  Future<void> _kayitOl() async {
    // Kutulara yazılanları alır. 'trim' baştaki ve sondaki boşlukları siler.
    final kullaniciAdi = _kullaniciAdiController.text.trim();
    final eposta = _epostaController.text.trim();
    final sifre = _sifreController.text;
    final sifreTekrar = _sifreTekrarController.text;

    // Kontrol 1: Kutulardan biri boşsa uyarır ve durdurur.
    if (kullaniciAdi.isEmpty || eposta.isEmpty || sifre.isEmpty) {
      _mesajGoster('Bütün alanları doldur.');
      return;
    }
    // Kontrol 2: Şifre 8 karakterden kısaysa uyarır ve durdurur.
    if (sifre.length < 8) {
      _mesajGoster('Şifre en az 8 karakter olmalı.');
      return;
    }
    // Kontrol 3: İki şifre kutusu aynı değilse uyarır ve durdurur.
    if (sifre != sifreTekrar) {
      _mesajGoster('Şifreler aynı değil.');
      return;
    }

    // Ekranı "yükleniyor" durumuna alır. setState, ekranın yeniden çizilmesini sağlar.
    setState(() => _yukleniyor = true);
    // 'try': içindeki kodu dener, hata çıkarsa aşağıdaki 'catch' kısımları çalışır.
    try {
      // Supabase'te yeni hesap açar ve cevabı 'cevap' değişkenine koyar.
      final cevap = await Supabase.instance.client.auth.signUp(
        // Hesabın e-postası.
        email: eposta,
        // Hesabın şifresi (Supabase bunu şifreli saklar).
        password: sifre,
        // Ek bilgi: kullanıcı adı. Veri tabanındaki kural bunu 'profiller' tablosuna otomatik yazar.
        data: {'kullanici_adi': kullaniciAdi},
      );
      // İşlem sürerken ekran kapandıysa devam etme.
      if (!mounted) return;

      // Oturum açıldıysa (e-posta doğrulaması kapalıysa) hesap hemen kullanıma hazırdır.
      if (cevap.session != null) {
        // Ana sayfayı açar ve kayıt ekranını kapatır.
        Navigator.pushReplacement(
          // Ekranın konum bilgisi.
          context,
          // Geçiş yapılacak sayfanın yolu.
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // E-posta doğrulaması açıksa önce e-postadaki bağlantı onaylanmalıdır.
        _mesajGoster('Doğrulama bağlantısı e-postana gönderildi. Onayladıktan sonra giriş yap.');
        // Giriş ekranına geri döner.
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      // Supabase bir sorun bildirdiğinde çalışır. 'already' geçiyorsa e-posta zaten kayıtlıdır.
      if (e.message.toLowerCase().contains('already')) {
        _mesajGoster('Bu e-posta zaten kayıtlı.');
      } else {
        // Diğer durumlarda (örneğin kullanıcı adı alınmışsa) genel bir uyarı verir.
        _mesajGoster('Kayıt yapılamadı. Kullanıcı adı ya da e-posta kullanılıyor olabilir.');
      }
    } catch (_) {
      // Başka bir sorun olduğunda (örneğin internet yoksa) çalışır.
      _mesajGoster('Bir sorun oluştu. İnternet bağlantını kontrol et.');
    } finally {
      // Sonuç ne olursa olsun çalışır: "yükleniyor" durumunu kapatır.
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // Dört kutu aynı görünümde olduğu için ortak bir tasarım fonksiyonu yazdık (tekrar yazmamak için).
  InputDecoration _kutuTasarimi(String baslik, String ipucu) {
    // Kutunun görünüm ayarlarını döndürür.
    return InputDecoration(
      // Kutunun üstünde beliren başlık.
      labelText: baslik,
      // Kutuda silik duran örnek yazı.
      hintText: ipucu,
      // Arka plan renginin görünmesini sağlar.
      filled: true,
      // Koyu gri arka plan.
      fillColor: const Color(0xFF1E202C),
      // Kenar çizgisi: köşeleri 8 birim yuvarlatır.
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // ---------------------------------------------------------------------------
  // KAYIT OL EKRANI ARAYÜZÜ (BUILD)
  // ---------------------------------------------------------------------------
  // Ekranın nasıl çizileceğini tanımlar.
  @override
  Widget build(BuildContext context) {
    // 'Scaffold': sayfanın ana iskeleti.
    return Scaffold(
      // 'SafeArea': içeriğin çentik ve durum çubuğunun altına girmesini engeller.
      body: SafeArea(
        // Klavye açılınca ekran taşmasın diye kaydırılabilir yapar.
        child: SingleChildScrollView(
          // Her yönden 24 birim boşluk bırakır.
          padding: const EdgeInsets.all(24.0),
          // İçindekileri alt alta dizer.
          child: Column(
            // Öğeleri yatayda tam genişliğe yayar.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Alt alta dizilecek öğelerin listesi.
            children: [
              // Üstten 20 birim boşluk.
              const SizedBox(height: 20),
              // Sayfanın başlığı.
              const Text(
                'Hesap oluştur',
                // Büyük, kalın, beyaz yazı.
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Başlık ile ilk kutu arasında 24 birim boşluk.
              const SizedBox(height: 24),

              // KULLANICI ADI KUTUSU
              TextField(
                // Yazılanı okumak için _kullaniciAdiController'a bağlanır.
                controller: _kullaniciAdiController,
                // Ortak tasarım fonksiyonunu kullanır.
                decoration: _kutuTasarimi('Kullanıcı adı', 'film_kurdu'),
              ),
              // Kutular arasında 12 birim boşluk.
              const SizedBox(height: 12),

              // E-POSTA KUTUSU
              TextField(
                // Yazılanı okumak için _epostaController'a bağlanır.
                controller: _epostaController,
                // Klavyeyi e-posta yazmaya uygun açar.
                keyboardType: TextInputType.emailAddress,
                // Ortak tasarım fonksiyonunu kullanır.
                decoration: _kutuTasarimi('E-posta', 'ornek@email.com'),
              ),
              // Kutular arasında 12 birim boşluk.
              const SizedBox(height: 12),

              // ŞİFRE KUTUSU
              TextField(
                // Yazılanı okumak için _sifreController'a bağlanır.
                controller: _sifreController,
                // Yazılan karakterleri nokta olarak gizler.
                obscureText: true,
                // Ortak tasarım fonksiyonunu kullanır.
                decoration: _kutuTasarimi('Şifre', 'En az 8 karakter'),
              ),
              // Kutular arasında 12 birim boşluk.
              const SizedBox(height: 12),

              // ŞİFRE TEKRAR KUTUSU
              TextField(
                // Yazılanı okumak için _sifreTekrarController'a bağlanır.
                controller: _sifreTekrarController,
                // Yazılan karakterleri nokta olarak gizler.
                obscureText: true,
                // Ortak tasarım fonksiyonunu kullanır.
                decoration: _kutuTasarimi('Şifre tekrar', 'Şifreni tekrar yaz'),
              ),
              // Kutu ile küçük not arasında 8 birim boşluk.
              const SizedBox(height: 8),

              // Doğrulama hakkında küçük bilgi notu.
              const Text(
                'E-posta adresine bir doğrulama bağlantısı göndereceğiz.',
                // Gri ve çok küçük yazı.
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              // Not ile buton arasında 20 birim boşluk.
              const SizedBox(height: 20),

              // KAYIT OL BUTONU
              ElevatedButton(
                // Butonun görünüm ayarları.
                style: ElevatedButton.styleFrom(
                  // Sarı arka plan.
                  backgroundColor: const Color(0xFFF3B32A),
                  // Butonun yüksekliği için alttan üstten 16 birim boşluk.
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Köşeleri 8 birim yuvarlatır.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Yükleniyorsa 'null' verilir ve buton tıklanamaz olur. Değilse _kayitOl çalışır.
                onPressed: _yukleniyor ? null : _kayitOl,
                // Yükleniyorsa dönen simge, değilse 'Kayıt ol' yazısı gösterilir.
                child: _yukleniyor
                    ? const SizedBox(
                        // Simgenin yüksekliği ve genişliği.
                        height: 20,
                        width: 20,
                        // Dönen yükleniyor simgesi.
                        child: CircularProgressIndicator(
                          // Çizgi kalınlığı.
                          strokeWidth: 2,
                          // Siyah renk.
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Kayıt ol',
                        // Siyah, kalın yazı.
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              // Buton ile alttaki yazı arasında 24 birim boşluk.
              const SizedBox(height: 24),

              // GİRİŞ YAP YÖNLENDİRMESİ
              // İçindekileri yan yana dizer.
              Row(
                // Yatayda ortalar.
                mainAxisAlignment: MainAxisAlignment.center,
                // Yan yana dizilecek yazılar.
                children: [
                  // Gri soru yazısı.
                  const Text(
                    'Zaten hesabın var mı? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  // 'GestureDetector': yazıya dokunmayı algılar.
                  GestureDetector(
                    // Dokunulunca bir önceki ekrana (giriş ekranına) geri döner.
                    onTap: () => Navigator.pop(context),
                    // Tıklanabilir sarı 'Giriş yap' yazısı.
                    child: const Text(
                      'Giriş yap',
                      style: TextStyle(
                        color: Color(0xFFF3B32A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}