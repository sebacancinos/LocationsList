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
                let places = try await worker.fetchPlaces()
                // Show loaded data
                await presenter?.presentLocations(response: LocationsList.FetchLocations.Response(
                    locations: places,
                    isLoading: false
                ))
            } catch {
                print("Error fetching places: \(error)")
                // Show error state (empty list)
                await presenter?.presentLocations(response: LocationsList.FetchLocations.Response(
                    locations: [],
                    isLoading: false
                ))
            }
        }
    }

    func showLocation(request: LocationsList.ShowCustomLocation.Request) {
        let location = Location(name: nil, lat: request.latitude, long: request.longitude)

        router?.routeToWikipedia(for: location)
    }
}
