// Flutter'ın hazır arayüz parçalarını projeye getirir.
import 'package:flutter/material.dart';
// Supabase paketini getirir. Kullanıcı adını veri tabanından okumak için kullanacağız.
import 'package:supabase_flutter/supabase_flutter.dart';
// TMDB'den film çeken dosyayı bağlar. '..' bir üst klasöre (lib) çıkmak demektir.
import '../tmdb_servisi.dart';

// =============================================================================
// ANA SAYFA EKRANI (HomeScreen)
// =============================================================================
// 'StatefulWidget': ekranın içeriği sonradan değişiyor (kullanıcı adı ve filmler internetten gelince),
// o yüzden durumu olan bir ekran yazdık.
class HomeScreen extends StatefulWidget {
  // Yapıcı metot.
  const HomeScreen({super.key});

  // Ekranın değişebilen kısmını yöneten sınıfı oluşturur.
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Ana sayfanın durumunu ve işlevlerini tutan sınıf.
class _HomeScreenState extends State<HomeScreen> {
  // Veri tabanından gelen kullanıcı adı. Gelene kadar boş kalır.
  String _kullaniciAdi = '';
  // TMDB'den gelen popüler filmler listesi.
  List<dynamic> _filmler = [];
  // TMDB'den gelen popüler diziler listesi.
  List<dynamic> _diziler = [];

  // Ekran ilk açıldığında bir kere çalışır.
  @override
  void initState() {
    // Üst sınıfın başlangıç işlemini çalıştırır.
    super.initState();
    // Verileri internetten yüklemeye başlar.
    _verileriYukle();
  }

  // Kullanıcı adını ve filmleri aynı anda yükler (biri diğerini beklemesin diye).
  Future<void> _verileriYukle() async {
    // İki işi birlikte başlatır ve ikisi de bitene kadar bekler.
    await Future.wait([_profiliYukle(), _filmleriYukle()]);
  }

  // Giriş yapan kullanıcının adını Supabase'deki 'profiller' tablosundan okur.
  Future<void> _profiliYukle() async {
    try {
      // Şu an giriş yapmış kullanıcıyı alır.
      final kullanici = Supabase.instance.client.auth.currentUser;
      // Giriş yapılmamışsa bir şey yapmaz.
      if (kullanici == null) return;
      // 'profiller' tablosundan, id'si bu kullanıcıya ait olan satırın 'kullanici_adi' alanını okur.
      final satir = await Supabase.instance.client
          .from('profiller')
          .select('kullanici_adi')
          .eq('id', kullanici.id)
          .maybeSingle();
      // Satır bulunduysa ve ekran hâlâ açıksa kullanıcı adını kaydeder ve ekranı yeniler.
      if (satir != null && mounted) {
        setState(() => _kullaniciAdi = satir['kullanici_adi'] as String);
      }
    } catch (_) {
      // Hata olursa (örneğin internet yoksa) kullanıcı adı boş kalır, uygulama çökmez.
    }
  }

  // TMDB'den popüler film ve dizileri çeker.
  Future<void> _filmleriYukle() async {
    // TMDB anahtarı yazılmadıysa hiç istek atmaz, kutular geçici olarak görünür.
    if (!TmdbServisi.hazirMi) return;
    try {
      // Film ve dizi listelerini aynı anda ister.
      final sonuclar = await Future.wait([
        TmdbServisi.populerFilmler(),
        TmdbServisi.populerDiziler(),
      ]);
      // Gelen listeleri kaydeder ve ekranı yeniler.
      if (mounted) {
        setState(() {
          _filmler = sonuclar[0];
          _diziler = sonuclar[1];
        });
      }
    } catch (_) {
      // Hata olursa listeler boş kalır, kutular görünür.
    }
  }

