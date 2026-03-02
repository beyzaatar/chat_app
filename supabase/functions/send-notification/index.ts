import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FCM_PROJECT_ID = Deno.env.get("FCM_PROJECT_ID")!;
const FCM_CLIENT_EMAIL = Deno.env.get("FCM_CLIENT_EMAIL")!;
const FCM_PRIVATE_KEY = Deno.env.get("FCM_PRIVATE_KEY")!.replace(/\\n/g, "\n");

// JWT oluştur (FCM V1 için gerekli)
async function getAccessToken(): Promise<string> {
  const header = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: FCM_CLIENT_EMAIL,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const encode = (obj: object) =>
    btoa(JSON.stringify(obj))
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=/g, "");

  const signingInput = `${encode(header)}.${encode(payload)}`;

  const pemContents = FCM_PRIVATE_KEY
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");

  const binaryDer = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));

  const privateKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryDer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    privateKey,
    new TextEncoder().encode(signingInput)
  );

  const jwt = `${signingInput}.${btoa(
    String.fromCharCode(...new Uint8Array(signature))
  ).replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "")}`;

  // JWT ile access token al
  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  const tokenData = await tokenResponse.json();
  return tokenData.access_token;
}

serve(async (req) => {
  try {
    const { record } = await req.json();

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // Konuşmayı bul
    const { data: conversation } = await supabase
      .from("conversations")
      .select("participant_1, participant_2")
      .eq("id", record.conversation_id)
      .single();

    if (!conversation) {
      return new Response("Conversation not found", { status: 404 });
    }

    // Alıcıyı belirle
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

    if (!tokenData) {
      return new Response("Token not found", { status: 404 });
    }

    // Gönderen profili al
    const { data: senderProfile } = await supabase
      .from("profiles")
      .select("full_name")
      .eq("id", record.sender_id)
      .single();

    // Access token al
    const accessToken = await getAccessToken();

    // FCM V1 API ile bildirim gönder
    const fcmResponse = await fetch(
      `https://fcm.googleapis.com/v1/projects/${FCM_PROJECT_ID}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: tokenData.token,
            notification: {
              title: senderProfile?.full_name ?? "Yeni Mesaj",
              body: record.content,
            },
            data: {
              conversationId: record.conversation_id,
              senderId: record.sender_id,
            },
            android: {
              notification: {
                sound: "default",
                priority: "HIGH",
              },
            },
            apns: {
              payload: {
                aps: {
                  sound: "default",
                },
              },
            },
          },
        }),
      }
    );

    const result = await fcmResponse.json();
    return new Response(JSON.stringify(result), { status: 200 });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
    });
  }
});