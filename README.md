# iWeather

A native iOS weather app built with SwiftUI, SwiftData, and the Open-Meteo REST API. Designed with scalable MVVM architecture, dependency injection, offline-first disk caching, and real-time particle canvas effects.

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
## Snapshots

![simulator_screenshot_B4EB13F8-E42D-45A2-BCC5-372D31406C92](https://github.com/user-attachments/assets/4089e8c2-9758-4a46-b09c-445da988b1fd)
<img width="1320" height="2868" alt="simulator_screenshot_CB312D62-5E4E-4D13-9434-2735B550E8EA" src="https://github.com/user-attachments/assets/d6d49d75-79cb-4143-a056-95565a89acd8" />
<img width="1320" height="2868" alt="simulator_screenshot_B28B8F64-A8FF-438E-B01C-6583BA5B208A" src="https://github.com/user-attachments/assets/0e7aaecf-ffaa-4580-8c41-3b4b5af37a88" />
<img width="1320" height="2868" alt="simulator_screenshot_1B8E3AFD-CADA-4CED-A390-01DA0F20CA12" src="https://github.com/user-attachments/assets/d8e55b7a-45cd-433c-8dcd-9bc30b90a1d9" />

