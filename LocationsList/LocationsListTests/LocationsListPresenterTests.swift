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
                    it("should update view state with loading state") {
                        let response = LocationsList.FetchLocations.Response(
                            locations: [],
                            isLoading: true
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.loading).to(beTrue())
                        expect(mockViewState.locations).to(beEmpty())
                    }
                }
                
                context("when loaded with locations") {
                    it("should update view state with locations") {
                        let locations = [
                            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
                            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468)
                        ]
                        
                        let response = LocationsList.FetchLocations.Response(
                            locations: locations,
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.loading).to(beFalse())
                        expect(mockViewState.locations).to(equal(locations))
                    }
                }
                
                context("when loaded with empty locations") {
                    it("should update view state with empty list") {
                        let response = LocationsList.FetchLocations.Response(
                            locations: [],
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.loading).to(beFalse())
                        expect(mockViewState.locations).to(beEmpty())
                    }
                }
                
                context("when locations have null names") {
                    it("should rename null names to 'Unknown Location'") {
                        let locations = [
                            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758),
                            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)
                        ]
                        
                        let response = LocationsList.FetchLocations.Response(
                            locations: locations,
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.locations.first?.name).to(equal("Amsterdam"))
                        expect(mockViewState.locations.last?.name).to(equal("[Unnamed Location]"))
                    }
                }
                
                context("when locations need sorting") {
                    it("should sort locations by name") {
                        let locations = [
                            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
                            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
                            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
                        ]
                        
                        let response = LocationsList.FetchLocations.Response(
                            locations: locations,
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.locations.map { $0.name }).to(equal(["Amsterdam", "Copenhagen", "Mumbai"]))
                    }
                }
                
                context("when locations have null names and need sorting") {
                    it("should rename null names and sort all locations") {
                        let locations = [
                            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758),
                            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
                            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)
                        ]
                        
                        let response = LocationsList.FetchLocations.Response(
                            locations: locations,
                            isLoading: false
                        )
                        
                        sut.presentLocations(response: response)
                        
                        expect(mockViewState.locations.map { $0.name }).to(equal(["Amsterdam", "Mumbai", "[Unnamed Location]"]))
                    }
                }
            }
        }
    }
}

// MARK: - Mock View State
private class MockLocationListViewState: LocationListViewStateProtocol {
    var loading: Bool = false
    var locations: [Location] = []
}

