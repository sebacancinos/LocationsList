import Foundation

@MainActor
class LocationsListPresenter: LocationsListPresentationLogic {
    weak var viewState: LocationListViewState?

    func presentLocations(response: LocationsList.FetchLocations.Response) {
        viewState?.loading = response.isLoading
        viewState?.locations = response.locations
    }
}
