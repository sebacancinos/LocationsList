import Foundation

class LocationsListInteractor: LocationsListBusinessLogic {
    var presenter: LocationsListPresentationLogic?
    var router: LocationsListRoutingLogic?
    var worker: LocationsListFetcher

    init() {
        worker = NetworkLocationsFetcher()
    }

    func fetchLocations(request: LocationsList.FetchLocations.Request) {
        Task {
            // Show loading state
            await presenter?.presentLocations(response: LocationsList.FetchLocations.Response(
                locations: [],
                isLoading: true
            ))
        
            do {
                let locations = try await worker.fetchLocations()
                // Show loaded data
                await presenter?.presentLocations(response: LocationsList.FetchLocations.Response(
                    locations: locations,
                    isLoading: false
                ))
            } catch {
                print("Error fetching locations: \(error)")
                // Show error state (empty list)
                await presenter?.presentLocations(response: LocationsList.FetchLocations.Response(
                    locations: [],
                    isLoading: false
                ))
            }
        }
    }

    func showLocation(request: LocationsList.ShowCustomLocation.Request) {
        let location = Location(name: nil, latitude: request.latitude, longitude: request.longitude)
        router?.routeToWikipedia(for: location)
    }
}
