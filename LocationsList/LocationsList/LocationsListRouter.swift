import SwiftUI
import CoreLocation

class LocationsListRouter: LocationsListRoutingLogic {
    func wikipediaDeepLink(latitude: Double, longitude: Double) -> URL? {
        guard let baseURL = URL(string: "https://en.wikipedia.org/wiki") else {
            return nil
        }

        let latitude = URLQueryItem(name: "lat", value: String(latitude))
        let longitude = URLQueryItem(name: "lng", value: String(longitude))

        return baseURL.appending(path: "location")
            .appending(queryItems: [latitude, longitude])
    }

    func routeToWikipedia(for location: Location) {
        // TODO: Implement Wikipedia navigation

        guard let url = wikipediaDeepLink(latitude: location.latitude, longitude: location.longitude) else {
            return
        }

        UIApplication.shared.open(url)
    }
} 
