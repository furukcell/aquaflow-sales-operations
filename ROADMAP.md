# AquaFlow — Ürün ve Yazılım Geliştirme Yol Haritası

Bu belge, AquaFlow'un ilk prototipten güvenilir bir satış ve operasyon yönetim platformuna dönüşmesi için izlenecek planı gösterir. Tamamlandı olarak işaretlenen maddeler repo içinde temel uygulama/arayüz veya şema düzeyinde mevcut olabilir; `[x]` işaretleri tek başına canlı ortamda test edildiği anlamına gelmez. Test gerektiren maddeler ayrıca not edilmiştir.

## Geliştirme stratejisi

Önce baştan sona çalışan temel iş akışını oluşturacağız. İlk hedef; **müşteri → sözleşme → sevkiyat planı → gerçekleşen sevkiyat → belge** sürecini çalışır hale getirmek. Finans, görevler ve raporlama bu sağlam kayıtların üzerine eklenecek.

---

## Faz 0 — Proje tanımı ve repo temeli
**Durum: Devam ediyor**

### Yapılacaklar
- [x] Proje amacı ve ilk kapsamı tanımlandı
- [x] Ana modüller belirlendi
- [x] Statik dashboard prototipi hazırlandı
- [x] GitHub reposu ve dokümantasyon oluşturuldu
- [x] Teknoloji ve canlıya alma yöntemi kararlaştırıldı: Supabase backend + Firebase Hosting/Next.js yayın
- [ ] Proje klasör yapısı ve geliştirme standartları oluşturulacak
- [ ] Ortam ayarları ve gizli bilgiler yönetimi kurulacak
- [ ] Uygun lint, format ve test altyapısı kurulacak
- [ ] Commit ve iş takibi standartları belirlenecek

### Tamamlanma kriterleri
- Teknoloji kararları belgelenmiş olmalı.
- Geliştirme ortamı yeniden kurulabilir olmalı.
- Proje klasör yapısı hazır olmalı.
- Prototip ve proje kapsamı repo içinde yer almalı.


## Faz 0.5 — Hosting ve yayın mimarisi
**Durum: Karar verildi; yapılandırma ve yayın henüz yapılmadı**

### Mimari kararı
- [x] Supabase PostgreSQL veritabanı korunacak
- [x] Supabase Auth korunacak
- [x] Supabase Storage dosya depolama için korunacak
- [x] Web yayın altyapısı Firebase tarafında olacak
- [ ] Next.js 15 uygulaması için Firebase'in uygun hosting yaklaşımı (App Hosting/Frameworks entegrasyonu) doğrulanacak
- [ ] Firebase projesi oluşturulacak ve repo ile bağlanacak
- [ ] Firebase yayın yapılandırması eklenecek
- [ ] Supabase ortam değişkenleri Firebase yayın ortamında güvenli şekilde tanımlanacak
- [ ] Preview/test yayını alınacak
- [ ] Auth, Storage, RLS ve tüm kritik iş akışları yayın ortamında test edilecek
- [ ] Production yayını ve domain bağlantısı yapılacak

### Tamamlanma kriterleri
- Next.js uygulaması seçilen Firebase hosting çözümünde başarıyla yayınlanmalı.
- Supabase oturum, veritabanı ve dosya erişimi canlı ortamda çalışmalı.
- Gizli anahtarlar repo içine konulmamalı.
- Şirket izolasyonu ve yetkilendirme yayın ortamında test edilmeli.

---
## Faz 1 — Güvenli uygulama altyapısı
**Öncelik: Kritik**

### Yapılacaklar
- [x] Kullanıcı girişi ve oturum sistemi (Supabase Auth arayüzü)
- [x] Şirket/tenant veri modeli (şema mevcut)
- [ ] Kullanıcı ve şirket üyelik yapısı
- [x] İlk rol ve yetki sistemi (temel rol alanı ve kullanıcı yönetimi mevcut; kapsamlı kontrol tamamlanmadı)
- [ ] Sunucu tarafında yetki kontrolü
- [ ] Şirket verilerinin birbirinden izolasyonu ve testleri
- [x] Ana uygulama ekranı, menüler ve responsive yapı (arayüz düzeyinde)
- [ ] Hata yönetimi ve log altyapısı
- [ ] Veritabanı şema ve migration yaklaşımı
- [ ] Belge dosyalarının saklanacağı altyapı

