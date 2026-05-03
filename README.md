<div align="center">
  <img src="https://images.unsplash.com/photo-1592982537447-6f23f8510a0e?q=80&w=1200&auto=format&fit=crop" alt="AgroLink Banner" width="100%" style="border-radius:12px; margin-bottom:20px;">
  
  <h1>🌾 AgroLink</h1>
  <p><strong>A Mobile-Based Supply Chain Management System for Smallholder Farmers</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Hive_NoSQL-FFCA28?style=for-the-badge&logo=databricks&logoColor=black" alt="Hive" />
  </p>
</div>

---

## 📖 About The Project

**AgroLink** is a university prototype built to digitize and streamline the agricultural supply chain for smallholder farmers in **Amuro District, Northern Uganda**. 

The application directly connects farmers, buyers, and transporters on a single, unified mobile platform. By acting as a digital bridge, AgroLink eliminates exploitative middlemen, reduces post-harvest losses, and ensures faster, more transparent payments.

### ⚠️ The Problem
Smallholder farmers currently face several critical challenges:
- Dependency on middlemen who offer unfairly low farm-gate prices.
- No access to real-time market price information.
- Up to 30% of fruits and vegetables are lost to post-harvest spoilage.
- Delayed and unreliable payments.
- Poorly coordinated logistics and pickups.

### 💡 The Solution
AgroLink solves this by giving farmers direct market access, giving buyers a transparent catalog of fresh produce, and giving transporters a clear pipeline of deliveries—all synchronized seamlessly.

---

## 👥 User Roles & Features

The app features three distinct user roles, each with its own tailored dashboard and workflows:

### 🧑‍🌾 1. Farmer
- **Register/Login:** Secure phone and password authentication.
- **List Produce:** Add available crops including quantity, unit, price, and descriptions.
- **Manage Inventory:** View and update all listed produce.
- **Handle Orders:** Receive, confirm, or cancel incoming order requests from buyers.
- **Track Logistics:** Monitor the pickup and delivery status of confirmed orders.

### 🛒 2. Buyer
- **Browse Produce:** Explore an open catalog of all available produce listed by local farmers.
- **Place Orders:** Select quantities and lock in transparent pricing.
- **Track Orders:** Monitor the status of orders (Pending → Confirmed → Picked Up → Delivered).
- **Payments:** Record payment methods used (MTN MoMo, Airtel Money, Cash).

### 🚚 3. Transporter
- **Available Pickups:** View all confirmed orders that are waiting to be picked up.
- **Update Logistics:** Update delivery statuses from Awaiting → In Transit → Delivered.
- **Delivery History:** View a log of all completed deliveries.

---

## 🛠 Tech Stack & Architecture

This project is built strictly as a localized prototype to demonstrate the core logic. 
- **Framework:** Flutter (Dart)
- **Local Storage:** Hive (NoSQL local database)
- **Code Generation:** `hive_generator` & `build_runner` for robust TypeAdapters.
- **Offline First:** No Firebase, No REST APIs, No internet required. All data models (Users, Produce, Orders, Payments, Logistics) live on the device using isolated Hive boxes.

---

## 📱 Screenshots

*(Add screenshots of your beautiful deep green `#2E7D32` and amber `#FFA000` UI here!)*

<div align="center">
  <img src="https://placehold.co/250x500/2E7D32/FFFFFF?text=Farmer+Dashboard" width="200" style="margin: 10px;">
  <img src="https://placehold.co/250x500/2E7D32/FFFFFF?text=Browse+Produce" width="200" style="margin: 10px;">
  <img src="https://placehold.co/250x500/2E7D32/FFFFFF?text=Order+Tracking" width="200" style="margin: 10px;">
</div>

---

## 🚀 Getting Started

To run this project locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/katosamuelraymond/agrolink.git
   ```
2. **Navigate to the directory:**
   ```bash
   cd agrolink
   ```
3. **Get Flutter dependencies:**
   ```bash
   flutter pub get
   ```
4. **Generate Hive TypeAdapters (if modifying models):**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
5. **Run the app:**
   ```bash
   flutter run
   ```

---
<div align="center">
  <p>Built with ❤️ for Makerere University Business School.</p>
</div>
