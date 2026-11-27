import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
const json=(body:Record<string,unknown>,status=200)=>new Response(JSON.stringify(body),{status,headers:{...corsHeaders,"Content-Type":"application/json"}});
Deno.serve(async(req)=>{
 if(req.method==="OPTIONS")return new Response("ok",{headers:corsHeaders});
 if(req.method!=="POST")return json({error:"Method not allowed"},405);
 try{
  const url=Deno.env.get("SUPABASE_URL"),anon=Deno.env.get("SUPABASE_ANON_KEY"),service=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if(!url||!anon||!service)return json({error:"Function environment configuration missing"},500);
  const auth=req.headers.get("Authorization")||"",caller=createClient(url,anon,{global:{headers:{Authorization:auth}}});
  const {data:{user},error:authError}=await caller.auth.getUser();if(authError||!user)return json({error:"Unauthorized"},401);
  const {data:role,error:roleError}=await caller.from("profiles").select("role").eq("id",user.id).single();
  if(roleError||role?.role!=="super_admin")return json({error:"Super-admin only"},403);
  const admin=createClient(url,service);
  const [companies,profiles]=await Promise.all([
   admin.from("companies").select("id,name,created_at").order("name"),
   admin.from("profiles").select("id,company_id,full_name,username,job_title,role").order("full_name")
  ]);
  if(companies.error)return json({error:"Companies query failed: "+companies.error.message},500);
  if(profiles.error)return json({error:"Profiles query failed: "+profiles.error.message},500);
  return json({companies:companies.data||[],people:profiles.data||[]});
 }catch(err){return json({error:String(err)},500);}
});