### İlk roller (gerektiğinde değiştirilecek)
- Şirket yöneticisi
- Yönetici/manager
- Personel
- Sadece görüntüleme yetkisi (gerektiğinde)

### Tamamlanma kriterleri
- Kullanıcı giriş yapabilmeli.
- Kullanıcı açıkça tanımlanmış bir şirket hesabına bağlı olmalı.
- Şirket verilerine erişim sunucu tarafında kontrol edilmeli.
- Ana uygulama iskeleti çalışmalı.
- Şirket izolasyonu testleri geçmeli.

## Faz 2 — Müşteri yönetimi
**Öncelik: Yüksek**

### Yapılacaklar
- [x] Müşteri listesi, arama ve filtreler (arayüz mevcut; tamamlanma kriterleri henüz doğrulanmadı)
- [x] Müşteri oluşturma, düzenleme ve görüntüleme (arayüz mevcut; test edilmedi)
- [ ] Müşteri yetkilileri/iletişim kişileri
- [ ] Ülke ve müşteri sınıflandırması
- [x] Müşteri notları (alan mevcut)
- [ ] İşlem geçmişi altyapısı
- [ ] Müşteri profilinde ticari, operasyon, belge ve finans alanları
- [x] Excel/CSV ile müşteri içe aktarma (eşleştirme/önizleme ve aktarım arayüzü mevcut; test edilmedi)
- [ ] Müşteri verilerini dışa aktarma

### Tamamlanma kriterleri
- Müşteriler oluşturulabilmeli, düzenlenebilmeli, aranabilmeli ve içe aktarılabilmeli.
- Müşteri profili ilişkili kayıtların merkezi olmalı.
- İçe aktarma hataları kullanıcıya anlaşılır şekilde gösterilmeli.

## Faz 3 — Ürün kataloğu, teklifler ve siparişler
**Öncelik: Yüksek**

### Yapılacaklar
- [ ] Ürün ve özellik kataloğu
- [ ] Tür, boy/kalibre alanları (gerektiğinde yapılandırılabilir)
- [ ] Birimler ve miktar doğrulama
- [ ] Fiyat ve para birimi alanları
- [x] Teklif oluşturma ve durumları (arayüz mevcut; test edilmedi)
- [x] Teklif takip sistemi (temel durum takibi mevcut; test edilmedi)
- [x] Sipariş kayıtları (arayüz mevcut; test edilmedi)
- [ ] Tekliften siparişe dönüşüm
- [ ] Ticari kayıt geçmişi

### Tamamlanma kriterleri
- Teklif ve siparişler müşteri ve ürünlerle bağlantılı olmalı.
- Ticari bilgiler sözleşme oluştururken kullanılabilmeli.
- Miktar ve para birimi verileri tutarlı tutulmalı.

## Faz 4 — Sözleşme yönetimi ve sevkiyat planı
**Öncelik: Kritik — İlk uçtan uca iş akışı**

### Yapılacaklar
- [x] Sözleşme oluşturma ve düzenleme (arayüz mevcut; test edilmedi)
- [x] Sözleşme numarası ve durumu (temel alanlar mevcut; test edilmedi)
- [ ] Sözleşme tarafları ve ticari şartlar
- [ ] Ürün, boy, miktar ve fiyat
- [ ] Para birimi
- [ ] Sözleşme tarihleri ve şartları
- [ ] Sözleşme içindeki sevkiyat takvimi
- [ ] Bir sözleşmeye birden fazla sevkiyat planı ekleme
- [ ] Sözleşme belgeleri
- [ ] Sözleşme özeti ve gerçekleşme takibi
- [ ] Sözleşmedeki planlardan otomatik sevkiyat kayıtları oluşturma/bağlama
- [ ] Aynı planın yanlışlıkla iki kez oluşturulmasını önleme
- [ ] Tarih veya miktar değişikliklerinin geçmişini koruma

### Tamamlanma kriterleri
- Bir sözleşmeye birden fazla planlı sevkiyat girilebilmeli.
- Planlar tekrar manuel giriş gerektirmeden sevkiyat ekranına yansıtılmalı.
- Sözleşme toplamları ve gerçekleşme özeti tutarlı olmalı.
- Plan değişiklikleri takip edilebilmeli.