  // ---------------------------------------------------------------------------
  // AFİŞ SATIRI (yatay kayan film listesi)
  // ---------------------------------------------------------------------------
  // Bir başlık ve altında yatay kayan afişler çizen yardımcı fonksiyon (film ve dizi için tekrar kullanılır).
  Widget _afisSatiri(String baslik, List<dynamic> liste) {
    // Alt alta dizer: önce başlık, sonra liste.
    return Column(
      // Öğeleri sola hizalar.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Satırın başlığı.
        Text(
          baslik,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Başlık ile liste arasında 12 birim boşluk.
        const SizedBox(height: 12),
        // Yatay listenin yüksekliğini sınırlayan kutu.
        SizedBox(
          height: 230,
          // Dinamik liste oluşturur.
          child: ListView.builder(
            // Kaydırma yönünü yatay yapar.
            scrollDirection: Axis.horizontal,
            // Liste boşsa 5 geçici kutu, doluysa gelen film sayısı kadar kart gösterir.
            itemCount: liste.isEmpty ? 5 : liste.length,
            // Her kartı sırayla çizen fonksiyon.
            itemBuilder: (context, index) {
              // Liste boşsa geçici renkli kutu çizer.
              if (liste.isEmpty) {
                return _bosAfis();
              }
              // Sıradaki film ya da diziyi alır.
              final oge = liste[index];
              // Film ise 'title', dizi ise 'name' alanında adı yazar.
              final ad = (oge['title'] ?? oge['name'] ?? '') as String;
              // Afiş resminin yolu. Bazı yapımlarda olmayabilir (null).
              final afisYolu = oge['poster_path'] as String?;
              // Bir kartı alt alta afiş ve ad olarak çizer.
              return Container(
                // Kart genişliği.
                width: 120,
                // Kartların arasında sağ tarafta 12 birim boşluk.
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Afiş resmini yuvarlak köşeli keser.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      // Resmin boyutunu belirleyen kutu.
                      child: SizedBox(
                        width: 120,
                        height: 180,
                        // Afiş yolu varsa internetten resmi yükler, yoksa boş kutu gösterir.
                        child: afisYolu == null
                            ? _bosAfis()
                            : Image.network(
                                // Resmin tam adresi.
                                '${TmdbServisi.afisAdresi}$afisYolu',
                                // Resmi kutuya sığacak şekilde kırparak doldurur.
                                fit: BoxFit.cover,
                                // Resim yüklenemezse boş kutu gösterir.
                                errorBuilder: (context, hata, iz) => _bosAfis(),
                              ),
                      ),
                    ),
                    // Afiş ile ad arasında 6 birim boşluk.
                    const SizedBox(height: 6),
                    // Filmin adı. En fazla 2 satır, sığmazsa sonuna ... koyar.
                    Text(
                      ad,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Afiş olmadığında gösterilen geçici mor kutu.
  Widget _bosAfis() {
    return Container(
      // Kartın genişliği.
      width: 120,
      // Kartlar arası boşluk.
      margin: const EdgeInsets.only(right: 12),
      // Mor renkli, yuvarlak köşeli görünüm.
      decoration: BoxDecoration(
        color: Colors.purple.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ANA SAYFA ARAYÜZÜ (BUILD)
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // 'Scaffold': sayfanın ana iskeleti.
    return Scaffold(
      // Sayfanın en üstündeki başlık çubuğu.
      appBar: AppBar(
        // Arka planı şeffaf yapar.
        backgroundColor: Colors.transparent,
        // Çubuğun altındaki gölgeyi kaldırır.
        elevation: 0,
        // Başlık alanı: üstte 'Merhaba', altında kullanıcı adı.
        title: Column(
          // Yazıları sola hizalar.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Küçük gri 'Merhaba' yazısı.
            const Text(
              'Merhaba',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // Kullanıcı adı. Henüz gelmediyse boşluk yerine '...' gösterir.
            Text(
              _kullaniciAdi.isEmpty ? '...' : _kullaniciAdi,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Çubuğun sağ tarafındaki öğeler.
        actions: const [
          // Sağdan 16 birim boşluk bırakır.
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            // Yuvarlak profil simgesi.
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      // Sayfanın kaydırılabilir ana gövdesi.
      body: SingleChildScrollView(
        // Her yönden 16 birim boşluk.
        padding: const EdgeInsets.all(16),
        // İçindekileri alt alta dizer.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ARAMA KUTUSU
            TextField(
              decoration: InputDecoration(
                // Silik ipucu yazısı.
                hintText: 'Film veya dizi ara',
                // Kutunun solundaki büyüteç simgesi.
                prefixIcon: const Icon(Icons.search),
                // Arka plan renginin görünmesini sağlar.
                filled: true,
                // Koyu gri arka plan.
                fillColor: const Color(0xFF1E202C),
                // Kenar çizgisi ayarı.
                border: OutlineInputBorder(
                  // Köşeleri 12 birim yuvarlatır.
                  borderRadius: BorderRadius.circular(12),
                  // Kenar çizgisini kaldırır.
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            // Arama kutusu ile ilk satır arasında 20 birim boşluk.
            const SizedBox(height: 20),

            // POPÜLER FİLMLER SATIRI
            _afisSatiri('Popüler filmler', _filmler),
            // Satırlar arasında 20 birim boşluk.
            const SizedBox(height: 20),

            // POPÜLER DİZİLER SATIRI
            _afisSatiri('Popüler diziler', _diziler),

            // TMDB anahtarı yazılmadıysa kullanıcıya bilgi notu gösterir.
            if (!TmdbServisi.hazirMi) ...[
              const SizedBox(height: 16),
              const Text(
                'Not: TMDB anahtarı eklenince gerçek filmler burada görünecek.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
      ),

      // ALT GEZİNME MENÜSÜ
      bottomNavigationBar: BottomNavigationBar(
        // Seçili sekmenin sırası (0 = Keşfet).
        currentIndex: 0,
        // Seçili sekmenin rengi (sarı).
        selectedItemColor: const Color(0xFFF3B32A),
        // Seçili olmayan sekmelerin rengi (gri).
        unselectedItemColor: Colors.grey,
        // Sekmelerin sabit boyutlu durmasını sağlar.
        type: BottomNavigationBarType.fixed,
        // Menünün arka plan rengi.
        backgroundColor: const Color(0xFF12141D),
        // Menüdeki sekmeler.
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Keşfet'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Listem',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Global'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}