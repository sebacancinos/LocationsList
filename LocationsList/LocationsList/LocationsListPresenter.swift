import Foundation

@MainActor
class LocationsListPresenter: LocationsListPresentationLogic {
    weak var viewState: LocationListViewState?

    func presentLocations(response: LocationsList.FetchLocations.Response) {
        let locations = response.locations.map ({ location in
            if location.name == nil {
                return Location(name: "[Unnamed Location]", latitude: location.latitude, longitude: location.longitude)
            } else {
                return location
            }
        }).sorted(by: { loc1, loc2 in
            return loc1.name ?? "" < loc2.name ?? ""
        })

        viewState?.loading = response.isLoading
        viewState?.locations = locations
    }
}
