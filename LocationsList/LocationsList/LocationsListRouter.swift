import SwiftUI
import CoreLocation

class LocationsListRouter: LocationsListRoutingLogic {
    func routeToWikipedia(for location: Location) {
        // TODO: Implement Wikipedia navigation

        guard let url = URL(string: "https://en.wikipedia.org/wiki/location?lat=\(location.latitude)&lng=\(location.longitude)") else {
            return
        }

        UIApplication.shared.open(url)
    }
} 
