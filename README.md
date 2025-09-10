# 🚗 Vehicle Rental App

**Vehicle Rental App** is a comprehensive full-stack application designed for users to register, search for, and book various types of vehicles (motorbikes, cars, etc.). Users can also become hosts and list their own vehicles for rent.

---

## 📱 Project Overview

Features include:

* 🔍 Search and browse vehicles
* 📝 Register as a user or host
* 🗖️ Book and manage reservations
* 📊 View rental and transaction history
* 📍 Discover vehicles via map
* 💳 MoMo integration for secure payments

---

## 🛠️ Tech Stack

### Backend:

* Node.js
* Express
* MongoDB (Mongoose)

### Frontend:

* Flutter
* Dart

### Dev & Cloud:

* Docker, Docker Compose
* Postman
* Git, GitHub, GitHub Actions
* Google Cloud Console (OAuth)
* Cloudinary (image uploads)

---

## 🏗️ Architecture Overview

### 📲 Frontend – MVVM

* **Model**: API data models
* **View**: UI components
* **ViewModel**: Logic & state management

### 👥 Backend – MVC

* **Model**: Mongoose schemas
* **Controller**: Business logic
* **Routes**: RESTful APIs

---

## 🔌 API & Integrations

* RESTful API with Express
* Google OAuth for authentication
* Cloudinary for image hosting
* Postman for testing
* JSON format for data exchange

---

## 🐳 Dockerized Deployment

* `backend`, `frontend`, `mongodb` containers
* Managed via Docker Compose
* Fully isolated and portable environment

---

## 🔄 CI/CD Pipeline

* Git & GitHub for version control
* GitHub Actions for automated build/test/deploy

---

## 📋 Core Features

* 👤 User registration & login
* 🏠 Host your own vehicles
* 🔍 Smart filters: type, location, availability
* 🗕️ Reservation system
* 💰 MoMo-based payment support
* 📍 Map integration
* 📱 Mobile responsive UI

---

## 📁 Project Structure

```
vehicle-rental-app/
│
├── backend/                      
│   ├── controllers/             
│   ├── models/                  
│   ├── routes/                  
│   ├── middlewares/            
│   ├── utils/                   
│   ├── config/                  
│   ├── services/                
│   ├── app.js                   
│   └── server.js                
│
├── frontend/                    
│   ├── lib/
│   │   ├── models/              
│   │   ├── views/               
│   │   ├── viewmodels/          
│   │   ├── services/            
│   │   ├── utils/               
│   │   ├── routes/              
│   │   └── main.dart            
│   └── pubspec.yaml             
│
├── docker/                      
│   ├── backend.Dockerfile       
│   ├── frontend.Dockerfile      
│   └── docker-compose.yml       
│
├── mongodb/                     
│   └── init-db.js               
│
└── .github/                     
    └── workflows/              
        └── ci-cd.yml
```

---

## 🚀 Installation & Setup

### Prerequisites

* Node.js (v16+)
* Flutter SDK (v3+)
* Docker + Docker Compose
* MongoDB (local/cloud)
* Google Cloud Console & Cloudinary accounts

### 🔧 Backend Setup

```bash
cd backend
npm install
cp .env.example .env # fill in your env variables
npm run dev
```

### 📱 Frontend Setup

```bash
cd frontend
flutter pub get
# create .env file with:
# API_BASE_URL=http://localhost:5000
# GOOGLE_CLIENT_ID=your_google_client_id
flutter run
```

### 🐳 Docker Setup

```bash
docker-compose up --build
```

* Backend: [http://localhost:5000](http://localhost:5000)
* Flutter: Access via emulator or device

### 🧰 API Testing

* Import `postman_collection.json` from `backend/`
* Set `API_BASE_URL` in Postman

---

## 🔐 Environment Variables

Example `.env` for backend:

```env
PORT=5000
NODE_ENV=development
SESSION_SECRET=your_secret
MONGO_URI=mongodb://localhost:27017/vehicle-rental-db

JWT_SECRET=your_jwt
JWT_REFRESH_SECRET=your_refresh_secret
ACCESS_TOKEN_EXPIRES=15m
REFRESH_TOKEN_EXPIRES=7d

EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password

CLOUDINARY_CLOUD_NAME=your_cloud
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret

GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_API_KEY=your_api_key
CALLBACK_URL=http://localhost:5000/api/auth/google/callback

MOMO_PARTNER_CODE=MOMO
MOMO_ACCESS_KEY=F8BBA842ECF85
MOMO_SECRET_KEY=K951B6PE1waDMi640xX08PD3vg6EkVlz
MOMO_REDIRECT_URL=vehiclerental://payment-success
MOMO_IPN_URL=https://your-domain.com/api/payment/momo/ipn
```

---

## 🛡️ Notes & Recommendations

* ❌ Never commit `.env` files (add to `.gitignore`)
* ✅ Use separate secrets for development & production
* 🔐 Store secrets with tools like Vault, dotenv-safe, etc.
* 🌐 Use HTTPS in production
* 🗲️ For MoMo, replace test keys with your real credentials when going live

---

## 📄 License

Released under the **MIT License** – see [LICENSE](./LICENSE) for details.

---

## 📬 Contact

For feedback or questions, connect via [GitHub](https://github.com/your-username) or email.
