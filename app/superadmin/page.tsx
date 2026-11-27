import { redirect } from "next/navigation";

// Keep the legacy /superadmin URL but send it to the full platform-management panel.
export default function SuperAdminRedirect() {
  redirect("/admin/companies");
}
