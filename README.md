# TechSprint-Flutter
Flutter App module
Perfect — here is a professional, copy-paste ready README.md you can put in your GitHub repo so your friend can clone, setup, and run without confusion.

This README matches exactly the Flutter + Firebase + Gemini project we discussed.

⸻

📄 README.md

# FindIt AI – Lost & Found Module

FindIt AI is an AI-powered Lost & Found module for campus and community use.  
It uses Google Gemini for semantic matching and Firebase for real-time storage.

---

## ✨ Features

- Google Authentication
- Post Lost / Found items
- Public Lost & Found feed
- AI semantic matching using Gemini
- Match confidence & reasoning
- Contact owner via email
- Owner-only delete & resolve
- Material UI Flutter design

---

## 🛠 Tech Stack

- Flutter
- Firebase Authentication
- Firestore Database
- Google Gemini API
- HTTP REST API

---

## 📁 Project Setup

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/findit_ai_flutter.git
cd findit_ai_flutter


⸻

2️⃣ Install Dependencies

Open pubspec.yaml in root folder and make sure this exists:

dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^2.27.0
  firebase_auth: ^4.17.0
  cloud_firestore: ^4.15.0
  google_sign_in: ^6.2.1
  http: ^1.2.0
  url_launcher: ^6.2.5

Then run:

flutter pub get


⸻

3️⃣ Firebase Setup
	1.	Go to Firebase Console
	2.	Create a project
	3.	Enable:
	•	Authentication → Google Sign-in
	•	Firestore Database
	4.	Add Android/iOS app to Firebase project
	5.	Download:
	•	google-services.json → put in android/app/
	•	GoogleService-Info.plist → put in ios/Runner/

⸻

4️⃣ Firestore Collections

Create two collections:

items

{
  "type": "lost",
  "title": "Black Wallet",
  "description": "Leather wallet with ID",
  "location": "Library",
  "email": "user@gmail.com",
  "ownerId": "UID123",
  "active": true,
  "createdAt": "timestamp"
}

matches

{
  "itemA": "id1",
  "itemB": "id2",
  "score": 0.87,
  "confidence": "high",
  "reason": "Both describe black wallet",
  "createdAt": "timestamp"
}


⸻

5️⃣ Gemini API Key Setup

Open:

lib/gemini_service.dart

Replace:

const GEMINI_KEY = "YOUR_API_KEY";

with your real Gemini API key.

⸻

6️⃣ Run the App

flutter run


⸻

📱 App Flow
	1.	Google Login
	2.	View Lost / Found items
	3.	Create new post
	4.	AI finds semantic matches
	5.	View match confidence
	6.	Contact owner by email

⸻

🧠 AI Matching Logic

We use Google Gemini to compare two descriptions semantically and return:

{
  "similarity_score": 0.0 - 1.0,
  "confidence": "high | medium | low",
  "reasoning": "short explanation"
}


⸻

🔐 Firestore Rules (Recommended)

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /items/{itemId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        request.auth.uid == resource.data.ownerId;
    }

    match /matches/{matchId} {
      allow read: if true;
      allow write: if false;
    }
  }
}


⸻

🚀 Future Enhancements
	•	Image-based matching
	•	Location-based weighting
	•	Multilingual support
	•	Admin dashboard
	•	Notification system

⸻

📄 License

This project is for hackathon and educational purposes.

⸻

👨‍💻 Team
	•	AI Lead: You
	•	Flutter Developer
	•	Backend Developer

⸻

🏆 Hackathon Note

This module demonstrates real-world AI usage with Google technologies in a scalable, zero-cost architecture.

⸻


---

# 📌 WHERE TO ADD THIS FILE

Create a file in root folder:

findit_ai_flutter/README.md

Paste the above content and commit to GitHub.

---

# 📌 AFTER ADDING README

Your friend will:

1. Clone repo
2. Follow README
3. App will run without asking you questions 😄

---

# 🔥 NEXT IF YOU WANT

I can now give:

- GitHub commit message sequence  
- Firestore index setup  
- Firebase Android config steps  
- iOS Firebase config steps  
- Pitch script based on README  

Just tell me what you want next.