<div align="center">

# ⏰ WakeBreaker · Web

**"No excuses." The landing site for WakeBreaker, the alarm app you can't snooze your way out of.**

![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Responsive](https://img.shields.io/badge/responsive-desktop%20→%20mobile-a78bfa?style=flat-square)

[The app](#-the-app) · [Pages](#-pages) · [Run it](#-run-it) · [Türkçe](#-türkçe)

</div>

---

## 📱 The app

WakeBreaker is an alarm app that only goes quiet once you're **really** awake:

| Feature | Idea |
|---|---|
| 👻 **Ghost Walk** | GPS and accelerometer check that you walked **15 metres**. Go back to bed and the counter resets. |
| 🧠 **Brain Wake** | Solve challenges that switch your brain "ON". |
| 🪙 **Wake Economy** | Earn **WakeCoin** for getting up early. |
| 🛡️ **Anti-Cheat** | No shortcuts and no fake walks. |

This repository is the **marketing and download site**, built with Flutter for Web as a single-page app.

## 🗂️ Pages

- **Landing**: hero section and call to action.
- **Story**: the mission behind the app.
- **Features**: interactive feature cards.
- **Download**: platform picker and a QR code to scan and install the beta.

## 🚀 Run it

```bash
flutter pub get
flutter run -d chrome        # dev
flutter build web            # production build in build/web
```

## 📁 Project structure

```
lib/
├── pages/     landing_page, story_page, features_page, download_page
├── widgets/   navbar, hero_section, feature_card, footer
└── main.dart
```

## 🇹🇷 Türkçe

**WakeBreaker**, gerçekten uyanmadan susmayan bir alarm uygulamasıdır. Ghost Walk ile 15 metre yürümeden alarm
kapanmaz, Brain Wake ile zihin uyandırılır, Wake Economy ile erken kalktıkça WakeCoin kazanılır. Bu depo
uygulamanın Flutter Web ile yazılmış tanıtım ve indirme sitesidir (Ana Sayfa, Hikayemiz, Özellikler, İndir).

---

<div align="center"><sub>Built by <a href="https://github.com/Soap2647">Mert Yasin Yılmaz</a></sub></div>
