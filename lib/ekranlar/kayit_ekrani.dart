import 'package:flutter/material.dart';

import 'ana_sayfa_ekrani.dart';

// =============================================================================
// 3. KAYIT OL EKRANI (RegisterScreen)
// =============================================================================
// Kayıt Ol ekranının durumsuz (Stateless) arayüz sınıfı.
class RegisterScreen extends StatelessWidget {
  // Key anahtar kelimeli constructor tanımı.
  const RegisterScreen({super.key});

  // Kayıt Ol ekranının arayüzünü çizen builder metodu.
  @override
  Widget build(BuildContext context) {
    // Sayfanın temel iskeleti.
    return Scaffold(
      // Çentik korumalı güvenli alan.
      body: SafeArea(
        // Klavyeden dolayı ekran taşmalarını önleyen kaydırılabilir görünüm.
        child: SingleChildScrollView(
          // Ekranın dört bir yanından 24 birimlik iç boşluk verir.
          padding: const EdgeInsets.all(24.0),
          // Öğeleri yukarıdan aşağıya dikeyde sıralar.
          child: Column(
            // Elemanları yatayda genişletecek şekilde hizalar.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Kolon içindeki elemanlar dizisi.
            children: [
              // Üstten 20 birimlik dikey boşluk.
              const SizedBox(height: 20),
              // Sayfanın ana başlığı.
              const Text(
                // Metin içeriği.
                'Hesap oluştur',
                // 28 punto, kalın ve beyaz yazı stili.
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Başlık ile ilk girdi kutusu arasına 24 birim boşluk koyar.
              const SizedBox(height: 24),

              // KULLANICI ADI GİRDİSİ
              TextField(
                // Kutu görsel özellikleri.
                decoration: InputDecoration(
                  // Kutunun üstünde beliren label etiketi.
                  labelText: 'Kullanıcı adı',
                  // Örnek ipucu metni.
                  hintText: 'film_kurdu',
                  // Arka plan rengini görünür kılar.
                  filled: true,
                  // Kutunun koyu gri arka plan rengi.
                  fillColor: const Color(0xFF1E202C),
                  // Kutunun kenarlarını 8 birim ovalleştirir.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Girdi kutuları arasına 12 birim boşluk koyar.
              const SizedBox(height: 12),

              // E-POSTA GİRDİSİ
              TextField(
                // Kutu dekorasyon özellikleri.
                decoration: InputDecoration(
                  // Üst etiket yazısı.
                  labelText: 'E-posta',
                  // İpucu metni.
                  hintText: 'ornek@email.com',
                  // Arka plan rengini aktif eder.
                  filled: true,
                  // Kutunun koyu gri arka plan rengi.
                  fillColor: const Color(0xFF1E202C),
                  // Kenarlıkları 8 birim ovalleştirir.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Girdi kutuları arasına 12 birim boşluk koyar.
              const SizedBox(height: 12),

              // ŞİFRE GİRDİSİ
              TextField(
                // Yazılan şifreyi gizli (noktalı) gösterir.
                obscureText: true,
                // Kutu dekorasyonu.
                decoration: InputDecoration(
                  // Üst etiket metni.
                  labelText: 'Şifre',
                  // İpucu yazısı.
                  hintText: 'En az 8 karakter',
                  // Renkli dolguyu açar.
                  filled: true,
                  // Koyu gri arka plan rengi.
                  fillColor: const Color(0xFF1E202C),
                  // Oval kenarlık.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Girdi kutuları arasına 12 birim boşluk koyar.
              const SizedBox(height: 12),

              // ŞİFRE TEKRAR GİRDİSİ
              TextField(
                // Şifre karakterlerini gizler.
                obscureText: true,
                // Kutu süsleme ayarları.
                decoration: InputDecoration(
                  // Üst etiket metni.
                  labelText: 'Şifre tekrar',
                  // İpucu yazısı.
                  hintText: 'Şifreni tekrar yaz',
                  // Dolguyu açar.
                  filled: true,
                  // Koyu gri renk.
                  fillColor: const Color(0xFF1E202C),
                  // Oval kenarlık.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Kutu ile altındaki küçük not arasına 8 birim boşluk bırakır.
              const SizedBox(height: 8),

              // Doğrulama bağlantısı hakkında küçük bilgilendirme metni.
              const Text(
                // Bilgi metni.
                'E-posta adresine bir doğrulama bağlantısı göndereceğiz.',
                // Gri renkte küçük 11 punto stil.
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              // Not ile buton arasına 20 birim dikey boşluk koyar.
              const SizedBox(height: 20),

              // KAYIT OL BUTONU
              ElevatedButton(
                // Butonun stil yapılandırması.
                style: ElevatedButton.styleFrom(
                  // Butonun sarı rengi.
                  backgroundColor: const Color(0xFFF3B32A),
                  // Yükseklik için dikeyden 16 birim iç boşluk verir.
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Kenarları 8 birim yuvarlatır.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Kayıt Ol butonuna basıldığında yapılacak işlem.
                onPressed: () {
                  // 'Navigator.pushReplacement' ile kayıt ekranını yok edip yerine Ana Sayfayı (HomeScreen) açar.
                  Navigator.pushReplacement(
                    // Sayfa konumu.
                    context,
                    // Sayfa geçiş yolu.
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                // Buton içindeki siyah renkli kalın metin.
                child: const Text(
                  'Kayıt ol',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Buton ile alt yönlendirme metni arasına 24 birim dikey boşluk koyar.
              const SizedBox(height: 24),

              // GİRİŞ YAP YÖNLENDİRMESİ
              // Yan yana metinleri sıralayan yatay satır yapısı.
              Row(
                // Satırdaki metinleri yatayda tam ortalar.
                mainAxisAlignment: MainAxisAlignment.center,
                // Satır içindeki elemanlar dizisi.
                children: [
                  // Gri renkli soru yazısı.
                  const Text(
                    'Zaten hesabın var mı? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  // Dokunma hareketlerini algılayan yapı.
                  GestureDetector(
                    // Tıklandığında mevcut kayıt ekranını kapatıp giriş ekranına geri döndürür.
                    onTap: () {
                      // 'Navigator.pop' bir önceki sayfaya (Giriş Ekranına) geri dönüş sağlar.
                      Navigator.pop(context);
                    },
                    // Tıklanabilir sarı 'Giriş yap' metni.
                    child: const Text(
                      // Metin.
                      'Giriş yap',
                      // Sarı renk ve kalın metin stili.
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
