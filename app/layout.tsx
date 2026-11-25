import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "AquaFlow | Operasyon Yönetimi", description: "Satış, sevkiyat ve finans operasyon platformu" };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="tr"><body>{children}</body></html>; }