## Faz 5 — Sevkiyat operasyonları
**Öncelik: Kritik**

### Yapılacaklar
- [x] Sevkiyat plan listesi ve takvimi (liste arayüzü mevcut; takvim kapsamı ayrıca doğrulanmalı)
- [ ] Müşteri, tarih, durum ve ülke filtreleri
- [ ] Sevkiyat detay ekranı
- [ ] Sevkiyat kontrol listesi
- [ ] Hazırlık durumları
- [x] Gerçekleşen sevkiyat tarihi ve miktarı (şema/arayüz alanları mevcut; test edilmedi)
- [ ] Planlanan-gerçekleşen karşılaştırması
- [x] Sevkiyat notları (alan mevcut)
- [ ] Sevkiyat belgeleri ve dosyaları
- [ ] Sevkiyat işlem geçmişi
- [ ] Sözleşme sevkiyat gerçekleşme özeti
- [ ] Geciken, yaklaşan ve tamamlanan sevkiyat göstergeleri

### Önerilen ilk durum akışı
Planlandı → Hazırlanıyor → Hazır → Sevk edildi → Tamamlandı

Durum isimleri gerçek operasyonla karşılaştırılarak netleştirilecek.

### Tamamlanma kriterleri
- Sevkiyat müşteri ve gerekiyorsa sözleşmeyle bağlı olmalı.
- Planlanan ve gerçekleşen değerler ayrı tutulmalı.
- Belgeler ve kontrol listesi sevkiyat ekranından erişilebilir olmalı.
- Durum ve geçmiş takip edilebilmeli.

## Faz 6 — Belge yönetimi
**Öncelik: Yüksek**

### Yapılacaklar
- [x] Merkezi belge listesi (arayüz mevcut; test edilmedi)
- [x] Belge kategorileri (alan mevcut; test edilmedi)
- [ ] Belgeleri müşteri, sözleşme ve sevkiyata bağlama
- [ ] Belge bilgileri (tarih, kategori, yükleyen, ilişkili kayıtlar)
- [ ] Arama ve filtreleme
- [x] Güvenli belge erişimi (Storage bucket/policy taslağı mevcut; doğrulanmadı)
- [ ] Sözleşme/sevkiyat belge kontrol listesi
- [ ] Dosya sürüm takibi yaklaşımı
- [ ] Uygun dosyalarda indirme ve önizleme
- [ ] Belge şablonları
- [ ] Şablonlar netleştikten sonra temel proforma/belge oluşturma

### Tamamlanma kriterleri
- Belgeler merkezi listeden veya ilişkili kayıtlardan bulunabilmeli.
- Dosya erişimi şirket ve kullanıcı yetkilerine uymalı.
- Belgeler kategorize edilip kayıtlarla ilişkilendirilebilmeli.

## Faz 7 — Finans ve alacak takibi
**Öncelik: Yüksek**

### Yapılacaklar
- [x] Finans kayıtları (arayüz mevcut; test edilmedi)
- [ ] Sözleşme/sevkiyat tutar özetleri
- [x] Ödemeler ve ödeme tarihleri (arayüz/şema mevcut; test edilmedi)
- [ ] Ödemelerin ilgili sözleşmelere bağlanması (gerektiğinde)
- [ ] Avans kayıtları
- [x] Kalan bakiye hesaplama (arayüz hesaplamaları mevcut; doğrulanmadı)
- [x] Vade tarihleri (alan/arayüz mevcut; test edilmedi)
- [ ] Gecikme durumu ve uyarılar
- [ ] Çoklu para birimi ve gerektiğinde açık kur yönetimi
- [ ] Müşteri bakiye ekranı
- [ ] Ödeme geçmişi
- [ ] Finans verilerini dışa aktarma

### Tamamlanma kriterleri
- Ödeme kayıtları ve kalan tutarlar anlaşılır ve izlenebilir olmalı.
- Vadesi yaklaşan ve geciken ödemeler görülebilmeli.
- Para birimi kuralları belgelenmeli.
- Modül resmi muhasebe değil, operasyonel finans takibi olarak kalmalı.

## Faz 8 — Ajanda, görevler, hatırlatmalar ve iletişim geçmişi
**Öncelik: Orta-Yüksek**

