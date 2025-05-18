# 🚗 Mobile Vehicle Rental App

**Mobile Vehicle Rental App** is an innovative, cross-platform solution designed to streamline the vehicle rental process. It enables users to easily **browse, book, and manage rentals** for cars, motorcycles, and electric bicycles. This project is ideal for **startups or businesses** aiming to launch a **scalable and modern vehicle rental service**.

---

## 📱 Project Overview

The app provides:

- 🔍 Browsing and filtering vehicles by type, location, and rental duration  
- 🔐 Secure login and authentication using **Firebase Authentication** (Email/Password, OTP)  
- 📆 Viewing and managing **rental history** and **reservations**  
- 🗺️ Map integration for selecting pickup locations  
- 💳 (Planned) Integration with online payment services  

With increasing demand for smart mobility, this platform offers a **flexible, efficient**, and **user-friendly** rental experience.

---

## 🔧 Technologies Used

### 🖥 Backend:
- **Node.js + Express** – RESTful API development, scalable and maintainable
- **MongoDB** – NoSQL database for flexible data storage
- **Firebase Auth** – Secure authentication (Email/Password, OTP)

### 📱 Frontend:
- **Flutter + Dart** – Cross-platform mobile development (iOS & Android)

### Figma: 
- **UI/UX design and prototyping

### 🐳 Deployment:
- **Docker + Docker Compose** – Containerized deployment for consistent environments

---

## 🏗️ Architecture Overview

### 📲 Frontend – MVVM Architecture
The frontend is built using the **MVVM (Model-View-ViewModel)** design pattern:

- **Model**: Data retrieved from the API/backend
- **View**: UI screens and Flutter widgets
- **ViewModel**: Handles logic, state management, and communication between View and Model

### 🖥 Backend – MVC Architecture
The backend follows the **MVC (Model-View-Controller)** structure:

- **Model**: MongoDB schemas (via Mongoose)
- **Controller**: Business logic and data operations
- **Routes**: Defines RESTful API endpoints returning JSON

---

## 🔄 Frontend–Backend Communication

- **Protocol**: RESTful API over HTTPS  
- **Authentication**: Firebase ID Token passed via `Authorization` header  
- **Data Format**: JSON responses for easy parsing in Flutter  

---

## 🛠️ Docker – Simplified Deployment

The full system is containerized with **Docker**, making it easy to deploy across development and production environments. Using **Docker Compose**, the app runs as isolated services:

- `backend` – Node.js API server  
- `frontend` – Flutter app build (web or mobile preview)  
- `mongodb` – NoSQL database  

This setup ensures consistency, simplifies scaling, and reduces configuration errors.

---

## 📌 Core Features

- 🔐 Firebase-based user authentication (Email/Password, OTP)
- 🚘 Vehicle browsing with filters for type, location, and availability
- 📆 Rental history and active booking management
- 💳 Planned integration with payment gateways
- 🧾 Transaction and booking history
- 📍 Map support for pickup location selection
- 🧩 Clean, modular architecture – easy to scale and maintain

---
## 📁 Project Structure
  mobile-vehicle-rental-app/
  │
  ├── backend/                        # Backend built with Node.js + Express
  │   ├── controllers/               # Business logic handlers
  │   ├── models/                    # Mongoose schemas for MongoDB
  │   ├── routes/                    # API endpoint definitions
  │   ├── middlewares/               # Middlewares (auth, error handling, etc.)
  │   ├── utils/                     # Common utility functions
  │   ├── config/                    # Configuration files (DB, Firebase, env variables)
  │   ├── services/                  # Third-party integrations (Firebase, payment)
  │   ├── app.js                     # Express app initialization
  │   └── server.js                  # Backend entry point
  │
  ├── frontend/                      # Flutter mobile application
  │   ├── lib/
  │   │   ├── models/                # Data models
  │   │   ├── views/                 # UI screens and widgets
  │   │   ├── viewmodels/            # Logic and state management
  │   │   ├── services/              # API, Firebase, and Maps communication
  │   │   ├── utils/                 # Utility functions and constants
  │   │   ├── routes/                # Navigation between screens
  │   │   └── main.dart              # App entry point
  │   └── pubspec.yaml               # Flutter dependencies configuration
  │
  ├── docker/                        # Docker configuration files
  │   ├── backend.Dockerfile
  │   ├── frontend.Dockerfile
  │   └── docker-compose.yml
  │
  ├── mongodb/                       # MongoDB data (volume or initialization script)
  │   └── init-db.js
  │
  └── README.md                     # Project overview and introduction

## 📄 License

This project is released under the **MIT License**. See the [LICENSE](./LICENSE) file for more information.
