"use client";
// Yeri: components/Dashboard.tsx  (dashboard.css ile aynı klasöre koy)
// Gerekli: npm i lucide-react   |   Banner fotoğrafı: public/hero.jpg
import "./dashboard.css";
import { useEffect, useMemo, useState, type ReactNode } from "react";
import Link from "next/link";
import { supabase } from "@/lib/supabase";
import {
  Home, Users, Tag, ShoppingCart, Upload, FileText, Ship, FolderOpen, CalendarDays, Wallet,
  BarChart3, ShieldCheck, Settings, Search, Bell, ChevronDown, ChevronLeft, ChevronRight, Plus,
  FilePlus2, CloudUpload, CalendarPlus, ClipboardCheck, Sun, Cloud, CloudRain, Fish, Package,
  Activity as Pulse, Check, Clock, FileCheck2, type LucideIcon,
} from "lucide-react";

const TENANT = "AquaHolding";
// Dashboard sayfanın yolu "/" değilse aşağıdaki ilk href'i değiştir.
const NAV: { s: string; i: [LucideIcon, string, string][] }[] = [
  { s: "GENEL", i: [[Home, "Dashboard", "/"], [Users, "Müşteriler", "/customers"], [Tag, "Teklifler", "/offers"], [ShoppingCart, "Siparişler", "/orders"], [Upload, "Veri Aktarımı", "/import"]] },
  { s: "OPERASYON", i: [[FileText, "Sözleşmeler", "/contracts"], [Ship, "Sevkiyatlar", "/shipments"], [FolderOpen, "Belge Arşivi", "/documents"], [CalendarDays, "Görev & Takvim", "/tasks"]] },
  { s: "FİNANS", i: [[Wallet, "Finans", "/finance"], [BarChart3, "Raporlar", "/reports"]] },
  { s: "YÖNETİM", i: [[ShieldCheck, "Kullanıcı & Yetki", "/admin/users"], [Settings, "Ayarlar", "/profile"]] },
];

type Cust = { company_name: string; country: string | null };
type Shipment = { id: string; shipment_number: string; planned_date: string | null; species: string | null; quantity: number | null; unit: string; destination: string | null; status: string; customers?: Cust | Cust[] | null };
type Task = { id: string; title: string; status: string; due_at: string | null; event_type: string; description: string | null };
type Log = { id: string; entity_type: string; action: string; details: any; created_at: string };

const ST: Record<string, [string, number]> = { planned: ["Planlandı", 15], preparing: ["Hazırlanıyor", 45], shipped: ["Yola çıktı", 70], delivered: ["Teslim edildi", 100], cancelled: ["İptal", 0] };
const ENT: Record<string, string> = { shipment: "Sevkiyat", customer: "Müşteri", order: "Sipariş", offer: "Teklif", contract: "Sözleşme", document: "Evrak", payment: "Ödeme", task: "Görev" };
const ACT: Record<string, string> = { created: "oluşturuldu", insert: "oluşturuldu", updated: "güncellendi", update: "güncellendi", deleted: "silindi", delete: "silindi", uploaded: "yüklendi" };
const PAL = ["#1e88e5", "#00897b", "#8e24aa", "#f57c00", "#3949ab", "#d81b60", "#43a047"];

const ymd = (d: Date) => d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0");
const hm = (d: Date) => d.toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" });
const cu = (s: Shipment): Cust | undefined => (Array.isArray(s.customers) ? s.customers[0] : (s.customers as Cust | null) || undefined);
const dayDiff = (iso: string) => Math.round((new Date(iso.slice(0, 10) + "T00:00").getTime() - new Date(ymd(new Date()) + "T00:00").getTime()) / 864e5);
const ref = (d: any) => (!d ? "" : typeof d === "string" ? d : d.shipment_number || d.offer_number || d.order_number || d.company_name || d.title || d.name || d.file_name || "");
const colorOf = (s: string) => PAL[[...s].reduce((a, c) => a + c.charCodeAt(0), 0) % PAL.length];

