import Quick
import Nimble
@testable import LocationsList

class LocationsListWorkerTests: QuickSpec {
    override class func spec() {
        describe("NetworkLocationsFetcher") {
            var sut: NetworkLocationsFetcher!
            
            beforeEach {
                sut = NetworkLocationsFetcher()
            }
            
            describe("fetchPlaces") {
                context("when network request succeeds") {
                    it("should return locations") {
                        Task {
                            let locations = try await sut.fetchPlaces()

                            expect(locations).toNot(beEmpty())
                            expect(locations.first?.name).toNot(beNil())
                            expect(locations.first?.lat).toNot(beNil())
                            expect(locations.first?.long).toNot(beNil())
                        }
                    }
                }
            }
        }
        
        describe("LocationsListWorker") {
            var sut: LocationsListWorker!
            
            beforeEach {
                sut = LocationsListWorker()
            }
            
            describe("fetchPlaces") {
                it("should return default locations") {
                    Task{
                        let locations = try await sut.fetchPlaces()
                        
                        expect(locations).toNot(beEmpty())
                        expect(locations.count).to(equal(4))
                        expect(locations.first?.name).to(equal("Amsterdam"))
                    }
                }
            }
        }
    }
} 
