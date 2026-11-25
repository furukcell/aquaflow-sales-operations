# AquaFlow — Satış ve Operasyon Yönetim Platformu

> **AquaFlow**, balık ihracatı satış ve operasyon süreçlerini tek bir sistemde birleştirmek amacıyla geliştirilen bir platformun çalışma adıdır. İlk kullanım alanı yavru balık satış ve sevkiyat operasyonlarıdır.

Şu anda müşteri bilgileri, Excel tabloları, sözleşmeler, sevkiyat planları, ödeme takibi ve belgeler farklı dosya ve klasörlerde tutulabiliyor. AquaFlow'un amacı bu dağınık yapıyı tek bir düzenli, bağlantılı ve takip edilebilir sisteme dönüştürmek.

## 🎯 Projenin amacı

Müşteriyle başlayan ticari süreci, sevkiyat ve ödeme aşamalarına kadar tek yerden takip edebilmek:

**Müşteri → Teklif → Sipariş → Sözleşme → Planlanan sevkiyatlar → Gerçekleşen sevkiyatlar → Belgeler → Ödemeler → Raporlar**

Sistem tekrar tekrar veri girmeyi azaltmalı, yaklaşan işleri görünür kılmalı, belgeleri ilgili kayıtlara bağlamalı ve önemli tarihlerin kaçırılmasını önlemelidir.

## 👥 İlk kullanım

- İlk olarak küçük bir satış ve operasyon ekibinin kullanımına göre geliştirilecek.
- İlk uygulama alanı yavru balık satış ve operasyon süreçleri olacak.
- Kullanımı kolay, hızlı ve sürdürülebilir bir yapı hedefleniyor.
- İleride farklı şirketlerin kendi hesaplarını açabildiği, kullanıcı ve yetki yönetimi bulunan SaaS yapısına dönüşmesi hedefleniyor.

## 🧭 Temel prensipler

- **Tek veri kaynağı:** Müşteri, sözleşme, sevkiyat ve ödeme bilgileri birbirinden kopuk dosyalarda değil, birbirine bağlı tutulmalı.
- **İş akışı odaklı:** Kayıtlar belirli ve anlaşılır süreçler üzerinden ilerlemeli.
- **Planlanan ve gerçekleşen ayrı tutulmalı:** Planlanan tarih/miktar ile gerçekleşen tarih/miktar birbirinin üzerine yazılmamalı.
- **İzlenebilirlik:** Önemli değişiklikler ve işlemler gerektiğinde geçmişten takip edilebilmeli.
- **Belge erişimi kolay olmalı:** Kullanıcı çalıştığı kaydın ilgili belgelerine o ekran üzerinden ulaşabilmeli.
- **Güvenli yapı:** Şirketler arası veri izolasyonu, erişim yetkileri ve dosya güvenliği temel mimarinin parçası olmalı.
- **Parça parça geliştirme:** Büyük ve kontrolsüz geliştirmeler yerine çalışan modüller aşamalı olarak teslim edilmeli.
- **İlk aşamada AI yok:** Önce veriler ve iş akışları sağlamlaştırılmalı. AI ve OCR gibi özellikler ilerleyen aşamalarda değerlendirilecek.

## 🧩 Planlanan modüller

### 1. Ana ekran ve iş merkezi
- Genel operasyon özeti ve önemli göstergeler
- Yaklaşan sevkiyatlar ve tarihler
- Bekleyen ve geciken ödemeler
- Görevler, hatırlatmalar ve son işlemler
- Uyarılar ve hızlı erişim

### 2. Müşteriler
- Müşteri/şirket profilleri
- Yetkili kişiler ve iletişim bilgileri
- Ülke, pazar ve müşteri sınıflandırması
- Müşteri işlem geçmişi
- Teklif, sözleşme, sevkiyat, belge ve finans kayıtlarına bağlantılar
- Notlar ve iletişim geçmişi

### 3. Ürünler ve fiyatlar
- Ürün kataloğu
- Balık türü, boy/kalibre ve diğer ürün özellikleri
- Birimler ve miktar kuralları
- Gerektiğinde müşteriye veya satışa özel fiyatlar
- Para birimleri

### 4. Teklif ve siparişler
- Teklif ve ticari teklif kayıtları
- Teklif durumu ve takip
- Tekliften siparişe dönüşüm
- Sipariş bilgileri ve durumları
- Müşteri, ürün, fiyat ve miktar bağlantıları

### 5. Sözleşmeler
- Sözleşme kayıtları ve durumları
- Sözleşme tarihleri ve şartları
- Ürün, miktar, fiyat ve para birimi
- Sözleşmeye bağlı sevkiyat takvimi
- Sözleşme dosyaları
- Sevkiyatlarla bağlantı
- Sözleşmenin gerçekleşme takibi

### 6. Sevkiyat planlama ve operasyon
- Planlanan sevkiyat listesi ve takvimi
- Sözleşme ve müşteri bağlantılı sevkiyatlar
- Planlanan ve gerçekleşen tarih/miktar karşılaştırması
- Sevkiyat durumu ve kontrol listesi
- Sevkiyat belgeleri
- Sevkiyat geçmişi ve değişiklikleri

