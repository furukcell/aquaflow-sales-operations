# AquaFlow — gerçek uygulama geliştirme

AquaFlow, Next.js + TypeScript tabanlı gerçek uygulama olarak geliştirilmektedir.

## Başlangıç
- Node.js 20+
- `npm install`
- `npm run dev`
- `http://localhost:3000`

## Teknoloji
- Next.js App Router
- React
- TypeScript

## Yol haritası
1. Uygulama iskeleti ve React ekranları
2. Kimlik doğrulama ve şirket/rol yetkileri
3. PostgreSQL/Supabase, RLS ve dosya depolama
4. CRM, teklifler, siparişler, sözleşmeler, sevkiyatlar, belgeler ve finans
5. Audit log, raporlar, testler ve deployment

Eski statik taslaklar `prototype/` klasöründe tutulur. Gerçek kod `app/` ve `components/` altında ilerler. Dashboard şu an gerçek React bileşenidir; henüz veritabanına bağlı değildir ve örnek veri kullanır.
