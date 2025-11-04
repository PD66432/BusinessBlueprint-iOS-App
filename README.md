# Business Blueprint - iOS App

A professional AI-powered iOS application that helps users discover personalized business ideas based on their skills, personality, and interests.

## Features

### 🤖 AI-Powered Business Generation
- Google AI Studio integration for intelligent business idea generation
- Personalized recommendations based on user profile
- Real-time AI suggestions for next steps

### 📊 Dashboard & Analytics
- Real-time progress tracking with visual charts
- Daily goals management
- Milestone tracking with timelines
- Completion statistics and analytics graphs

### 🎯 Smart Onboarding
- Interactive quiz flow
- Skills, personality traits, and interests selection
- Personalized business idea recommendations

### 💼 Business Ideas Management
- Detailed business idea cards
- Revenue estimates and startup costs
- Market demand and competition analysis
- Personalized notes and suggestions
- Save and track favorite ideas

### ⏱️ Goal & Milestone Tracking
- Create and manage daily goals
- Set project milestones
- Track completion progress
- Priority-based organization

### 👤 User Profile & Preferences
- Personalized user profiles
- Subscription tier management
- Profile analytics

### 💳 Subscription Management
- Free tier access
- Pro subscription ($9.99/month)
- Premium subscription ($19.99/month)
- Lifetime access option ($199.99)

## Tech Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Backend**: Firebase (Firestore + Authentication)
- **AI**: Google AI Studio (Gemini Pro)
- **iOS**: 16.0+

## APIs & Credentials

### Firebase Configuration
```
Project ID: studio-5837146656-10acf
Project Number: 1095936176351
Web API Key: AIzaSyD0yDZFbfJd68FOL2jPVbopg8UEUOd3tXQ
```

### Google AI Studio
```
API Key: AIzaSyDwtGElGSno15x83lQvgSvsaTIX98ca4A4
Model: Gemini Pro
```

## Project Structure

```
businessapp/
├── Config/
│   └── FirebaseConfig.swift
├── Models/
│   └── BusinessIdea.swift
├── Services/
│   ├── FirebaseService.swift
│   └── GoogleAIService.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── BusinessIdeaViewModel.swift
│   ├── QuizViewModel.swift
│   └── DashboardViewModel.swift
├── Views/
│   ├── LaunchView.swift
│   ├── AuthView.swift
│   ├── QuizView.swift
│   ├── BusinessIdeasView.swift
│   ├── DashboardView.swift
│   ├── ProfileView.swift
│   └── MainTabView.swift
└── businessappApp.swift
```

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/businessapp.git
   cd businessapp
   ```

2. **Install Dependencies**
   - Open `businessapp.xcodeproj` in Xcode
   - Navigate to File → Add Packages
   - Add Firebase SDK
   - Add any additional required packages

3. **Configure Firebase**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add to Xcode project
   - Ensure it's included in target

4. **Add API Keys**
   - Update `FirebaseConfig.swift` with your credentials
   - Alternatively, store in Keychain for production

5. **Build & Run**
   ```bash
   xcode: Cmd + R
   ```

## Key Views

### Launch Screen
- Beautiful onboarding with app branding
- Sign up and sign in options
- Feature highlights

### Quiz Flow
- 5-step interactive questionnaire
- Skills, personality, interests selection
- Personal information collection
- AI-powered idea generation

### Dashboard
- Progress overview with charts
- Daily goals management
- Milestone timeline visualization
- Completion statistics

### Business Ideas
- Personalized idea recommendations
- Detailed information cards
- Market analysis
- AI suggestions for next steps
- Save favorites feature

### Profile
- User statistics
- Subscription management
- Premium upgrade options
- Settings and preferences

## Color Scheme

- **Primary**: Deep Blue (`#0D1F5A`)
- **Accent**: Orange (`#FF9933`)
- **Secondary**: Yellow (`#FFD700`)
- **Background**: Dark gradient

## Design Principles

- ✨ Clean and modern UI
- 🎯 Intuitive navigation
- 📱 Mobile-first design
- 🎨 Professional aesthetics
- ♿ Accessibility focused

## Future Enhancements

- [ ] GitHub repository integration
- [ ] Real-time Firebase sync
- [ ] Push notifications
- [ ] Social sharing features
- [ ] Advanced analytics dashboard
- [ ] Business plan templates
- [ ] Funding recommendations
- [ ] Mentor matching system

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Author

Aadjot Singh Sidhu

## Support

For support, email support@businessblueprint.app or open an issue on GitHub.

---

**Business Blueprint** - Discover Your Perfect Business Idea 🚀
