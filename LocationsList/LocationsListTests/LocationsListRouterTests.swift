import Quick
import Nimble
@testable import LocationsList

final class LocationsListRouterSpec: QuickSpec {
    override class func spec() {
        describe("LocationsListRouter") {
            var router: LocationsListRouter!
            
            beforeEach {
                router = LocationsListRouter()
            }
            
            describe("wikipediaDeepLink") {
                context("with positive coordinates") {
                    it("should return correct URL for Amsterdam") {
                        let url = router.wikipediaDeepLink(latitude: 52.3547498, longitude: 4.8339215)
                        
                        expect(url).toNot(beNil())
                        expect(url?.absoluteString) == "https://en.wikipedia.org/wiki/location?lat=52.3547498&lng=4.8339215"
                    }
                }
                
                context("with negative coordinates") {
                    it("should return correct URL for Sydney") {
                        let url = router.wikipediaDeepLink(latitude: -33.8688, longitude: 151.2093)
                        
                        expect(url).toNot(beNil())
                        expect(url?.absoluteString) == "https://en.wikipedia.org/wiki/location?lat=-33.8688&lng=151.2093"
                    }
                }
                
                context("with zero coordinates") {
                    it("should return correct URL for 0,0") {
                        let url = router.wikipediaDeepLink(latitude: 0.0, longitude: 0.0)
                        
                        expect(url).toNot(beNil())
                        expect(url?.absoluteString) == "https://en.wikipedia.org/wiki/location?lat=0.0&lng=0.0"
                    }
                }
            }
        }
    }
} 