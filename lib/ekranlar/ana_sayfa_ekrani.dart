import 'package:flutter/material.dart';

// =============================================================================
// 4. ANA SAYFA EKRANI (HomeScreen)
// =============================================================================
// Ana Sayfanın durumsuz (Stateless) arayüz sınıfı.
class HomeScreen extends StatelessWidget {
  // Key alan yapıcı metot tanımı.
  const HomeScreen({super.key});

  // Ana Sayfanın arayüzünü çizen builder metodu.
  @override
  Widget build(BuildContext context) {
    // Sayfanın iskelet yapısı.
    return Scaffold(
      // Sayfanın en üstünde yer alan başlık çubuğu (AppBar).
      appBar: AppBar(
        // Arka plan rengini tamamen şeffaf yapar.
        backgroundColor: Colors.transparent,
        // AppBar'ın altındaki varsayılan gölgeyi sıfırlar.
        elevation: 0,
        // Üst başlık alanındaki sütun dizilimi.
        title: const Column(
          // Metinleri sola hizalar.
          crossAxisAlignment: CrossAxisAlignment.start,
          // Sütun içindeki metinler dizisi.
          children: [
            // Üstteki küçük 'Merhaba' yazısı.
            Text('Merhaba', style: TextStyle(fontSize: 12, color: Colors.grey)),
            // Altındaki kullanıcı adı yazısı.
            Text(
              'film_kurdu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // AppBar'ın sağ tarafında yer alacak aksiyon butonları/simgeleri.
        actions: const [
          // Sağ taraftan 16 birim boşluk bırakan pading.
          Padding(
            // Sadece sağ taraftan boşluk tanımlaması.
            padding: EdgeInsets.only(right: 16.0),
            // Yuvarlak profil avatar simgesi.
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      // Sayfanın kaydırılabilir ana gövde alanı.
      body: SingleChildScrollView(
        // Dört bir taraftan 16 birim boşluk bırakır.
        padding: const EdgeInsets.all(16),
        // Ana sayfadaki öğeleri dikeyde sıralayan kolon.
        child: Column(
          // Öğeleri sola hizalar.
          crossAxisAlignment: CrossAxisAlignment.start,
          // Kolon çocukları dizisi.
          children: [
            // ARAMA BARI
            TextField(
              // Kutu dekorasyonu.
              decoration: InputDecoration(
                // Kutuda silik biçimde gözüken ipucu yazısı.
                hintText: 'Film veya dizi ara',
                // Kutunun sol tarafına büyüteç arama ikonu ekler.
                prefixIcon: const Icon(Icons.search),
                // Dolgu rengini aktif yapar.
                filled: true,
                // Koyu gri iç dolgu rengi.
                fillColor: const Color(0xFF1E202C),
                // Kutunun kenarlık ayarları.
                border: OutlineInputBorder(
                  // Kenarları 12 birim ovalleştirir.
                  borderRadius: BorderRadius.circular(12),
                  // Dış çizgiyi tamamen kaldırır.
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            // Arama barı ile liste başlığı arasına 20 birim dikey boşluk koyar.
            const SizedBox(height: 20),
            // Liste başlığı metni.
            const Text(
              'Senin için öneriler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Başlık ile liste arasına 12 birim dikey boşluk koyar.
            const SizedBox(height: 12),

            // YATAY KAYDIRILABİLİR FİLM LİSTESİ
            // Yatay listenin yüksekliğini sınırlandıran kutu bileşeni.
            SizedBox(
              // Liste yüksekliği 160 birim olarak belirlenir.
              height: 160,
              // Dinamik liste oluşturan yapıcı widget.
              child: ListView.builder(
                // Kaydırma yönünü dikey yerine yatay yapar.
                scrollDirection: Axis.horizontal,
                // Ekranda gösterilecek toplam öğe/kart sayısı.
                itemCount: 5,
                // Her bir kartı sırayla çizen builder metodu.
                itemBuilder: (context, index) {
                  // Film kartını temsil eden renkli kutu.
                  return Container(
                    // Kart genişliği 110 birim.
                    width: 110,
                    // Kartlar arasında sağ tarafa doğru 12 birim boşluk bırakır.
                    margin: const EdgeInsets.only(right: 12),
                    // Kartın görsel biçimlendirmesi.
                    decoration: BoxDecoration(
                      // Geçici olarak kartlara verilen mor renk.
                      color: Colors.purple.shade900,
                      // Kartın kenarlarını 12 birim yuvarlatır.
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ALT GEZİNME MENÜSÜ (BottomNavigationBar)
      // Sayfanın en altındaki sabit menü çubuğu.
      bottomNavigationBar: BottomNavigationBar(
        // Aktif/Seçili olan sekmeyi indeks olarak belirler (0 = Keşfet).
        currentIndex: 0,
        // Seçili olan menü elemanının sarı rengi.
        selectedItemColor: const Color(0xFFF3B32A),
        // Seçili olmayan menü elemanlarının gri rengi.
        unselectedItemColor: Colors.grey,
        // Sekmelerin sabit boyutlu ve hizalı kalmasını sağlar.
        type: BottomNavigationBarType.fixed,
        // Menü çubuğunun koyu arka plan rengi.
        backgroundColor: const Color(0xFF12141D),
        // Menü çubuğunda yer alan sekmeler dizisi.
        items: const [
          // 1. Sekme: Keşfet
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Keşfet'),
          // 2. Sekme: Listem
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Listem',
          ),
          // 3. Sekme: Global
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Global'),
          // 4. Sekme: Profil
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
