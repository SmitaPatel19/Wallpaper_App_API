# 📱 Wallpaper App

A sleek and modern Flutter application that brings you stunning high-quality wallpapers from the Pexels API. Browse, view, and set wallpapers effortlessly!

---

## ✨ Features

**Explore Beautiful Wallpapers** – Browse a curated collection of high-resolution wallpapers.
**Infinite Scrolling** – Enjoy seamless scrolling with automatic image loading.
**Fullscreen View** – Tap to zoom in and admire wallpapers in full detail.
**Set as Wallpaper** – Apply wallpapers directly to your home screen.
**Attribution Display** – See the photographer’s name for each wallpaper.
**Smooth & Responsive UI** – A modern and polished user experience for all screen sizes.

---

## Installation Guide

1️. **Clone the repository**
```bash
   git clone https://github.com/yourusername/wallpaper-app.git
```

2️. **Navigate to the project folder**
```bash
   cd wallpaper-app
```

3️. **Install dependencies**
```bash
   flutter pub get
```

4️. **Run the application**
```bash
   flutter run
```

---

## 🔗 API Key Setup

This app fetches wallpapers from the **Pexels API**. To get started:

1️. **Sign up** at [Pexels API](https://www.pexels.com/api/) to obtain your API key.
2️. **Replace the API key** in `api_service.dart`:
   ```dart
   headers: {
     'Authorization': 'YOUR_API_KEY_HERE',
   },
   ```

---

## 📂 Project Structure

```
lib/
├── screen/
│   ├── wallpaper_page.dart  # Main wallpaper browsing screen
│   └── fullscreen_page.dart # Fullscreen wallpaper view
└── main.dart               # Main application entry
```

---

## 📸 App Screens

### 🌍 Wallpaper Browser
- Grid layout of wallpapers
- Infinite scroll loading
- Dynamic app bar that hides on scroll
### 🔍 Fullscreen View
- Interactive zoomable image
- Set wallpaper functionality
- Photographer information

---

## 🤝 Contributing

We welcome contributions! If you’d like to improve the app, feel free to **open an issue** or **submit a pull request**.

---

Happy Coding! 💙