### Yapılacaklar
- [x] Görevler (oluşturma, durum değiştirme ve filtreler; test edilmedi)
- [ ] Görev atama
- [ ] Görev öncelikleri ve durumları
- [x] Son tarihe göre sıralama ve gecikmiş görev görünürlüğü (arayüz; test edilmedi)\n- [ ] Son tarihler için otomatik hatırlatmalar
- [ ] Ortak ve kişisel ajanda
- [ ] Müşteri takip kayıtları
- [ ] İletişim notları
- [ ] Müşteri, sözleşme ve sevkiyata bağlı görevler
- [ ] Bildirim merkezi
- [ ] İşlem geçmişi

### Tamamlanma kriterleri
- Takip işleri atanıp izlenebilmeli.
- Görevler ilgili kayıtlara bağlı olmalı.
- Yaklaşan ve geciken işler görünür olmalı.

## Faz 9 — Dashboard ve raporlama
**Öncelik: Orta-Yüksek**

### Yapılacaklar
- [x] Gerçek verilerle çalışan dashboard (Supabase veri bağlantısı mevcut; doğrulanmadı)\n- [x] Görev sayısının sınırlı liste yerine toplam kayıt sayısından hesaplanması (kod düzeyinde düzeltildi; test edilmedi)\n- [x] Finans açık bakiye hesaplamasının mevcut payments şemasındaki amount/status alanlarına uyarlanması (kod düzeyinde düzeltildi; test edilmedi)
- [ ] Satış özeti ve trendler
- [ ] Sevkiyat özeti
- [ ] Yaklaşan sevkiyat paneli
- [ ] Sevkiyat gerçekleşme ve fark analizi
- [ ] Müşteri performansı
- [ ] Ülke/pazar raporları
- [ ] Ürün/boy raporları
- [ ] Alacak ve gecikmiş ödeme özetleri
- [ ] Tarih filtreleri
- [ ] Dışa aktarılabilir raporlar

### Tamamlanma kriterleri
- Dashboard göstergeleri gerçek kayıtlardan hesaplanmalı.
- Raporların tanımları ve filtreleri açık olmalı.
- Dışa aktarılan sonuçlar ekrandaki verilerle tutarlı olmalı.

## Faz 10 — İçe/dışa aktarma ve kullanım kalitesi
**Öncelik: Orta**

### Yapılacaklar
- [x] Excel/CSV içe aktarma altyapısı (müşteri içe aktarımı mevcut; test edilmedi)
- [x] İçe aktarma eşleştirme ve doğrulama (temel eşleştirme/önizleme mevcut; test edilmedi)
- [x] Yinelenen kayıt kontrolü (müşteri aktarımında şirket bazlı; test edilmedi)
- [ ] Önizleme ve hata raporu
- [ ] Excel/CSV dışa aktarma
- [ ] PDF/yazdırma uyumlu raporlar
- [ ] Boş, yükleniyor ve hata ekranları
- [ ] Mobil uyum
- [ ] Erişilebilirlik ve kullanım kolaylığı kontrolü
- [ ] Performans incelemesi

### Tamamlanma kriterleri
- Kullanıcı verileri güvenli şekilde içe aktarabilmeli ve dışa çıkarabilmeli.
- İçe aktarma hataları sessizce veri bozulmasına veya kayıtların çoğalmasına neden olmamalı.
- Ana ekranlar masaüstü ve mobil boyutlarda kullanılabilmeli.

## Faz 11 — Otomasyonlar ve entegrasyonlar
**Öncelik: Sonraki aşamalar**

### Planlanan özellik adayları
- [ ] Otomatik hatırlatmalar
- [ ] Sevkiyat ve ödeme tarihlerine bağlı bildirimler
- [ ] E-posta entegrasyonu (değerlendirilecek)
- [ ] Takvim entegrasyonu (değerlendirilecek)
- [ ] Mesajlaşma entegrasyonları (değerlendirilecek)
- [ ] Otomatik belge üretimi
- [ ] İş akışı kuralları

### Tamamlanma kriterleri
- Otomasyonlar güvenilir, yönetilebilir ve kayıt altına alınabilir olmalı.
- Hatalar görünür olmalı ve yeniden denenebilmeli.
- Entegrasyonlar yetki kontrollerini atlamamalı.

