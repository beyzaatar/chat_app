import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY")!;

serve(async (req) => {
  const { record } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  // Konuşmayı bul, alıcıyı belirle
  const { data: conversation } = await supabase
    .from("conversations")
    .select("participant_1, participant_2")
    .eq("id", record.conversation_id)
    .single();

  if (!conversation) return new Response("Conversation not found", { status: 404 });

  // Alıcı gönderen değil
  const receiverId =
    conversation.participant_1 === record.sender_id
      ? conversation.participant_2
      : conversation.participant_1;

  // Alıcının FCM token'ını al
  const { data: tokenData } = await supabase
    .from("device_tokens")
    .select("token")
    .eq("user_id", receiverId)
    .single();

  if (!tokenData) return new Response("Token not found", { status: 404 });

  // Gönderen profili al
  const { data: senderProfile } = await supabase
    .from("profiles")
    .select("full_name")
    .eq("id", record.sender_id)
    .single();

  // FCM'e bildirim gönder
  const response = await fetch("https://fcm.googleapis.com/fcm/send", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `key=${FCM_SERVER_KEY}`,
    },
    body: JSON.stringify({
      to: tokenData.token,
      notification: {
        title: senderProfile?.full_name ?? "Yeni Mesaj",
        body: record.content,
        sound: "default",
      },
      data: {
        conversationId: record.conversation_id,
        senderId: record.sender_id,
      },
    }),
  });

  const result = await response.json();
  return new Response(JSON.stringify(result), { status: 200 });
});