export function AppShell({ active, name, alerts = 0, children }: { active: string; name: string; alerts?: number; children: ReactNode }) {
  const ini = (name || "K").trim().split(/\s+/).slice(0, 2).map((x) => x[0]?.toUpperCase() || "").join("");
  return (
    <div className="af">
      <aside className="af-side">
        <div className="af-brand"><div className="af-logo"><Ship size={22} /></div><div><b>AquaFlow</b><small>SALES & OPERATIONS</small></div></div>
        <div className="af-tenant">{TENANT}<ChevronDown size={16} /></div>
        {NAV.map((g) => (
          <div key={g.s}>
            <div className="af-navlabel">{g.s}</div>
            {g.i.map(([Icon, n, href]) => (
              <Link key={n} href={href} className={"af-nav" + (active === n ? " on" : "")}><Icon size={18} />{n}</Link>
            ))}
          </div>
        ))}
        <div className="af-user"><div className="af-av">{ini}</div><div><b>{name}</b><small>Operasyon & Satış</small></div></div>
      </aside>
      <main className="af-main">
        <header className="af-top">
          <div className="af-crumb"><Home size={16} /> <span>Operasyon Merkezi /</span> <b>{active}</b></div>
          <div className="af-topr">
            <div className="af-search"><Search size={16} /> Ara... <kbd>Ctrl + K</kbd></div>
            <button className="af-bell" aria-label="Bildirimler"><Bell size={20} />{alerts > 0 && <i>{alerts}</i>}</button>
            <div className="af-av sm">{ini}</div><ChevronDown size={16} />
          </div>
        </header>
        {children}
      </main>
    </div>
  );
}

