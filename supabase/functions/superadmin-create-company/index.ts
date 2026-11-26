import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
const usernameEmail=(u:string)=>u.trim().toLowerCase()+"@users.aquaflow.local";
const json=(body:Record<string,unknown>,status=200)=>new Response(JSON.stringify(body),{status,headers:{...corsHeaders,"Content-Type":"application/json"}});
Deno.serve(async(req)=>{
 if(req.method==="OPTIONS")return new Response("ok",{headers:corsHeaders});
 let stage="startup",createdUserId:string|null=null,companyId:string|null=null;
 try{
  stage="environment";const url=Deno.env.get("SUPABASE_URL"),anon=Deno.env.get("SUPABASE_ANON_KEY"),service=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if(!url||!anon||!service)return json({error:"Edge Function environment configuration missing",stage},500);
  stage="caller-auth";const auth=req.headers.get("Authorization")||"";const caller=createClient(url,anon,{global:{headers:{Authorization:auth}}});
  const {data:{user},error:ae}=await caller.auth.getUser();if(ae||!user)return json({error:"Unauthorized",stage},401);
  stage="role-check";const {data:profile,error:roleErr}=await caller.from("profiles").select("role").eq("id",user.id).single();if(roleErr||profile?.role!=="super_admin")return json({error:"Super-admin only",stage},403);
  stage="input-validation";const {company_name,admin_full_name,email,username,password}=await req.json();const identity=email?.trim()||username?.trim();
  if(!company_name?.trim()||!admin_full_name?.trim()||!identity||password?.length<8)return json({error:"Şirket, yönetici adı, kullanıcı adı/e-posta ve en az 8 karakterli şifre gereklidir.",stage},400);
  const uname=email?null:username.trim().toLowerCase();if(uname&&!/^[a-z0-9._-]{3,32}$/.test(uname))return json({error:"Kullanıcı adı 3-32 karakter olmalı; harf, sayı, nokta, _ veya - kullanılabilir.",stage},400);
  stage="service-client";const admin=createClient(url,service);
  if(uname){stage="username-check";const {data:existing,error:existingErr}=await admin.from("profiles").select("id").ilike("username",uname).limit(1);if(existingErr)return json({error:existingErr.message,stage},500);if(existing?.length)return json({error:"Bu kullanıcı adı kullanılıyor.",stage},409);}
  stage="auth-create";const {data:created,error:ce}=await admin.auth.admin.createUser({email:email?.trim()||usernameEmail(uname),password,email_confirm:true});if(ce||!created.user)return json({error:ce?.message||"Account creation failed",stage},400);createdUserId=created.user.id;
  stage="company-insert";const {data:company,error:co}=await admin.from("companies").insert({name:company_name.trim()}).select("id").single();if(co||!company){stage="rollback-auth";const {error:cleanup}=await admin.auth.admin.deleteUser(createdUserId);return json({error:co?.message||"Company creation failed",stage,rollback_error:cleanup?.message||null},500);}companyId=company.id;
  stage="profile-insert";const {error:pe}=await admin.from("profiles").insert({id:createdUserId,company_id:companyId,full_name:admin_full_name.trim(),role:"company_admin",username:uname,must_change_password:true});
  if(pe){stage="rollback-company";const {error:companyCleanup}=await admin.from("companies").delete().eq("id",companyId);stage="rollback-auth";const {error:userCleanup}=await admin.auth.admin.deleteUser(createdUserId);return json({error:pe.message,stage,rollback_errors:[companyCleanup?.message,userCleanup?.message].filter(Boolean)},500);}
  console.info("superadmin-create-company completed",{caller_id:user.id,company_id:companyId,user_id:createdUserId});
  return json({company_id:companyId,user_id:createdUserId});
 }catch(e){console.error("superadmin-create-company failed",{stage,error:String(e),company_id:companyId,user_id:createdUserId});return json({error:String(e),stage},500);}
});