## Faz 12 — AI destekli özellikler
**Öncelik: Daha sonra; ilk geliştirme kapsamı değil**

### Özellik adayları
- [ ] Sözleşme PDF'lerinden veri çıkarma/OCR
- [ ] Çıkarılan sözleşme bilgilerini önerme
- [ ] Belge sınıflandırma
- [ ] Doğal dille arama
- [ ] Rapor özetleri
- [ ] Veri girişine yardımcı özellikler

### Güvenlik ve kontrol ilkeleri
- AI çıktısı, ana kayıtları değiştirmeden önce kullanıcı tarafından kontrol edilebilmeli.
- Mümkün olduğunda çıkarılan verinin kaynağı ve güven düzeyi tutulmalı.
- AI, sözleşme, sevkiyat veya finans verilerini sessizce değiştirmemeli.

## Faz 13 — SaaS'a hazır hale getirme
**Öncelik: İç kullanım süreçleri doğrulandıktan sonra**

### Yapılacaklar
- [ ] Yeni şirket hesabı açma süreci
- [ ] Şirket ayarları
- [ ] Kullanıcı davetleri ve yönetimi
- [ ] Yetki özelleştirme
- [ ] Abonelik ve ücretlendirme modelini değerlendirme
- [ ] Şirket bazlı yapılandırmalar
- [ ] Sistem izleme
- [ ] Yedekleme ve geri yükleme testleri
- [ ] Güvenlik incelemesi
- [ ] Kullanım ve destek süreçleri dokümantasyonu

### Tamamlanma kriterleri
- Yeni şirket, manuel veritabanı işlemleri gerektirmeden sisteme dahil edilebilmeli.
- Şirketler arası veri izolasyonu bağımsız olarak test edilmeli.
- Operasyon ve güvenlik prosedürleri belgelenmeli.

## Her fazda uygulanacak ortak kontroller

- [ ] Güvenlik ve yetki incelemesi
- [ ] Şirket izolasyonu kontrolü
- [ ] Veri doğrulama ve hata ekranları
- [ ] İşlem geçmişi değerlendirmesi
- [ ] Mobil uyum
- [ ] Kritik iş mantığı için testler
- [ ] Dokümantasyon güncellemesi
- [ ] Gizli bilgiler repo içine eklenmemeli
- [ ] İş mantığı mümkün olduğunca arayüzden ayrı tutulmalı

## İlk yapılacak işler

1. Teknoloji ve canlıya alma kararlarını netleştirmek.
2. Repo içindeki çalışma yapısını oluşturmak.
3. Güvenli şirket ve kullanıcı altyapısını geliştirmek.
4. Müşteri yönetimini geliştirmek.
5. Sözleşme oluşturma ve sevkiyat planı bağlantısını kurmak.
6. Sevkiyat planlama ve gerçekleşme modülünü geliştirmek.
7. Belgeleri bu kayıtlara bağlamak.

---

**Roadmap güncelleme kuralı:** Bir özellik yalnızca gerçekten geliştirilip tamamlanma kriterlerini karşılıyorsa tamamlandı olarak işaretlenir. Öncelikler gerçek operasyon ihtiyaçlarına göre değişebilir.

## Firebase App Hosting ön hazırlığı (2026-11-25)
- [x] Next.js 15 için Firebase App Hosting config taslağı (apphosting.yaml) eklendi; ortam değerleri backend ayarlarından sağlanmalı.
- [x] GitHub Actions build doğrulama workflow taslağı eklendi.
- [ ] Firebase App Hosting backend oluşturulmalı ve GitHub repo bağlanmalı.
- [ ] Supabase URL ve anon key Firebase App Hosting ortamına eklenmeli.
- [ ] CI build sonucu repo ortamında doğrulanmalı.
- [ ] Preview deployment ve oturum/DB/Storage akışları test edilmeli.


## Super-admin ilk ekran (2026-11-25)
- [x] Platform super-admin dashboard tenant sorgularından ayrıştırıldı; super-admin `/admin/companies` ekranına yönlendirilir.
- [x] Super-admin şirket ve ilk şirket yöneticisi oluşturma ekranı eklendi (mevcut `superadmin-create-company` Edge Function kullanılır).
- [ ] Canlı ortamda Edge Function deployment ve şirket oluşturma akışı doğrulanmalı.
- [ ] Şirket listeleme, durumu ve detay yönetimi sonraki iterasyonda eklenecek.


