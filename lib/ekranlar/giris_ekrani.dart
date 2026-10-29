import 'package:flutter/material.dart';

import 'kayit_ekrani.dart';
import 'ana_sayfa_ekrani.dart';

// =============================================================================
// 2. GİRİŞ EKRANI (LoginScreen)
// =============================================================================
// Giriş Yap ekranının arayüz sınıfı.
class LoginScreen extends StatelessWidget {
  // Constructor (Yapıcı Metot) - Key ile tanımlama yapar.
  const LoginScreen({super.key});

  // ---------------------------------------------------------------------------
  // ŞİFREMİ UNUTTUM AÇILIR PENCERESİ (FUNCTİON)
  // ---------------------------------------------------------------------------
  // Şifremi unuttum butonuna basıldığında çalışan özel metot.
  void _showForgotPasswordDialog(BuildContext context) {
    // Açılır penceredeki e-posta alanına yazılan metni kontrol eden yapı.
    final TextEditingController emailController = TextEditingController();

    // 'showDialog', ekrana diyalog/popup penceresi getirir.
    showDialog(
      // 'context', widget'ın ekrandaki konumunu temsil eder.
      context: context,
      // Açılacak pop-up penceresinin tasarımını oluşturan builder metodu.
      builder: (context) => AlertDialog(
        // Pop-up penceresinin koyu arka plan rengi.
        backgroundColor: const Color(0xFF1E202C),
        // Pencerenin kenarlarını 16 birim ovalleştirir.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // Pop-up başlığı.
        title: const Text(
          // Başlık metni.
          'Şifremi Unuttum',
          // Başlık metninin rengi beyaz ve kalın (bold) yapılır.
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // Pop-up penceresinin içindeki ana içerik alanı.
        content: Column(
          // Yüksekliği içeriğin boyutu kadar daraltır, boşuna yer kaplamaz.
          mainAxisSize: MainAxisSize.min,
          // İçerikteki öğeleri sola hizalar.
          crossAxisAlignment: CrossAxisAlignment.start,
          // Kolonun içindeki bileşenler listesi.
          children: [
            // Kullanıcıyı bilgilendiren açıklama metni.
            const Text(
              // Açıklama yazısı.
              'Hesabınıza bağlı e-posta adresinizi girin. Size bir sıfırlama bağlantısı göndereceğiz.',
              // Metnin gri renkte ve 13 punto büyüklüğünde olması sağlanır.
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            // Metin ile girdi kutusu arasında 16 birimlik dikey boşluk oluşturur.
            const SizedBox(height: 16),
            // E-posta adresinin yazılacağı metin kutusu.
            TextField(
              // Yazılan metni takip etmek için controller atanır.
              controller: emailController,
              // Kutunun görsel süsleme özellikleri.
              decoration: InputDecoration(
                // Kutunun içinde silik biçimde duran örnek metin.
                hintText: 'ornek@email.com',
                // İç rengin görünmesi için aktif edilir.
                filled: true,
                // Kutu içindeki koyu arka plan rengi.
                fillColor: const Color(0xFF12141D),
                // Kutunun kenarlık yapısı.
                border: OutlineInputBorder(
                  // Kenarları 8 birim yuvarlatır.
                  borderRadius: BorderRadius.circular(8),
                  // Kutunun dış çizgisini kaldırır.
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        // Pop-up'ın en altındaki işlem butonlarının bulunduğu liste.
        actions: [
          // İptal seçeneğini sunan düz buton.
          TextButton(
            // Tıklandığında açık olan diyalog penceresini kapatır.
            onPressed: () => Navigator.pop(context),
            // İptal metni gri renkte çizilir.
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          // Gönder seçeneğini sunan dolgulu buton.
          ElevatedButton(
            // Butonun stil ve renk ayarları.
            style: ElevatedButton.styleFrom(
              // Butonun sarı arka plan rengi.
              backgroundColor: const Color(0xFFF3B32A),
              // Buton kenarlarını 8 birim yuvarlatır.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Gönder butonuna tıklandığında yapılacak işlemler.
            onPressed: () {
              // Pop-up penceresini kapatır.
              Navigator.pop(context);
              // Ekranın en altında geçici bilgi mesajı (SnackBar) gösterir.
              ScaffoldMessenger.of(context).showSnackBar(
                // Bildiri çubuğunun içeriği ve stili.
                const SnackBar(
                  // Ekranda çıkacak bildiri metni.
                  content: Text(
                    'Sıfırlama bağlantısı e-posta adresinize gönderildi!',
                  ),
                  // Bildirimin sarı renkli arka planı.
                  backgroundColor: Color(0xFFF3B32A),
                ),
              );
            },
            // Buton üzerindeki siyah renkli kalın metin.
            child: const Text(
              'Gönder',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GİRİŞ EKRANI ARAYÜZ ÇİZİMİ (BUILD METHOD)
  // ---------------------------------------------------------------------------
  // Arayüz bileşenlerinin ekrana çizildiği ana builder metodu.
  @override
  Widget build(BuildContext context) {
    // 'Scaffold', sayfa yapısını oluşturan ana iskelet bileşenidir.
    return Scaffold(
      // 'SafeArea', çentik ve durum çubuğu gibi alanların altına içeriğin girmesini engeller.
      body: SafeArea(
        // 'LayoutBuilder', ekran boyut sınırlarını (constraints) dinamik almanızı sağlar.
        child: LayoutBuilder(
          // Ekran boyutu sınırlarını kullanarak widget oluşturan builder metodu.
          builder: (context, constraints) {
            // 'SingleChildScrollView', klavye açıldığında ekranın taşmasını önler ve kaydırılabilir yapar.
            return SingleChildScrollView(
              // Ekranın sağ, sol, üst ve altından iç boşluk verir.
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              // İçindeki öğelere yükseklik kısıtlaması koyan kutu.
              child: ConstrainedBox(
                // Minimum yüksekliği cihaz ekranının yüksekliğine eşitler.
                constraints: BoxConstraints(
                  // Ekran boyutundan pedding boşluğunu düşer.
                  minHeight: constraints.maxHeight - 32,
                ),
                // 'IntrinsicHeight', Spacer gibi esnek elemanların ekran boyutuna göre yerleşmesini sağlar.
                child: IntrinsicHeight(
                  // Ögeleri yukarıdan aşağıya doğru sıralayan dikey kolon yapısı.
                  child: Column(
                    // Kolon içindeki elemanları yatayda tam genişlik yapacak şekilde yayar.
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // Dikey kolonda sırayla yer alacak elemanlar dizisi.
                    children: [
                      // 20 birimlik dikey boşluk.
                      const SizedBox(height: 20),

                      // ----- LOGO VE BAŞLIK ALANI -----
                      // İçindeki elemanları merkeze hizalayan widget.
                      Center(
                        // Logo ve altındaki metinleri dikey sıralayan kolon.
                        child: Column(
                          // Kolon içindeki elemanlar dizisi.
                          children: [
                            // Kare şeklindeki sarı logo kutusu.
                            Container(
                              // Kutunun her tarafından 16 birim iç boşluk verir.
                              padding: const EdgeInsets.all(16),
                              // Kutunun dekorasyon (renk ve kenarlık) ayarları.
                              decoration: BoxDecoration(
                                // Kutunun sarı rengi.
                                color: const Color(0xFFF3B32A),
                                // Kutunun kenarlarını 16 birim ovalleştirir.
                                borderRadius: BorderRadius.circular(16),
                              ),
                              // Sarı kutunun içindeki ikon.
                              child: const Icon(
                                // İkonun modeli (Daire içinde tik işareti).
                                Icons.check_circle,
                                // İkon boyutu 36 punto.
                                size: 36,
                                // İkon rengi siyah.
                                color: Colors.black,
                              ),
                            ),
                            // Logo kutusu ile başlık arasına 12 birimlik boşluk bırakır.
                            const SizedBox(height: 12),
                            // Uygulamanın büyük başlık ismi.
                            const Text(
                              // Başlık metni.
                              'Seenit',
                              // Metin biçimlendirmesi.
                              style: TextStyle(
                                // 32 punto yazı büyüklüğü.
                                fontSize: 32,
                                // Kalın font stili.
                                fontWeight: FontWeight.bold,
                                // Beyaz yazı rengi.
                                color: Colors.white,
                              ),
                            ),
                            // Başlık ile slogan arasına 4 birimlik boşluk bırakır.
                            const SizedBox(height: 4),
                            // Uygulama sloganı metni.
                            const Text(
                              // Slogan metni.
                              'İzle, hisset, paylaş',
                              // Gri renkte 13 punto stil ayarı.
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Başlık grubu ile girdi alanları arasına 36 birimlik dikey boşluk koyar.
                      const SizedBox(height: 36),

                      // ----- E-POSTA INPUT ALANI -----
                      // 'E-posta' etiketi metni.
                      const Text(
                        'E-posta',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Etiket ile girdi kutusu arasına 6 birim boşluk koyar.
                      const SizedBox(height: 6),
                      // E-posta adresinin yazıldığı girdi kutusu.
                      TextField(
                        // Kutu içi süsleme ayarları.
                        decoration: InputDecoration(
                          // Kutuda silik biçimde gözüken ipucu adresi.
                          hintText: 'ornek@email.com',
                          // Arka plan rengini aktif yapar.
                          filled: true,
                          // Kutunun koyu gri arka plan rengi.
                          fillColor: const Color(0xFF1E202C),
                          // Kutu kenarlıkları.
                          border: OutlineInputBorder(
                            // Kenarları 8 birim yuvarlatır.
                            borderRadius: BorderRadius.circular(8),
                            // Çerçeve çizgisini kaldırır.
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      // İki girdi alanı arasına 16 birim boşluk koyar.
                      const SizedBox(height: 16),

                      // ----- ŞİFRE INPUT ALANI -----
                      // 'Şifre' etiketi metni.
                      const Text(
                        'Şifre',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Etiket ile şifre kutusu arasına 6 birim boşluk koyar.
                      const SizedBox(height: 6),
                      // Şifrenin yazıldığı girdi kutusu.
                      TextField(
                        // Şifre karakterlerini noktalı olarak gizlemeyi sağlar.
                        obscureText: true,
                        // Kutu içi süslemeleri.
                        decoration: InputDecoration(
                          // Kutuda silik gözüken ipucu metni.
                          hintText: 'Şifren',
                          // Arka plan dolgusunu aktif eder.
                          filled: true,
                          // Kutunun koyu gri arka plan rengi.
                          fillColor: const Color(0xFF1E202C),
                          // Kutunun kenarlık yapısı.
                          border: OutlineInputBorder(
                            // Kenarları 8 birim yuvarlatır.
                            borderRadius: BorderRadius.circular(8),
                            // Çerçeve çizgisini gizler.
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      // ----- ŞİFREMİ UNUTTUM BUTONU -----
                      // İçindeki öğeyi sağa yaslamaya yarayan hizalama bileşeni.
                      Align(
                        // Hizalama yönü olarak sağ ortayı seçer.
                        alignment: Alignment.centerRight,
                        // Tıklanabilir düz yazı butonu.
                        child: TextButton(
                          // Tıklandığında şifremi unuttum pop-up metodunu tetikler.
                          onPressed: () => _showForgotPasswordDialog(context),
                          // Buton üzerindeki sarı yazı.
                          child: const Text(
                            'Şifremi unuttum',
                            style: TextStyle(color: Color(0xFFF3B32A)),
                          ),
                        ),
                      ),
                      // Buton ile giriş yap butonu arasına 12 birim boşluk yerleştirir.
                      const SizedBox(height: 12),

                      // ----- GİRİŞ YAP BUTONU -----
                      // Kabarık / dolgulu sarı ana buton.
                      ElevatedButton(
                        // Buton biçimlendirmeleri.
                        style: ElevatedButton.styleFrom(
                          // Butonun sarı rengi.
                          backgroundColor: const Color(0xFFF3B32A),
                          // Buton yüksekliği için dikeyden 16 birim iç boşluk verir.
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          // Butonun kenarlarını 8 birim yuvarlatır.
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Giriş yap butonuna tıklandığında çalışacak kodlar.
                        onPressed: () {
                          // 'Navigator.push' ile mevcut sayfanın üzerine Ana Sayfayı (HomeScreen) açar.
                          Navigator.push(
                            // Sayfa konumu bilgisi.
                            context,
                            // Yeni sayfaya geçiş animasyonu ve route yapısı.
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        // Buton içindeki siyah, kalın ve 16 punto metin.
                        child: const Text(
                          'Giriş yap',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Esnek boşluk bileşeni - Tüm boş alanı kaplayarak aşağıdaki elemanları en alta iter.
                      const Spacer(),
                      // Metinden önce 24 birimlik güvenlik boşluğu koyar.
                      const SizedBox(height: 24),

                      // ----- EN ALT YÖNLENDİRME METNİ -----
                      // Ögeleri soldan sağa doğru yana yana dizen yatay satır yapısı.
                      Row(
                        // Satır içindeki elemanları yatayda tam ortalar.
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Satır içindeki metinler listesi.
                        children: [
                          // Gri renkli soru metni.
                          const Text(
                            'Hesabın yok mu? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          // Dokunma / tıklama olaylarını algılayan görünmez sarmalayıcı.
                          GestureDetector(
                            // Tıklandığında Kayıt Ol sayfasına yönlendirme yapar.
                            onTap: () {
                              // 'Navigator.push' ile Kayıt Ol (RegisterScreen) sayfasını açar.
                              Navigator.push(
                                // Sayfa konumu bilgisi.
                                context,
                                // Sayfa geçiş yapılandırması.
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            // Tıklanabilir sarı renkli 'Kayıt ol' yazısı.
                            child: const Text(
                              // Yazı içeriği.
                              'Kayıt ol',
                              // Yazının sarı ve kalın olmasını sağlayan stil.
                              style: TextStyle(
                                color: Color(0xFFF3B32A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // En alttan 12 birim güvenlik boşluğu bırakır.
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
