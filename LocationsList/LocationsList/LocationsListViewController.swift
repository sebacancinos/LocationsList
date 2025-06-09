import SwiftUI

class LocationsListViewController: UIHostingController<LocationsListView> {

    static func setupVIP() -> LocationsListView{
        let interactor = LocationsListInteractor()
        let presenter = LocationsListPresenter()
        let router = LocationsListRouter()
        let viewState = LocationListViewState()

        interactor.presenter = presenter
        interactor.router = router
        presenter.viewState = viewState

        let viewController = LocationsListViewController(rootView: LocationsListView(viewState: viewState, interactor: interactor))

        return viewController.rootView
    }
}
