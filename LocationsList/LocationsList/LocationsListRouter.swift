import SwiftUI
import CoreLocation

class LocationsListRouter: LocationsListRoutingLogic {
    func routeToWikipedia(for location: Location) {
        // TODO: Implement Wikipedia navigation

        guard let url = URL(string: "https://en.wikipedia.org/wiki/location?lat=\(location.lat)&lng=\(location.long)") else {
            return
        }

        UIApplication.shared.open(url)

        print(url.absoluteString)
    }
} 