### 7. Belge yönetimi
- Merkezi belge alanı
- Belgelerin müşteri, sözleşme, sevkiyat ve ödeme kayıtlarına bağlanması
- Proforma ve imzalı sözleşmeler
- Operasyon ve kalite/miktar belgeleri
- Belge kategorileri, tarihleri ve bilgileri
- İlerleyen aşamalarda belge şablonları ve sürüm takibi
- Arama ve erişim kontrolü

### 8. Finans ve alacak takibi
- Sözleşme ve sevkiyat bağlantılı finans kayıtları
- Ödeme kayıtları ve ödeme tarihleri
- Avanslar, kalan bakiyeler ve vade tarihleri
- Para birimleri
- Gecikmiş ödeme takibi
- Müşteri bakiye özeti
- Dışa aktarılabilir raporlar

> Bu modül operasyonel finans takibidir; resmi muhasebe yazılımının yerine geçmesi hedeflenmemektedir.

### 9. Görevler, ajanda ve hatırlatmalar
- Kişisel ve ortak görevler
- Görev atama
- Görev durumları
- Son tarihler ve hatırlatmalar
- Müşteri, sözleşme ve sevkiyat bağlantılı görevler
- Takvim ve ajanda
- Takip kayıtları

### 10. Raporlama ve analiz
- Tarih aralığına göre satış
- Müşteri, ürün ve ülke bazında satış
- Sevkiyat performansı
- Planlanan ve gerçekleşen sevkiyat karşılaştırmaları
- Sözleşme performansı
- Alacak ve ödeme durumu
- Dışa aktarılabilir raporlar

### 11. Sistem yönetimi
- Şirket hesapları
- Kullanıcılar, roller ve yetkiler
- İşlem geçmişi
- Şirket ayarları
- Excel içe/dışa aktarma
- Yedekleme ve kurtarma planı
- Sistem ayarları

## 🔄 Örnek iş akışı

1. Müşteri oluşturulur veya mevcut müşteri seçilir.
2. Gerekiyorsa teklif hazırlanır.
3. Kabul edilen teklif siparişe dönüştürülür.
4. Sözleşme oluşturulur ve planlanan sevkiyat tarih/miktarları girilir.
5. Sözleşmedeki sevkiyat planları ayrıca tekrar girilmeden sevkiyat ekranına ve ana ekrana yansır.
6. Sevkiyat hazırlık ve gerçekleşme bilgileri güncellenir. İlk plan bilgileri korunur.
7. İlgili belgeler sözleşmeye veya sevkiyata eklenir.
8. Ödemeler kaydedilir ve kalan tutarlar takip edilir.
9. Müşteri geçmişi ve operasyon/finans raporları incelenir.

## 🏗️ Geliştirme yaklaşımı

Geliştirme aşamaları [ROADMAP.md](./ROADMAP.md) dosyasında takip edilir. Öncelikle altyapı, müşteri yönetimi, sözleşme-sevkiyat bağlantısı ve belgeler tamamlanacaktır. Finans, görevler, raporlama ve otomasyonlar temel iş akışı güvenilir hale geldikten sonra eklenecektir.

Mimari kararlar proje ilerledikçe belgelenmelidir. İş mantığı sadece arayüze bağlı olmamalı; şirket, yetki, veri ve dosya erişim sınırları açık şekilde tasarlanmalıdır.

## 🔐 Güvenlik gereksinimleri

- Şirketler arasında veri izolasyonu
- Kimlik doğrulama ve oturum yönetimi
- Rol ve yetki sistemi
- Sunucu tarafında yetki kontrolü
- Korunan belge erişimi
- Önemli işlemler için kayıt/denetim geçmişi
- Veri doğrulama ve hata yönetimi
- Güvenli gizli anahtar yönetimi
- Yedekleme ve kurtarma planı
- Git deposuna şifre veya gizli bilgi eklenmemesi

## 🚫 İlk aşamada kapsam dışı

- Tam kapsamlı ERP veya muhasebe sistemi
- Çiftlik ve üretim yönetimi
- Stok/üretim planlama sistemi
- AI ile sözleşme okuma ve OCR
- Temel süreçler doğrulanmadan karmaşık entegrasyonlar

## 🗺️ Geliştirme yol haritası

Aşamalar, öncelikler ve tamamlanma kriterleri için [ROADMAP.md](./ROADMAP.md) dosyasına bakın.

## 📌 Projenin mevcut durumu

- [x] GitHub reposu oluşturuldu
- [x] Projenin amacı ve kapsamı tanımlandı
- [x] Ana modüller belirlendi
- [x] Statik arayüz prototipi hazırlandı
- [ ] Teknoloji ve canlıya alma altyapısı kesinleştirildi
- [ ] Kullanıcı ve şirket altyapısı geliştirildi
- [ ] Temel veri modeli oluşturuldu
- [ ] İlk uçtan uca iş akışı çalışır hale getirildi

Bu durum listesi, gerçekten geliştirilmiş özelliklere göre güncellenecektir.

---

*AquaFlow şu an çalışma adı olarak kullanılmaktadır. Marka ve isim uygunluğu araştırması henüz yapılmamıştır.*