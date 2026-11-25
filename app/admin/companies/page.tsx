"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase";
import "./companies.css";

export default function PlatformCompanies() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [company, setCompany] = useState("");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  useEffect(() => {
    void check();
  }, []);

  async function check() {
    if (!supabase) {
      setError("Supabase yapılandırması eksik.");
      setLoading(false);
      return;
    }
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      window.location.assign("/login");
      return;
    }
    const { data: profile, error: profileError } = await supabase
      .from("profiles").select("role").eq("id", user.id).single();
    if (profileError || profile?.role !== "super_admin") {
      setError("Bu alan yalnızca platform super-admin hesabına açık.");
      setLoading(false);
      return;
    }
    setLoading(false);
  }

  async function submit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError("");
    setSuccess("");
    if (!supabase) return;
    const { data, error: invokeError } = await supabase.functions.invoke(
      "superadmin-create-company",
      { body: { company_name: company, admin_full_name: name, email, password } }
    );
    if (invokeError || data?.error) {
      setError(invokeError?.message || data?.error || "Şirket oluşturulamadı.");
      return;
    }
    setSuccess("Şirket ve yönetici hesabı başarıyla oluşturuldu. Yönetici ilk girişinde şifresini değiştirmelidir.");
    setCompany("");
    setName("");
    setEmail("");
    setPassword("");
  }

  async function logout() {
    await supabase?.auth.signOut();
    window.location.assign("/login");
  }

  return (
    <main className="wrap">
      <header>
        <div>
          <div className="brand">AquaFlow <span>PLATFORM</span></div>
          <h1>Super Admin</h1>
          <p>Şirketleri ve şirket yöneticilerini oluştur</p>
        </div>
        <button className="out" onClick={logout}>Çıkış</button>
      </header>
      {loading ? (
        <p>Yetki kontrol ediliyor…</p>
      ) : (
        <>
          {error && <div className="error">{error}</div>}
          <section>
            <h2>Yeni şirket oluştur</h2>
            <p>Bu işlem şirket kaydını ve ilk şirket yöneticisinin giriş hesabını birlikte oluşturur.</p>
            <form onSubmit={submit}>
              <label>Şirket adı
                <input required value={company} onChange={(e) => setCompany(e.target.value)} placeholder="ABC Dış Ticaret" />
              </label>
              <label>Yönetici adı soyadı
                <input required value={name} onChange={(e) => setName(e.target.value)} placeholder="Ahmet Yılmaz" />
              </label>
              <label>Yönetici e-posta
                <input required type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="ahmet@abc.com" />
              </label>
              <label>İlk şifre
                <input required type="password" minLength={8} value={password} onChange={(e) => setPassword(e.target.value)} placeholder="En az 8 karakter" />
              </label>
              <button className="primary" type="submit">Şirket ve yönetici hesabını oluştur</button>
            </form>
            {success && <div className="success">{success}</div>}
          </section>
          <section>
            <h2>Platform yönetimi</h2>
            <div className="info">
              <b>İlk sürüm</b>
              <p>Şirket oluşturma, ilk yönetici hesabı ve tenant bağlantısı bu ekran üzerinden yapılır. Çalışan hesapları şirket yöneticisinin kendi panelinden oluşturulabilir.</p>
            </div>
          </section>
        </>
      )}
    </main>
  );
}
