// JSON (internetten gelen veri formatı) metnini Dart verisine çeviren hazır kütüphane.
import 'dart:convert';
// İnternetten veri çekmeyi (HTTP isteği) sağlayan paket.
import 'package:http/http.dart' as http;

// =============================================================================
// TMDB SERVİSİ
// =============================================================================
// TMDB (The Movie Database), film ve dizi bilgilerini ücretsiz veren bir internet servisidir.
// Bu dosya, TMDB'den veri çeken işlevleri tek yerde toplar. Böylece ekranlar sadece
// "popüler filmleri getir" der, internet işini bu dosya yapar.
class TmdbServisi {
  // TMDB hesabından alacağın API anahtarı. Aşağıdaki yazıyı silip kendi anahtarını yapıştır.
  static const String _anahtar = 'afc7467041d1c7953523d07c4f627077';

  // Afiş resimlerinin adresinin başlangıcı. Sonuna her filmin kendi resim yolu eklenir.
  static const String afisAdresi = 'https://image.tmdb.org/t/p/w342';

  // Anahtar yazılmış mı kontrol eder. Yazılmadıysa internete hiç istek atılmaz.
  static bool get hazirMi => _anahtar != 'BURAYA_TMDB_ANAHTARINI_YAZ';

  // TMDB'den bir liste çeken ortak yardımcı fonksiyon. 'yol', hangi listenin istendiğini söyler.
  static Future<List<dynamic>> _listeGetir(String yol) async {
    // İstek adresini hazırlar: anahtar ve Türkçe dil seçeneği ile birlikte.
    final adres = Uri.parse(
      'https://api.themoviedb.org/3/$yol?api_key=$_anahtar&language=tr-TR',
    );
    // Adrese istek gönderir ve cevabı bekler.
    final cevap = await http.get(adres);
    // Cevap başarılı değilse (200 başarı kodudur) hata fırlatır.
    if (cevap.statusCode != 200) {
      throw Exception('TMDB cevap vermedi: ${cevap.statusCode}');
    }
    // Gelen metni Dart verisine çevirir.
    final veri = jsonDecode(cevap.body);
    // Cevabın içindeki 'results' listesini (film ya da dizi listesini) döndürür.
    return veri['results'] as List<dynamic>;
  }

  // Şu an popüler olan filmleri getirir.
  static Future<List<dynamic>> populerFilmler() => _listeGetir('movie/popular');

  // Şu an popüler olan dizileri getirir.
  static Future<List<dynamic>> populerDiziler() => _listeGetir('tv/popular');
}