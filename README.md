# 💬 Chat App

A full-featured real-time chat application built with Flutter, focusing on clean architecture and modern mobile development practices.

---

## ✨ Features

- 🔐 **Passwordless Authentication** — Secure OTP-based login via email, persistent session until manual logout
- 👤 **Profile Management** — One-time profile setup on first login, viewable and editable anytime
- 💬 **Real-time Messaging** — One-on-one conversations stored and synced via Supabase
- 📞 **Voice & Video Calls** — Peer-to-peer calls powered by LiveKit with call history
- 🔍 **User Search** — Find and connect with other users
- ⚙️ **Settings** — App preferences and account management

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Riverpod / Bloc |
| Backend & Database | Supabase |
| Real-time Communication | LiveKit |
| Architecture | Clean Architecture |
| Auth | Supabase OTP (Email) |

---

## 📁 Architecture

The project follows **Clean Architecture** principles with a feature-based folder structure.
```
lib/
├── core/
├── features/
│   ├── auth/
│   ├── chat/
│   ├── call/
│   ├── profile/
│   └── settings/
```

---

## 🚀 Getting Started
```bash
git clone https://github.com/beyzaatar/[repo-name]
cd [repo-name]
flutter pub get
flutter run
```

> ⚠️ You'll need to set up your own Supabase project and LiveKit server. Add your credentials to the `.env` file.

---

## 📸 Screenshots

*Coming soon*