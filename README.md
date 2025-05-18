🚗 Mobile Vehicle Rental App 🚗
  Mobile Vehicle Rental App is an innovative solution designed to simplify vehicle rentals, offering users an effortless way to browse, book, and manage rentals for cars, motorcycles, and   electric bicycles. 
  This project is tailored for startups or businesses aiming to establish a seamless and scalable vehicle rental service.

📱 Project Overview
  The application enables users to:
  Browse and rent vehicles by type (cars, motorcycles, electric bicycles), location, and rental duration.
  Securely log in and authenticate via Firebase.
  Manage rental history and track reservations.
  With growing demand for convenient mobility solutions, this project provides a flexible and efficient platform for rental services.
  
🔧 Technologies Used

🖥 Backend:
  Node.js + Express – RESTful API development with scalability and maintainability.
  MongoDB – NoSQL database for flexible data storage.
  Firebase Authentication – Secure user authentication via Firebase (Email/Password, OTP).

📱 Frontend:
  Flutter + Dart – Cross-platform mobile application development for iOS and Android.
  
📐Figma – UI/UX design and prototyping.

🐳 Docker – Containerized deployment with Docker and Docker Compose for consistency across environments.

🏗️ Architecture Overview

📱 Frontend (Flutter) – MVVM Architecture
  The frontend follows the MVVM (Model-View-ViewModel) design pattern to separate UI components and business logic:
  Model: Represents data retrieved from the API or database.
  View: UI components (Flutter Widgets & Screens).
  ViewModel: Handles business logic, manages state, and connects View with Model.

🖥 Backend (Node.js + Express) – MVC Architecture
  The backend utilizes the MVC (Model-View-Controller) architecture for structured code organization:
  Model: MongoDB schemas defined with Mongoose.
  Controller: Business logic and interaction with Models.
  Routes (API View Layer): Defines RESTful endpoints returning JSON responses.

🔄 Communication Between Frontend & Backend:
  Protocol: RESTful API.
  Authentication: Firebase Auth (ID Token sent via Authorization header).
  Data Format: Standard JSON responses for seamless integration with Flutter.

🛠️ Docker – Simplified Deployment
  The entire system is containerized using Docker, ensuring fast and reliable deployment across various environments. With Docker Compose, the backend (Node.js), frontend (Flutter), and database (MongoDB) operate within isolated containers, minimizing configuration inconsistencies.

📌 Core Features
🔐 User authentication via Firebase (Email/Password, OTP)
🚘 Browse available vehicles with category, location, and time-based filters
📆 Manage rental history and reservations
💳 Online payment integration (planned future feature)
🧾 Transaction and booking history tracking
📍 Integrated maps for selecting pickup locations
🧩 Open-source architecture for easy expansion
