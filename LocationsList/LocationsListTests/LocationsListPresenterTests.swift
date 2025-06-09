import Quick
import Nimble
@testable import LocationsList

class LocationsListPresenterTests: QuickSpec {
    override class func spec() {
        describe("LocationsListPresenter") {
            var sut: LocationsListPresenter!
            var mockViewState: LocationListViewState!

            beforeEach {
                mockViewState = LocationListViewState()
                sut = LocationsListPresenter()
                sut.viewState = mockViewState
            }
            
            describe("presentLocations") {
                context("when loading") {
                    it("should update view state with loading") {
                        let response = LocationsList.FetchLocations.Response(
                            locations: [],
                            isLoading: true
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.loading).to(beTrue())
                        expect(mockViewState.locations).to(beEmpty())
                    }
                }
                
                context("when loaded") {
                    let locations = [
                        Location(name: "Test", latitude: 0.0, longitude: 0.0)
                    ]
                    
                    it("should update view state with locations") {
                        let response = LocationsList.FetchLocations.Response(
                            locations: locations,
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.loading).to(beFalse())
                        expect(mockViewState.locations).to(equal(locations))
                    }
                }
            }
        }
    }
}

