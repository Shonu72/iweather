import Foundation
import CoreLocation

/// Errors thrown during GPS location fetching.
enum LocationError: LocalizedError {
    case permissionDenied
    case permissionRestricted
    case locationUnavailable
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission was denied. Please enable location access in iOS Settings."
        case .permissionRestricted:
            return "Location access is restricted on this device."
        case .locationUnavailable:
            return "Unable to determine current GPS location. Please try again."
        case .custom(let message):
            return message
        }
    }
}

/// Protocol defining location service capabilities.
protocol LocationManagerProtocol {
    func requestCurrentLocation() async throws -> WeatherLocation
}

/// Native iOS CoreLocation manager wrapping CLLocationManager with async/await and CLGeocoder reverse-geocoding.
final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Public Async Location Request
    
    func requestCurrentLocation() async throws -> WeatherLocation {
        let location = try await fetchRawCLLocation()
        return await reverseGeocode(location: location)
    }
    
    // MARK: - Private CLLocation Fetching
    
    private func fetchRawCLLocation() async throws -> CLLocation {
        let authStatus = manager.authorizationStatus
        
        switch authStatus {
        case .denied:
            throw LocationError.permissionDenied
        case .restricted:
            throw LocationError.permissionRestricted
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.manager.requestLocation()
        }
    }
    
    // MARK: - Reverse Geocoding Coordinates -> WeatherLocation
    
    private func reverseGeocode(location: CLLocation) async -> WeatherLocation {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let first = placemarks.first {
                let city = first.locality ?? first.subAdministrativeArea ?? first.name ?? "Current Location"
                let country = first.country ?? ""
                return WeatherLocation(city: city, country: country, latitude: lat, longitude: lon)
            }
        } catch {
            // Fall back to coordinate representation if reverse geocoding fails
        }
        
        return WeatherLocation(city: "Current Location", country: "", latitude: lat, longitude: lon)
    }
    
    // MARK: - CLLocationManagerDelegate Callbacks
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            if clError.code == .denied {
                locationContinuation?.resume(throwing: LocationError.permissionDenied)
            } else {
                locationContinuation?.resume(throwing: LocationError.locationUnavailable)
            }
        } else {
            locationContinuation?.resume(throwing: error)
        }
        locationContinuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            locationContinuation?.resume(throwing: LocationError.permissionDenied)
            locationContinuation = nil
        }
    }
}
