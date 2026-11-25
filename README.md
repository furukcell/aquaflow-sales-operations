# AquaFlow — Satış ve Operasyon Yönetim Platformu

AquaFlow; müşteri ilişkileri, teklif, sipariş, sözleşme, sevkiyat, evrak ve finans süreçlerini tek bir platformda birleştirmek amacıyla geliştirilen çok şirketli (multi-tenant) bir iş yönetim sistemidir.

> **Geliştirme durumu:** Proje aktif geliştirme aşamasındadır. Kod deposuna eklenen özellikler ile canlı ortamda doğrulanmış özellikler birbirinden ayrılmaktadır. Henüz tüm SQL değişiklikleri canlı Supabase ortamında uygulanmış, uçtan uca test edilmiş veya üretim ortamı için doğrulanmış değildir.

## Ürünün amacı ve iş akışı

AquaFlow, ticari operasyonları birbiriyle bağlantılı süreçler olarak takip etmeyi hedefler:

1. **Müşteriler / CRM:** Şirket bilgileri, iletişim bilgileri ve müşteri kayıtları.
2. **Teklifler:** Teklif numarası, para birimi, tutar, geçerlilik tarihi, kalemler ve durum takibi.
3. **Siparişler:** Kabul edilen tekliflerden sipariş oluşturma, sipariş kalemleri ve süreç takibi.
4. **Sözleşmeler:** Sözleşme kayıtları, durumlar ve sözleşme dosyaları.
5. **Sevkiyatlar:** Ürün, miktar, birim, hedef, planlanan/gerçekleşen tarihler ve sevkiyat durumu.
6. **Evrak yönetimi:** Müşteri, teklif, sipariş, sözleşme veya sevkiyatla ilişkilendirilebilen merkezi dosya arşivi.
7. **Finans ve tahsilatlar:** Ödeme kayıtları, vade, para birimi, tahsil edilen tutarlar, kalan bakiye ve ödeme referansları.
8. **Görevler ve hareketler:** Operasyonel takip için görev ve aktivite kayıtları.
9. **Dashboard ve raporlama:** Kayıtlar üzerinden oluşturulan operasyonel ve finansal özetler.

Amaç, müşteri bağlamını tekliften siparişe, sözleşmeye, sevkiyata, evraka ve tahsilata kadar koparmadan takip edebilmek; dağınık Excel dosyalarına olan ihtiyacı azaltmaktır.

## Şirket ayrımı ve yetkilendirme

AquaFlow çok şirketli SaaS yapısına göre tasarlanmıştır. Kullanıcılar şirket profilleriyle ilişkilendirilir ve veriler şirket bazında ayrılır. Rol bazlı yetkilendirme yaklaşımı kullanılır. Veritabanında PostgreSQL Row Level Security (RLS) politikaları bulunur. Kimlik doğrulama Supabase Auth, veri tabanı Supabase PostgreSQL, dosyalar ise Supabase Storage üzerinden yönetilir.

RLS ve depolama politikalarının hedef ortamda ayrıca test edilmesi gerekir.

## Kullanılan teknolojiler

- Next.js App Router
- React ve TypeScript
- Supabase Auth
- Supabase PostgreSQL ve RLS
- Supabase Storage
- Excel dosyaları için XLSX okuma altyapısı

## Mevcut kod kapsamı

Kod tarafında altyapısı bulunan modüller:

- Müşteri yönetimi — `app/customers`
- Teklifler ve teklif kalemleri — `app/offers` ve veritabanı şeması
- Siparişler ve tekliften siparişe dönüşüm — `app/orders`
- Sözleşmeler — `app/contracts`
- Sevkiyatlar — `app/shipments`
- Evrak arşivi — `app/documents`
- Finans ve tahsilatlar — `app/finance`
- Kullanıcı, profil ve şirket kurulum akışları
- Supabase verilerinden beslenen Dashboard
- Müşteri dosya aktarımı — `app/import`

## Müşteri dosya aktarımı

Aktarım ekranı Excel (.xlsx, .xls) ve CSV dosyalarından müşteri aktarımı için geliştirilmiştir:

1. Excel veya CSV dosyası seçilir.
2. Excel dosyalarında ilk çalışma sayfası okunur.
3. Kaynak sütunları AquaFlow müşteri alanlarıyla eşleştirilir.
4. Aktarım öncesi satır önizlemesi sunulur.
5. Şirket adı olmayan satırlar aktarım dışında bırakılır.
6. Şirket içindeki mevcut kayıtlarla isim bazlı mükerrer kontrolü yapılır.
7. Uygun kayıtlar kullanıcının şirketine aktarılır.

Teklif, sipariş, sözleşme, sevkiyat ve ödeme aktarımı henüz tamamlanmamıştır. Bu kayıtların birbirine bağlı aktarımı için referans eşleştirme ve doğru aktarım sırası gereklidir.

## Planlanan aktarım yaklaşımı

- Dosya ve sütun başlıklarının okunması
- Alan eşleştirme
- Zorunlu alan ve format doğrulaması
- Aktarım önizlemesi ve hata uyarıları
- Müşteri/sipariş gibi bağlı kayıtların çözülmesi
- Bağlantı sırasına göre aktarım
- Başarılı, atlanan ve hatalı kayıt raporu

Her Excel dosyasının otomatik olarak aktarılacağı garanti edilmez; dosyanın yapısına göre eşleştirme veya düzenleme gerekebilir.

## Yerel ortamda çalıştırma

Node.js 20+ gerekir.

```bash
npm install
```

Proje kökünde `.env.local` dosyasını oluşturun:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

Uygulamayı başlatın:

```bash
npm run dev
```

Ardından http://localhost:3000 adresini açın.

## Supabase kurulumu

- `supabase/schema.sql` dosyasını inceleyin ve hedef Supabase projesine uygulayın.
- Supabase Auth ve şirket/profil kurulumunu yapılandırın.
- Özel Storage alanlarını ve erişim politikalarını yapılandırın.
- Ortam değişkenlerini tanımlayın.
- Gerçek verileri yüklemeden önce farklı şirket ve kullanıcılarla erişim ayrımını test edin.

## Geliştirme yol haritası

- [x] Uygulama kabuğu ve navigasyon
- [x] Supabase kimlik doğrulama ve şirket/profil altyapısı
- [x] Müşteri yönetimi
- [x] Teklifler ve sipariş iş akışı
- [x] Sözleşme ve sevkiyat altyapısı
- [x] Evrak arşivi altyapısı
- [x] Finans/tahsilat altyapısı
- [x] Supabase verileriyle Dashboard
- [x] Müşteri CSV aktarımı, eşleştirme ve mükerrer kontrol
- [x] Müşteri aktarımında Excel okuma altyapısı
- [ ] Hedef ortamda derleme ve uçtan uca doğrulama
- [ ] Teklif, sipariş, sözleşme, sevkiyat ve ödeme aktarımı
- [ ] İlişki eşleştirme ve aktarım hata raporları
- [ ] Görev/takvim akışlarının ve aktivite kaydının tamamlanması
- [ ] Raporlar, dışa aktarma ve gelişmiş filtreler
- [ ] Otomatik testler, güvenlik incelemesi ve üretim yayını

## Depo yapısı

- `app/`: Sayfalar ve uygulama modülleri
- `components/`: Ortak arayüz bileşenleri ve Dashboard
- `lib/`: Ortak yapılandırma ve yardımcı kodlar
- `supabase/schema.sql`: Veritabanı şeması, fonksiyonlar ve politikalar

Bu doküman, geliştirme kapsamını ve mevcut durumun doğrulanmış sınırlarını açıklamak için tutulmaktadır.