## Super-admin panel genişletme (2026-11-25)
- [x] Platform genel bakış sayaçları (şirket, kullanıcı, şirket yöneticisi ve tenant bağlantısız profiller)
- [x] Şirket listesi ve şirket başına kullanıcı/yönetici sayıları
- [x] Platform kullanıcı listesi, rol ve şirket bağlantısı görünümü
- [x] Arama ve liste yenileme
- [x] Şirket oluşturma akışında 25 saniyelik istemci zaman aşımı uyarısı ve işlem sonrası kayıtları yenileme
- [ ] Şirket durum/plan yönetimi ve güvenli yönetici işlemleri
- [ ] Audit log, platform destek/işlem geçmişi ve tenant güvenlik kontrolleri


## 2026-11-26 — Tenant ilişki bütünlüğü
- [x] Tek tenant içinde müşteri, teklif, sipariş, sözleşme, sevkiyat, tahsilat ve evrak bağlantıları için composite foreign key migration taslağı eklendi (NOT VALID ile mevcut kayıtları başlangıçta bloklamadan).
- [x] Teklif/sipariş kalemleri ve sözleşme dosyalarının parent tenant ilişkileri kısıtlandı.
- [x] Mevcut veri uyuşmazlıklarını tespit etmek için salt-okunur SQL audit dosyası eklendi.
- [ ] Audit sonuçları temizlendikten sonra kısıtlar VALIDATE CONSTRAINT ile doğrulanmalı; Supabase hedef ortamında migration uygulaması ayrıca yapılmalı.
- [ ] Tenant izolasyonunun gerçek iki-tenant testleri CI/DB test ortamında yürütülmeli.
\n\n## 2026-11-26 — Şirket oluşturma akışı hata görünürlüğü\n- [x] Super-admin şirket oluşturma istemci timeout süresi 45 saniyeye çıkarıldı; timeout sonunda kontrol/yenileme uyarısı gösterilir.\n- [x] Edge Function aşama bazlı loglama ve hata yanıtı (stage) eklendi.\n- [x] Kullanıcı adı kontrolü ve rollback adımlarında hata durumları raporlanır.\n- [x] README'ye login route'u ve kaynak kod bağlantısı eklendi.\n- [ ] Edge Function Supabase'e deploy edilip canlı şirket oluşturma uçtan uca test edilmeli.\n- [ ] Uygulama build/lint ve gerçek UI testi yapılmalı.\n

## 2026-11-26 — Aktif `/superadmin` oluşturma ekranı hata yönetimi
- [x] Ekran görüntüsünde kullanılan `app/superadmin/page.tsx` rotası doğrulandı; önceki düzeltme farklı panel dosyasındaydı.
- [x] Aktif route create akışına try/catch/finally, 45 saniye AbortController timeout ve oturum kontrolü eklendi.
- [x] Edge Function `stage` hata alanı kullanıcıya gösterilir; busy durumu finally ile temizlenir.
- [ ] Firebase App Hosting deploy sonrası canlı akış doğrulanmalı; sunucu tarafı işlemin timeout sonrası tamamlanmış olabileceği dikkate alınmalı.


## 2026-11-26 — Edge Function çağrı yöntemi değişikliği
- [x] Aktif `/superadmin` ekranındaki doğrudan `fetch()` çağrısı `supabase.functions.invoke()` SDK çağrısına dönüştürüldü; timeout ve hata yakalama eklendi.
- [ ] Deploy sonrası canlı test: Edge Function erişimi, CORS ve API başlıkları doğrulanmalı.


## 2026-11-27 — Tenant-safe task assignments
- [x] Görev atamalarında `assigned_to` kullanıcısının aynı `company_id` tenant'ına ait olmasını yeni/ değiştirilen kayıtlar için composite FK ile zorlayan `NOT VALID` migration eklendi.
- [x] Mevcut uygunsuz atamaları salt okunur biçimde tespit eden `supabase/task-assignment-audit.sql` eklendi.
- [ ] Audit çıktısı Supabase'te incelenmeli; mevcut kayıtlar temizlendikten sonra `tasks_assignee_company_fk` doğrulanmalı (`VALIDATE CONSTRAINT`).
- [ ] Migration Supabase hedef ortamında uygulanmalı ve iki-tenant atama testi yapılmalı.


