import SwiftUI

// MARK: - Models
struct Location: Identifiable, Codable, Equatable {
    let name: String?
    let latitude: Double
    let longitude: Double
    var id: String { name ?? "\(latitude),\(longitude)" }

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

// MARK: - VIP Protocols
enum LocationsList {
    enum FetchLocations {
        struct Request {}
        struct Response {
            let locations: [Location]
            let isLoading: Bool
        }
    }
    
    enum ShowCustomLocation {
        struct Request {
            let latitude: Double
            let longitude: Double
        }
        struct Response {}
    }
}

// MARK: - Interactor Protocol
protocol LocationsListBusinessLogic {
    func fetchLocations(request: LocationsList.FetchLocations.Request)
    func showLocation(request: LocationsList.ShowCustomLocation.Request)
}

// MARK: - Presenter Protocol
@MainActor
protocol LocationsListPresentationLogic {
    func presentLocations(response: LocationsList.FetchLocations.Response)
}

// MARK: - Router Protocol
protocol LocationsListRoutingLogic {
    func routeToWikipedia(for location: Location)
}

// MARK: - Fetch Locations
protocol LocationsListFetcher {
    func fetchLocations() async throws -> [Location]
}
