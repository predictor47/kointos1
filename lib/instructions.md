# 🧠 Copilot Instructions for the Kointoss App (Flutter + Amplify)

## 📦 Project Overview
Kointoss is a cross-platform crypto-centric Flutter app (Web + Android) using AWS Amplify as the backend. It includes multiple features like chat, sentiment tracking, user stats, article suggestions, and analytics — all powered by live APIs and LLMs.

This file defines the global development rules Copilot must follow when assisting with code generation, UI building, API integration, and layout improvements.

---

## ✅ Copilot's Role

You are responsible for helping finish this app **end-to-end**, not just specific components. This includes fixing unfinished code, removing mocks or placeholders, ensuring features are functional, and improving visual quality.

You must analyze the **existing codebase**, detect all **missing implementations**, and fill them in using real backend integrations and clean UI.

---

## 🔧 General Responsibilities

### 1. ✅ Complete Unfinished Features
- Look through all files for:
  - TODOs, mocks, unimplemented functions, broken UI logic
  - Incomplete screens or widgets
- Finish them based on surrounding code and project context
- Never leave stubs or placeholder code

### 2. 🔗 Implement or Fix Backend Integration
- Identify GraphQL queries/mutations declared in Amplify schema
- For each screen or feature that fetches/saves data:
  - Implement the real Amplify or REST API call
  - Handle loading, error, and success states in the UI
- Remove all mock data, temporary variables, and unused service logic

### 3. 🎨 Design Modern, Elegant UI (Web + Android)
- Ensure **every screen and widget** uses responsive layout
- Use:
  - `SafeArea`, `SingleChildScrollView`, `LayoutBuilder`
  - `ConstrainedBox`, `Align`, and `MediaQuery` for width limits
- Apply modern Material 3 UI styles:
  - Rounded corners, elevation, consistent padding
  - Reusable widgets for buttons, cards, inputs, layouts
- Make sure components scale well on:
  - Android (360–480px width)
  - Web (700–1200px width)

### 4. 🚫 Eliminate Mockups and Placeholder Content
- No fake data, hardcoded arrays, or random JSON stubs
- Every screen must either:
  - Use real backend logic
  - Show a proper loading/error/empty UI state

---

## 💡 Smart Behavior Rules

- Always infer purpose from context — don’t hardcode assumptions
- If a widget refers to something like “XP”, “Bot”, “Vote”, or “Insight”, use naming patterns and Amplify models to implement logic
- When backend or model structure is missing, propose a complete implementation
- If a feature seems present but unused, hook it into the rest of the app

---

## 🧪 Testing and Verification
- Simulate real user behavior when testing screens (chat, dashboard, vote, etc.)
- Validate all buttons, forms, and flows complete successfully
- Run the app on both platforms (Web + Android):
  - Fix layout overflows, full-width stretching, and missing responsiveness

---

## 📚 Optional Enhancements (Add if time allows)
- Add reusable widgets or helper components
- Animate loading and transitions (e.g., bot replies, voting)
- Dark mode via `ThemeMode.system`
- Visual feedback on XP changes or new insights
- Add developer-friendly logging

---

## ✅ Goal
Make Kointoss a production-grade Flutter app with:
- Zero unfinished code
- All backend APIs fully integrated
- Responsive and modern UI across Android and Web
- Maintainable, readable, and reusable code structure
