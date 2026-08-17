import Foundation

/// Application execution environment enum.
enum AppEnvironment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"
}

/// Centralized configuration reader fetching environment variables and API endpoints safely.
enum AppConfig {
    
    /// Current app build environment.
    static var environment: AppEnvironment {
        if let envString = Bundle.main.object(forInfoDictionaryKey: "APP_ENVIRONMENT") as? String,
           let env = AppEnvironment(rawValue: envString) {
            return env
        }
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    /// Base URL endpoint for Open-Meteo Weather Forecast API.
    static var weatherAPIBaseURL: String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_BASE_URL") as? String, !url.isEmpty {
            return url
        }
        return "api.open-meteo.com"
    }
    
    /// Base URL endpoint for Open-Meteo Geocoding Search API.
    static var geocodingAPIBaseURL: String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "GEOCODING_API_BASE_URL") as? String, !url.isEmpty {
            return url
        }
        return "geocoding-api.open-meteo.com"
    }
}
