# iWeather

A native iOS weather app built with SwiftUI, SwiftData, and the Open-Meteo REST API. Designed with scalable MVVM architecture, dependency injection, offline-first disk caching, and real-time particle canvas effects.

---

## Snapshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/4089e8c2-9758-4a46-b09c-445da988b1fd" width="19%" alt="Weather Screen 1" />
  <img src="https://github.com/user-attachments/assets/d6d49d75-79cb-4143-a056-95565a89acd8" width="19%" alt="Weather Screen 2" />
  <img src="https://github.com/user-attachments/assets/0e7aaecf-ffaa-4580-8c41-3b4b5af37a88" width="19%" alt="Search Screen" />
  <img src="https://github.com/user-attachments/assets/5b333ba2-f618-4484-ad30-7c39230422fb" width="19%" alt="Offline Screen" />
  <img src="https://github.com/user-attachments/assets/d8e55b7a-45cd-433c-8dcd-9bc30b90a1d9" width="19%" alt="Saved Cities" />
</p>

---

## 🎬 Demo Video

<p align="center">
  <a href="https://youtube.com/shorts/csoAqr9tY7E?feature=share" target="_blank">
    <img src="https://github.com/user-attachments/assets/4089e8c2-9758-4a46-b09c-445da988b1fd" width="85%" alt="iWeather iOS Demo Video" />
  </a>
</p>

<p align="center">
  👉 <b><a href="https://youtube.com/shorts/csoAqr9tY7E?feature=share">Watch full iWeather Demo Video on YouTube</a></b>
</p>

---

## Features

- **Live Weather & Forecasts**: Real-time current metrics (humidity, wind speed, pressure, UV index, visibility), 24-hour hourly timeline, and 7-day forecast.
- **Search & Debouncing**: Interactive city search powered by Open-Meteo Geocoding API with 350ms search query debouncing.
- **Location Services**: CoreLocation integration for instant current-location weather lookup with explicit permission handling.
- **Saved Cities (`SwiftData`)**: Local persistence allowing users to bookmark favorite cities and manage them via native swipe-to-delete.
- **Offline-First Caching**: `FileManager` disk cache fallback serving stored weather snapshots when disconnected from the internet.
- **Dynamic Weather UI**: Adaptive gradient themes and `TimelineView` + `Canvas` ambient particle animations (rain droplets, sunburst glow, starry night).
- **Unit Conversion**: Instant °C / °F toggle with smooth numeric text transitions (`.contentTransition(.numericText())`).

---

## Tech Stack & Architecture

- **iOS 17.0+** / **Swift 5.9+** / **Xcode 15+**
- **Frameworks**: SwiftUI, SwiftData, CoreLocation, Observation (`@Observable`)
- **Networking**: `URLSession` async/await with generic `APIRequest` protocol
- **Architecture**: Scalable Layered MVVM
  
## Architecture Snapshot

<p align="center">
  <img width="879" height="431" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/b95db6aa-e6bd-45b4-bfd0-9c9074a52bb4" />
</p>

---
