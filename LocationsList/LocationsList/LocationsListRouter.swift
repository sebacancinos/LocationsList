import SwiftUI
import CoreLocation

class LocationsListRouter: LocationsListRoutingLogic {
    func routeToWikipedia(for location: Location) {
        // TODO: Implement Wikipedia navigation

        guard let baseURL = URL(string: "https://en.wikipedia.org/wiki/location") else {
            return
        }

        let latitude = URLQueryItem(name: "lat", value: String(location.latitude))
        let longitude = URLQueryItem(name: "lng", value: String(location.longitude))

        let url = baseURL.appending(queryItems: [latitude, longitude])
        UIApplication.shared.open(url)
    }
} 
