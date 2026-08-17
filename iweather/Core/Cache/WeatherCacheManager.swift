import Foundation

/// Protocol defining offline weather disk caching operations.
protocol WeatherCacheManagerProtocol {
    func getCachedWeather(for locationKey: String) -> Weather?
    func saveWeatherToCache(_ weather: Weather, for locationKey: String)
    func clearCache()
}

/// Disk cache manager persisting JSON-serialized Weather payloads inside the app's Caches directory.
final class WeatherCacheManager: WeatherCacheManagerProtocol {
    private let fileManager: FileManager
    private let cacheDirectory: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheFolder = paths[0].appendingPathComponent("WeatherCache", isDirectory: true)
        
        if !fileManager.fileExists(atPath: cacheFolder.path) {
            try? fileManager.createDirectory(at: cacheFolder, withIntermediateDirectories: true)
        }
        self.cacheDirectory = cacheFolder
    }
    
    func getCachedWeather(for locationKey: String) -> Weather? {
        let sanitized = sanitizedKey(locationKey)
        let fileURL = cacheDirectory.appendingPathComponent("\(sanitized).json")
        
        // 1. Direct file lookup
        if let data = try? Data(contentsOf: fileURL),
           var weather = try? JSONDecoder().decode(Weather.self, from: data) {
            weather.isFromCache = true
            return weather
        }
        
        // 2. Fuzzy city name lookup if key differs
        let cityName = locationKey.lowercased().components(separatedBy: "_").first ?? locationKey.lowercased()
        if let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) {
            for file in files where file.pathExtension == "json" {
                let filename = file.deletingPathExtension().lastPathComponent.lowercased()
                if filename.contains(cityName) || cityName.contains(filename) {
                    if let data = try? Data(contentsOf: file),
                       var weather = try? JSONDecoder().decode(Weather.self, from: data) {
                        weather.isFromCache = true
                        return weather
                    }
                }
            }
        }
        
        return nil
    }
    
    func saveWeatherToCache(_ weather: Weather, for locationKey: String) {
        let fileURL = cacheDirectory.appendingPathComponent("\(sanitizedKey(locationKey)).json")
        var payload = weather
        payload.isFromCache = false
        
        if let data = try? JSONEncoder().encode(payload) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
    }
    
    private func sanitizedKey(_ key: String) -> String {
        key.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "_")
    }
}
