import Foundation
import Quick
import Nimble
@testable import LocationsList

class LocationsListInteractorTests: QuickSpec {
    override class func spec() {
        describe("LocationsListInteractor") {
            var sut: LocationsListInteractor!
            var mockPresenter: MockLocationsListPresenter!
            var mockRouter: MockLocationsListRouter!
            var mockWorker: MockLocationsListWorker!
            
            beforeEach {
                mockPresenter = MockLocationsListPresenter()
                mockRouter = MockLocationsListRouter()
                mockWorker = MockLocationsListWorker()
                
                sut = LocationsListInteractor()
                sut.presenter = mockPresenter
                sut.router = mockRouter
                sut.worker = mockWorker
            }
            
            describe("fetchLocations") {
                context("when worker returns locations") {
                    let expectedLocations = [
                        Location(name: "Test", latitude: 0.0, longitude: 0.0)
                    ]
                    
                    beforeEach {
                        mockWorker.mockLocations = expectedLocations
                    }
                    
                    it("should present locations") {
                        sut.fetchLocations(request: LocationsList.FetchLocations.Request())
                        
                        expect(mockPresenter.presentedLocations).toEventually(equal(expectedLocations))
                        expect(mockPresenter.isLoadingStates).to(equal([true, false]))
                    }
                }
                
                context("when worker throws error") {
                    beforeEach {
                        mockWorker.shouldThrowError = true
                    }
                    
                    it("should present empty locations") {
                        sut.fetchLocations(request: LocationsList.FetchLocations.Request())
                        
                        expect(mockPresenter.presentedLocations).toEventually(equal([]))
                        expect(mockPresenter.isLoadingStates).toEventually(equal([true, false]))
                    }
                }
            }
            
            describe("showLocation") {
                it("should route to Wikipedia") {
                    let request = LocationsList.ShowCustomLocation.Request(latitude: 0.0, longitude: 0.0)
                    sut.showLocation(request: request)
                    
                    expect(mockRouter.routedLocation).toNot(beNil())
                    expect(mockRouter.routedLocation?.latitude).to(equal(0.0))
                    expect(mockRouter.routedLocation?.longitude).to(equal(0.0))
                }
            }
        }
    }
}

// MARK: - Mocks
class MockLocationsListPresenter: LocationsListPresentationLogic {
    var presentedLocations: [Location] = []
    var isLoadingStates: [Bool] = []
    
    func presentLocations(response: LocationsList.FetchLocations.Response) {
        presentedLocations = response.locations
        isLoadingStates.append(response.isLoading)
    }
}

class MockLocationsListRouter: LocationsListRoutingLogic {
    var routedLocation: Location?
    
    func routeToWikipedia(for location: Location) {
        routedLocation = location
    }
}

class MockLocationsListWorker: LocationsListFetcher {
    var mockLocations: [Location] = []
    var shouldThrowError = false
    
    func fetchLocations() async throws -> [Location] {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1)
        }
        return mockLocations
    }
} 
