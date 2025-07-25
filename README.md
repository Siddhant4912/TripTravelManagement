# 🌍 Trip Management App

A cross-platform **Trip Management App** built with **Flutter** (frontend), **PHP** (backend), and **MySQL** (database). This app allows users to manage their trips, post blogs, check real-time weather, and explore trips posted by others.

---

## ✨ Features

- 🔐 **User Authentication** – Register and log in securely
- 👤 **User Profile** – View and update your personal details
- 🧳 **Trip Management** – Create, view, edit, and delete your trips
- 🌦️ **Weather Checker** – Check real-time weather for your trip destination
- 📝 **Blog Section** – Create travel blogs and read others'
- 🌐 **Explore Others' Trips** – See trips shared by other users
- 📱 **Responsive UI** – Built with Flutter for Android/iOS

---


---

## ⚙️ Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Frontend     | Flutter            |
| Backend      | PHP (REST API)     |
| Database     | MySQL              |
| Weather API  | OpenWeatherMap or similar (optional) |

---

## 🛠️ How to Run

### 🖥️ Flutter Frontend


cd trip-management-app
flutter pub get
flutter run
🔧 Make sure to update API URLs in the Flutter code if you're using a local or live server.

🌐 PHP Backend
Place the backend/ folder in your local server root (e.g. htdocs/ for XAMPP).

Import the MySQL database using phpMyAdmin with the provided SQL file (e.g. trip_db.sql).

Configure database credentials in a config.php file.

// backend/config.php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "trip_db";
$conn = mysqli_connect($host, $user, $pass, $db);


📁 Folder Structure

trip-management-app/
├── lib/                # Flutter code
│   └── screens/        # Trip, blog, profile, etc.
├── backend/            # PHP APIs
│   ├── create_trip.php
│   ├── delete_trip.php
│   ├── weather_api.php
│   ├── blog_handler.php
│   └── user_profile.php
├── assets/             # App screenshots for GitHub
│   ├── dashboard.png
│   ├── create_trip.png
│   └── weather.png
├── README.md


🚀 Future Enhancements
✅ Push notifications for upcoming trips

✅ Google Maps integration

✅ Trip rating and review system

✅ Admin panel for blog moderation






