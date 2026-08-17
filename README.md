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
