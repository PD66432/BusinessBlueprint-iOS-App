# 🔐 API Key Configuration Guide

## ⚠️ Important: Security Best Practices

**NEVER** commit API keys to version control. This project uses environment variables to keep your credentials secure.

---

## Setup Instructions

### 1. Google AI Studio API Key

1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Click "Create API Key"
3. Copy your API key

### 2. Firebase Web API Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** → **General** tab
4. Copy your **Web API Key**

---

## Configuration Methods

### Method 1: Xcode Build Settings (Recommended for Development)

1. Open `businessapp.xcodeproj` in Xcode
2. Select the **businessapp** target
3. Go to **Build Settings**
4. Search for "User-Defined Settings"
5. Add two new settings:
   - `GOOGLE_AI_API_KEY` = your_key_here
   - `FIREBASE_WEB_API_KEY` = your_key_here

### Method 2: Environment Variables

Set environment variables before running:

```bash
export GOOGLE_AI_API_KEY="your_google_ai_key"
export FIREBASE_WEB_API_KEY="your_firebase_key"
```

### Method 3: .env.local File (for local development)

1. Copy `.env.example` to `.env.local`
2. Fill in your actual API keys
3. **NEVER commit `.env.local`** (it's in `.gitignore`)

---

## Verification

After configuration, run:

```bash
xcodebuild -scheme businessapp -configuration Debug build
```

If you see this error: `❌ GOOGLE_AI_API_KEY not set`, your configuration is incorrect. Verify the steps above.

---

## Production Deployment

For production:

1. Use **Keychain** for secure credential storage
2. Use **Firebase Remote Config** for sensitive settings
3. Use **GitHub Secrets** for CI/CD pipelines
4. Never expose API keys in app bundles

See `Config/SecureConfig.swift` for production-ready Keychain integration.
