// Flutter kütüphanesinin temel UI bileşenlerini (renkler, butonlar, metinler vb.) projeye aktarır.
import 'package:flutter/material.dart';

import 'ekranlar/giris_ekrani.dart';

// Uygulamanın çalışmaya başladığı ana fonksiyon.
void main() {
  // 'runApp' fonksiyonu, parametre olarak verilen SeenitApp widget'ını ekranın tamamında çalıştırır.
  runApp(const SeenitApp());
}

// =============================================================================
// 1. UYGULAMA GENEL AYARLARI VE TEMA (SeenitApp)
// =============================================================================
// 'StatelessWidget', durumu (state) değişmeyen, yani ekranda dinamik veri güncellemesi yapmayan sabit yapıdır.
class SeenitApp extends StatelessWidget {
  // 'super.key', bu widget'ın benzersiz bir kimliğe sahip olmasını sağlar ve performans optimize eder.
  const SeenitApp({super.key});

  // 'build' metodu, widget'ın ekranda nasıl çizileceğini tanımlar.
  @override
  Widget build(BuildContext context) {
    // 'MaterialApp', Material Design standartlarına uygun bir mobil uygulama yapısı başlatır.
    return MaterialApp(
      // Uygulamanın cihaz ayarlarındaki veya arka plandaki ismi.
      title: 'Seenit',
      // Sağ üstteki 'DEBUG' yazısı bandını ekrandan kaldırır.
      debugShowCheckedModeBanner: false,
      // Uygulama genelinde geçerli olan tema ayarlarını belirler.
      theme: ThemeData.dark().copyWith(
        // Sayfaların arka plan rengini tasarıma uygun koyu tona ayarlar.
        scaffoldBackgroundColor: const Color(0xFF12141D),
        // Uygulamanın ana vurgu rengini sarı (0xFFF3B32A) yapar.
        primaryColor: const Color(0xFFF3B32A),
        // Renk şemasındaki detayları belirler.
        colorScheme: const ColorScheme.dark(
          // Ana renk olarak sarı tanımlanır.
          primary: Color(0xFFF3B32A),
          // Input alanları ve kartların koyu arka plan rengi tanımlanır.
          surface: Color(0xFF1E202C),
        ),
      ),
      // Uygulama açıldığında varsayılan olarak gösterilecek olan ekran.
      home: const LoginScreen(),
    );
  }
}
