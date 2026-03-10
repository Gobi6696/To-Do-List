# 🚀 ProTasker - Advanced To-Do Application

A modern, robust, and feature-rich To-Do List application built with **Flutter** and **Firebase**. Designed with a focus on clean architecture, seamless user experience, and scalability. This project demonstrates proficiency in standard industry practices like State Management, MVC Architecture, and Realtime Cloud Database Integration.

---

## ✨ Key Features

### 🔐 Authentication & Security
- **Email & Password Authentication**: Secure traditional login/signup flows.
- **Google Sign-In integration**: Fast, one-tap social authentication.
- **User Profile Management**: Editable user profiles including Mobile Number validation and persistent storage.

### 📝 Task Management
- **CRUD Operations**: Create, Read, Update, and Delete tasks efficiently.
- **Real-time Sync**: Powered by **Firebase Realtime Database**, ensuring tasks stay completely synchronized across all active sessions instantly.
- **Status Tracking**: Mark tasks as "Completed", "In Progress", or "Pending".

### 🔍 Search & Filtering
- **Advanced Filtering**: Instantly filter tasks by their current status.
- **Real-time Search**: Search functionality by querying the title or description dynamically.

### 🎨 UI & UX Design
- **Responsive Architecture**: Adapts seamlessly.
- **Modern Clean UI**: Using customized components (Glassmorphism, beautiful Color Palettes via custom `AppTheme`).
- **Interactive Micro-animations**: State-driven UI updates, animated transitions between screens, and beautiful pop-up dialogues.
- **Customized Splash Screen**: Ensuring an engaging entry point for the user.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/)
- **Architecture**: Model-View-Controller (MVC) - ensuring clear separation of logic, state, and UI.
- **State Management**: [Provider](https://pub.dev/packages/provider) - robust and scalable state propagation efficiently managing Auth & Task controllers.
- **Backend Service (BaaS)**: [Firebase](https://firebase.google.com/)
  - **Firebase Authentication** (Users Collection)
  - **Firebase Realtime Database** (Tasks Collection - to separate logic explicitly from user profiles)

---

## 🏗️ Project Structure

The project strictly follows the **MVC (Model-View-Controller)** pattern for high maintainability:

```text
lib/
 ├── models/         # Represents the data layer (e.g., TaskModel, UserModel)
 ├── views/          # The UI layer (Screens, Widgets, and layout)
 │    ├── auth/      # Login, Signup
 │    └── dashboard/ # Dashboard, Task Details, Profile, Add Task
 ├── controllers/    # Business logic and State Management (AuthController, TaskController)
 ├── core/           # Core configurations (Theme, Constants)
 └── main.dart       # Application entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`>=3.0.0`)
- Dart SDK (`>=3.0.0`)
- A Firebase Project (with Authentication and Realtime Database enabled)

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/your-username/todo.git
   ```
2. Navigate to the directory
   ```bash
   cd todo
   ```
3. Install dependencies
   ```bash
   flutter pub get
   ```
4. Run the application
   ```bash
   flutter run
   ```

*(Note: Make sure your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly configured in your local environment for Firebase to connect successfully).*

---

## 📸 Screenshots & Previews

*(Consider adding preview screenshots/GIFs here to demonstrate the high-quality UI & functionality visually)*

---

## 🎯 Why This Project Stands Out

- **Scalability**: By utilizing `Provider` alongside MVC, the app is prepared for growing complexity without spaghetti code.
- **Separation of Concerns**: Clear structural division between data logic, network models, and the UI layer.
- **Data Integrity**: Using separated paths for "Users" and "Tasks" in Realtime Database showcases practical NoSQL architecture thinking.
- **Detail-Oriented**: Focus on granular details like `inputFormatters` for exact 10-digit mobile number constraints and custom dynamic theme mappings.

## 📄 License
This project is an open-source demonstration and is licensed under the MIT License.