export function Dashboard() {
  const [loading, setLoading] = useState(true), [err, setErr] = useState(""), [name, setName] = useState("");
  const [m, setM] = useState({ cust: 0, custNew: null as number | null, ord: 0, ordNew: null as number | null, shipN: 0, shipQty: 0, tasks: 0, docs: 0 });
  const [ships, setShips] = useState<Shipment[]>([]), [tasks, setTasks] = useState<Task[]>([]), [logs, setLogs] = useState<Log[]>([]);
  const [now, setNow] = useState(new Date()), [wx, setWx] = useState<{ t: number; c: number } | null>(null);

  useEffect(() => { load(); const i = setInterval(() => setNow(new Date()), 30000); return () => clearInterval(i); }, []);
  useEffect(() => {
    fetch("https://api.open-meteo.com/v1/forecast?latitude=37.2153&longitude=28.3636&current=temperature_2m,weather_code")
      .then((r) => r.json()).then((j) => setWx({ t: Math.round(j.current.temperature_2m), c: j.current.weather_code })).catch(() => {});
  }, []);

  async function load() {
    if (!supabase) { setErr("Supabase yapılandırması eksik."); setLoading(false); return; }
    const sb = supabase;
    const { data: u } = await sb.auth.getUser();
    if (!u.user) { window.location.assign("/login"); return; }
    const { data: p } = await sb.from("profiles").select("role,full_name").eq("id", u.user.id).single();
    if (p?.role === "super_admin") { window.location.assign("/admin/companies"); return; }
    setName(p?.full_name || u.user.email?.split("@")[0] || "");
    const d0 = new Date(), today = ymd(d0), mStart = ymd(new Date(d0.getFullYear(), d0.getMonth(), 1)), mEnd = ymd(new Date(d0.getFullYear(), d0.getMonth() + 1, 0));
    const open = (q: any) => q.neq("status", "completed").neq("status", "cancelled");
    const R = await Promise.all([
      sb.from("customers").select("id", { count: "exact", head: true }),
      open(sb.from("orders").select("id", { count: "exact", head: true })),
      sb.from("shipments").select("id,shipment_number,planned_date,species,quantity,unit,destination,status,customers(company_name,country)").gte("planned_date", today).order("planned_date").limit(8),
      sb.from("shipments").select("quantity").gte("planned_date", mStart).lte("planned_date", mEnd),
      open(sb.from("tasks").select("id,title,status,due_at,event_type,description").order("due_at")).limit(20),
      open(sb.from("tasks").select("id", { count: "exact", head: true })),
      sb.from("documents").select("id", { count: "exact", head: true }),
      sb.from("audit_logs").select("id,entity_type,action,details,created_at").order("created_at", { ascending: false }).limit(5),
    ]);
    const [c, o, s, ms, t, tc, d, a] = R as any[];
    const cNew = await sb.from("customers").select("id", { count: "exact", head: true }).gte("created_at", mStart);
    const oNew = await open(sb.from("orders").select("id", { count: "exact", head: true })).gte("created_at", mStart);
    const names = ["customers", "orders", "shipments", "shipments(ay)", "tasks", "tasks(sayı)", "documents", "audit_logs"];
    const errs = R.map((r: any, i) => (r.error ? { q: names[i], ...r.error } : null)).filter(Boolean) as any[];
    if (errs.length) { console.error("Dashboard sorguları:", errs); setErr(errs.map((e) => `${e.q}: ${e.code || ""} ${e.message || e.details || e.hint || "boş hata"}`).join(" | ")); }
    setM({
      cust: c.count || 0, custNew: cNew.error ? null : cNew.count || 0, ord: o.count || 0, ordNew: oNew.error ? null : oNew.count || 0,
      shipN: (ms.data || []).length, shipQty: (ms.data || []).reduce((x: number, r: any) => x + (r.quantity || 0), 0), tasks: tc.count || 0, docs: d.count || 0,
    });
    setShips((s.data || []) as Shipment[]); setTasks((t.data || []) as Task[]); setLogs((a.data || []) as Log[]); setLoading(false);
  }

  async function complete(id: string) {
    setTasks((x) => x.filter((y) => y.id !== id));
    if (supabase) await supabase.from("tasks").update({ status: "completed" }).eq("id", id);
  }

  const reminders = useMemo(() => {
    const r: { k: string; title: string; sub: string; days: number }[] = [];
    ships.forEach((s) => { if (s.planned_date) { const d = dayDiff(s.planned_date); if (d >= 0 && d <= 7 && s.status !== "delivered") r.push({ k: "s" + s.id, title: `${cu(s)?.company_name || "Müşteri"} – sevkiyat yaklaşıyor`, sub: `${s.shipment_number} · ${s.species || "Ürün"}`, days: d }); } });
    tasks.forEach((t) => { if (t.due_at) { const d = dayDiff(t.due_at); if (d >= 0 && d <= 7) r.push({ k: "t" + t.id, title: t.title, sub: t.description || "Görev", days: d }); } });
    return r.sort((a, b) => a.days - b.days).slice(0, 3);
  }, [ships, tasks]);

  const h = now.getHours(), hello = h < 12 ? "Günaydın" : h < 18 ? "İyi günler" : "İyi akşamlar";
  const Wx = !wx ? Sun : wx.c === 0 ? Sun : wx.c <= 3 ? Cloud : CloudRain;
  const dn = (x: number | null) => (x ? <span className="af-delta">↑ +{x}</span> : null);

  return (
    <AppShell active="Dashboard" name={name} alerts={reminders.length}>
      <section className="af-hero">
        <div><h1>{hello}, <em>{name || "Merhaba"}</em> 👋</h1><p>Yeni bir operasyon gününe hazır mısın?</p></div>
        <div className="af-hmeta">
          <span><Wx size={26} /> <b>Muğla</b>{wx && <small>{wx.t}°C</small>}</span><i />
          <span><CalendarDays size={26} /> <b>{now.toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" })}</b><small>{now.toLocaleDateString("tr-TR", { weekday: "long" })}, {hm(now)}</small></span>
        </div>
      </section>
      <div className="af-body">
        <div className="af-actions">
          <Link href="/shipments" className="pri"><Plus size={18} /> Yeni Sevkiyat</Link>
          <Link href="/documents/drafts"><FilePlus2 size={18} /> Proforma Oluştur</Link>
          <Link href="/documents"><CloudUpload size={18} /> Evrak Ekle</Link>
          <Link href="/tasks"><CalendarPlus size={18} /> Toplantı Planla</Link>
          <Link href="/tasks"><ClipboardCheck size={18} /> Görev Oluştur</Link>
        </div>
        {err && <div className="af-err"><b>Veri yüklenemedi:</b> {err}</div>}
        {loading ? <div className="af-card af-empty">Veriler yükleniyor…</div> : <>
          <div className="af-kpis">
            <K cls="g" Icon={Users} t="Müşteriler" v={m.cust} n="Aktif müşteri" x={dn(m.custNew)} />
            <K cls="b" Icon={Package} t="Açık Sipariş" v={m.ord} n="Takipte olan siparişler" x={dn(m.ordNew)} />
            <K cls="s" Icon={Ship} t="Bu Ay Sevkiyat" v={m.shipN} n={m.shipQty ? m.shipQty.toLocaleString("tr-TR") + " adet" : "Planlanan sevkiyatlar"} />
            <K cls="o" Icon={ClipboardCheck} t="Açık Görev" v={m.tasks} n="Takip gerektiren işler" />
            <K cls="p" Icon={FileCheck2} t="Belge Arşivi" v={m.docs} n="Arşiv kayıtları" />
          </div>
          <div className="af-cols">
            <section className="af-card">
              <div className="af-ch"><h2><Ship size={22} /> Yaklaşan Sevkiyatlar</h2><Link href="/shipments" className="af-btn">Tüm Sevkiyatlar →</Link></div>
              {ships.length === 0 ? <div className="af-empty">Yaklaşan sevkiyat yok. <Link href="/shipments">İlk sevkiyatı ekle</Link></div> :
                <div className="af-tw"><table><thead><tr><th>Müşteri</th><th>Ürün / Miktar</th><th>Planlanan Tarih</th><th>Durum</th><th>İlerleme</th></tr></thead><tbody>
                  {ships.map((s) => { const c = cu(s), nm = c?.company_name || "Müşteri", [lbl, pc] = ST[s.status] || [s.status, 0];
                    return <tr key={s.id}>
                      <td><div className="af-cust"><span className="af-logo2" style={{ background: colorOf(nm) }}>{nm.slice(0, 2).toUpperCase()}</span><b>{nm}</b></div></td>
                      <td><div className="af-prod"><Fish size={30} /><div><b>{s.species || "Ürün"}</b><small>{s.quantity?.toLocaleString("tr-TR") || "—"} {s.unit}</small></div></div></td>
                      <td><span className="af-date"><CalendarDays size={14} /> {s.planned_date ? new Date(s.planned_date + "T12:00:00").toLocaleDateString("tr-TR", { day: "numeric", month: "short", year: "numeric" }) : "—"}</span></td>
                      <td><span className={"af-chip st-" + s.status}>{lbl}</span></td>
                      <td><div className="af-prog"><div><span style={{ width: pc + "%" }} /></div><b>%{pc}</b></div></td>
                    </tr>; })}
                </tbody></table></div>}
            </section>
            <section className="af-card"><Agenda tasks={tasks} onDone={complete} /></section>
          </div>
          <div className="af-cols low">
            <section className="af-card">
              <div className="af-ch"><h2><Pulse size={20} /> Son Aktiviteler</h2><Link href="/reports" className="af-btn">Tümü →</Link></div>
              {logs.length ? logs.map((l) => <div className="af-act" key={l.id}><i /><span className="af-ai"><FileText size={18} /></span><div><b>{ENT[l.entity_type] || l.entity_type} {ACT[l.action] || l.action}</b>{ref(l.details) && <small>{ref(l.details)}</small>}</div><time>{hm(new Date(l.created_at))}</time></div>) : <div className="af-empty">Henüz aktivite kaydı yok.</div>}
            </section>
            <section className="af-card">
              <div className="af-ch"><h2><Bell size={20} /> Hatırlatmalar</h2></div>
              {reminders.length ? reminders.map((r) => <div className={"af-rem" + (r.days <= 2 ? " hot" : "")} key={r.k}><FileText size={20} /><div><b>{r.title}</b><small>{r.sub}</small></div><span>{r.days === 0 ? "Bugün" : r.days + " gün kaldı"}</span></div>) : <div className="af-empty">Önümüzdeki 7 gün için hatırlatma yok.</div>}
            </section>
          </div>
        </>}
      </div>
    </AppShell>
  );
}

function K({ cls, Icon, t, v, n, x }: { cls: string; Icon: LucideIcon; t: string; v: number; n: string; x?: ReactNode }) {
  return <div className={"af-k " + cls}><span className="af-ki"><Icon size={26} /></span><div><label>{t}</label><div className="af-kv"><strong>{v.toLocaleString("tr-TR")}</strong>{x}</div><small>{n}</small></div></div>;
}

function Agenda({ tasks, onDone }: { tasks: Task[]; onDone: (id: string) => void }) {
  const [cur, setCur] = useState(new Date()), [sel, setSel] = useState(new Date());
  const ent = tasks.filter((t) => t.due_at).map((t) => ({ ...t, d: new Date(t.due_at!) }));
  const cnt: Record<string, number> = {}; ent.forEach((e) => { cnt[ymd(e.d)] = (cnt[ymd(e.d)] || 0) + 1; });
  const days = new Date(cur.getFullYear(), cur.getMonth() + 1, 0).getDate(), off = (new Date(cur.getFullYear(), cur.getMonth(), 1).getDay() + 6) % 7;
  const list = ent.filter((e) => ymd(e.d) === ymd(sel)).sort((a, b) => a.d.getTime() - b.d.getTime()), isToday = ymd(sel) === ymd(new Date());
  const go = (n: number) => setCur(new Date(cur.getFullYear(), cur.getMonth() + n, 1));
  return <>
    <div className="af-ch"><h2><CalendarDays size={22} /> Ajanda / Takvim</h2><div className="af-seg"><button className="on">Gün</button><Link href="/tasks">Hafta</Link><Link href="/tasks">Ay</Link></div></div>
    <div className="af-calh"><button onClick={() => go(-1)} aria-label="Önceki ay"><ChevronLeft size={18} /></button><b>{cur.toLocaleDateString("tr-TR", { month: "long", year: "numeric" })}</b><button onClick={() => go(1)} aria-label="Sonraki ay"><ChevronRight size={18} /></button></div>
    <div className="af-cal">
      {["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"].map((w) => <div className="wd" key={w}>{w}</div>)}
      {Array.from({ length: off }, (_, i) => <div key={"e" + i} />)}
      {Array.from({ length: days }, (_, i) => { const d = new Date(cur.getFullYear(), cur.getMonth(), i + 1), k = ymd(d), n = Math.min(cnt[k] || 0, 3);
        return <button key={i} onClick={() => setSel(d)} className={"day" + (k === ymd(new Date()) ? " today" : "") + (k === ymd(sel) ? " sel" : "")}>{i + 1}<span className="dots">{Array.from({ length: n }, (_, j) => <i key={j} className={j ? "a" : "g"} />)}</span></button>; })}
    </div>
    <h3 className="af-plan">{isToday ? "Bugünün Planı" : sel.toLocaleDateString("tr-TR", { day: "numeric", month: "long" }) + " Planı"} <small>({sel.toLocaleDateString("tr-TR", { day: "numeric", month: "long", weekday: "long" })})</small></h3>
    {list.length ? list.map((e) => <div className="af-pi" key={e.id}><time>{hm(e.d)}</time><span className="af-pic">{e.event_type === "meeting" ? <Users size={20} /> : <FileText size={20} />}</span><div><b>{e.title}</b><small>{e.description || "Plan / görev"}</small></div><button onClick={() => onDone(e.id)} aria-label="Tamamlandı"><Check size={16} /></button></div>) : <div className="af-empty">Bu tarihte kayıtlı plan yok.</div>}
    <Link href="/tasks" className="af-add"><Plus size={18} /> Yeni Plan / Görev</Link>
  </>;
}
