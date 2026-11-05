// Flutter'ın hazır arayüz parçalarını (buton, yazı, kutu, renk vb.) projeye getirir.
import 'package:flutter/material.dart';
// Supabase (veri tabanı ve üyelik servisi) ile konuşmamızı sağlayan paketi projeye getirir.
import 'package:supabase_flutter/supabase_flutter.dart';
// Giriş ekranı dosyasını bu dosyaya bağlar. Böylece LoginScreen'i burada kullanabiliriz.
import 'ekranlar/giris_ekrani.dart';
// Ana sayfa dosyasını bu dosyaya bağlar. Böylece HomeScreen'i burada kullanabiliriz.
import 'ekranlar/ana_sayfa_ekrani.dart';

// Uygulamanın başladığı ana fonksiyon. 'async', içinde beklemeli bir işlem (Supabase bağlantısı) olduğunu gösterir.
Future<void> main() async {
  // Flutter'ın tamamen hazır olmasını bekler. Supabase'i başlatmadan önce bu satır gereklidir.
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase'e bağlanır. 'await', bağlantı kurulana kadar bekle demektir.
  await Supabase.initialize(
    // Supabase'deki projemizin internet adresi.
    url: 'https://pqjkglfweknphaqgqiea.supabase.co',
    // Uygulamaya konulmak için üretilmiş herkese açık anahtar (publishable key). Gizli anahtar değildir.
    anonKey: 'sb_publishable_cO0rU4Apzfyhdb1ifDGZiQ_MTi_Gl60',
  );

  // Bağlantı kurulduktan sonra SeenitApp widget'ını ekranda çalıştırır.
  runApp(const SeenitApp());
}

// =============================================================================
// UYGULAMA GENEL AYARLARI VE TEMA (SeenitApp)
// =============================================================================
// 'StatelessWidget': içeriği kendi kendine değişmeyen sabit bir yapıdır.
class SeenitApp extends StatelessWidget {
  // 'super.key': bu widget'a benzersiz bir kimlik verir (Flutter'ın iç işleyişi için).
  const SeenitApp({super.key});

  // 'build': bu widget'ın ekranda nasıl çizileceğini tanımlar.
  @override
  Widget build(BuildContext context) {
    // 'MaterialApp': Material Design kurallarına uygun bir mobil uygulama başlatır.
    return MaterialApp(
      // Uygulamanın adı (cihazda ve tarayıcı sekmesinde görünür).
      title: 'Seenit',
      // Sağ üstteki kırmızı 'DEBUG' bandını kaldırır.
      debugShowCheckedModeBanner: false,
      // Uygulama genelindeki renk ve stil ayarları.
      theme: ThemeData.dark().copyWith(
        // Bütün sayfaların arka plan rengi (koyu lacivert/siyah).
        scaffoldBackgroundColor: const Color(0xFF12141D),
        // Uygulamanın ana vurgu rengi (sarı).
        primaryColor: const Color(0xFFF3B32A),
        // Renk şemasının ayrıntıları.
        colorScheme: const ColorScheme.dark(
          // Ana renk olarak sarı tanımlanır.
          primary: Color(0xFFF3B32A),
          // Kartların ve kutuların koyu gri yüzey rengi.
          surface: Color(0xFF1E202C),
        ),
      ),
      // Uygulama açılınca hangi ekranın geleceğini belirler.
      // Daha önce giriş yapılmışsa (kayıtlı oturum varsa) doğrudan ana sayfa, yoksa giriş ekranı açılır.
      home: Supabase.instance.client.auth.currentSession == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