## 2026-11-27 — Super-admin panel route alignment
- [x] Legacy `/superadmin` route redirected to `/admin/companies`, which contains the platform overview, company list, user list and company-creation tabs.
- [ ] Firebase deployment and browser verification of the redirected panel.


## 2026-11-27 — Super-admin list visibility fix
- [x] Added `superadmin-platform-data` Edge Function: authenticates caller and checks `super_admin` role, then fetches company/profile listing through service-role client.
- [x] Super-admin panel refresh now calls the validated Edge Function instead of querying tenant-wide companies/profiles directly under restrictive RLS.
- [ ] Deploy `superadmin-platform-data` in Supabase and verify live company/user listing.


## 2026-11-27 — Super-admin Edge Function role lookup hardening
- [x] Role doğrulaması, caller JWT ile Auth kullanıcı doğrulamasından sonra service-role client üzerinden profile role kontrolü yapacak şekilde değiştirildi; RLS kaynaklı role lookup engeli giderilmeye çalışıldı.
- [x] Panel hata gösterimi Edge Function'ın döndürdüğü detaylı hata metnine öncelik verir.
- [ ] Supabase'e güncel Edge Function deploy edilmeli ve canlı panel test edilmeli.


## 2026-11-27 — İlk giriş parola değişikliği RLS düzeltmesi
- [x] Parola değişimi sonrası profiles tablosuna doğrudan client UPDATE yerine yalnızca auth.uid() profili için flag temizleyen RPC eklendi.
- [x] RPC execute yetkisi authenticated ile sınırlandırıldı; anon/public erişimi kapatıldı.
- [ ] Supabase migration uygulanmalı; şirket yöneticisinin ilk giriş ve şifre değişimi canlı test edilmeli.


## 2026-11-27 — Şirket kullanıcı yönetimi UX iyileştirmesi
- [x] Çalışan hesabı oluşturma sırasında çift gönderimi engelleyen busy state eklendi.
- [x] Başarılı/başarısız Edge Function yanıtlarında işlem durumu kullanıcıya görünür hale getirildi.
- [x] Kullanıcı listesinde roller Türkçe açıklamalarla gösteriliyor.
- [ ] Canlı ortamda kullanıcı oluşturma ve rol listesi testi.


## 2026-11-27 — Ajanda etkinlik ve hatırlatma iyileştirmesi
- [x] Görev tablosuna etkinlik türü, açıklama ve hatırlatma dakika alanları için migration eklendi.
- [x] Görev ekranında toplantı/etkinlik/görev türü, açıklama ve hatırlatma seçimi.
- [x] Dashboard takviminde tarih seçimi ve seçilen günün planlarının listelenmesi.
- [x] Hatırlatma penceresi içinde yaklaşan planlar dashboard'da uyarı olarak gösterilir (dashboard açıkken).
- [ ] Migration Supabase'te uygulanmalı ve canlı verilerle test edilmeli.
- [ ] Build ve mobil cihaz testleri yapılmalı.


## 2026-11-27 — Dashboard referans tasarım revizyonu
- [x] Dashboard ana layout referans görseldeki 5 hızlı işlem butonu sırasına dönüştürüldü.
- [x] Sidebar şirket seçici görseli, logo alanı ve kullanıcı profil görünümü yenilendi.
- [x] Üst bar arama alanı, bildirim göstergesi ve kullanıcı avatarı tasarımına geçildi.
- [x] Dashboard KPI kartları, referansın açık renkli, renk kodlu ve kompakt kart yaklaşımına göre düzenlendi.
- [x] Dashboard ana panel, takvim ve sevkiyat alanlarının spacing, sınır, renk ve tipografi değerleri referansa yaklaştırıldı.
- [ ] Firebase deploy sonrası referansla ekran görüntüsü karşılaştırması; fotoğraf, responsive yerleşim ve gerçek verilerin kartlarda doğru gösterimi kontrol edilmeli.
- [ ] Build/lint ve mobil/masaüstü testleri yapılmalı.
