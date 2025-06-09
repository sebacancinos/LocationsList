import WMF
import CoreLocation
import WMFComponents

final class LinkCoordinator: Coordinator {
    
    enum Destination {
        case article
        case location(coordinates: CLLocation)
        case unknown
    }
    
    let navigationController: UINavigationController
    private let url: URL
    private let dataStore: MWKDataStore
    var theme: Theme
    private let articleSource: ArticleSource
    private let previousPageViewObjectID: NSManagedObjectID?
    let tabConfig: ArticleTabConfig
    
    init(navigationController: UINavigationController, url: URL, dataStore: MWKDataStore?, theme: Theme, articleSource: ArticleSource, previousPageViewObjectID: NSManagedObjectID? = nil, tabConfig: ArticleTabConfig = .appendArticleAndAssignCurrentTab) {
        self.navigationController = navigationController
        self.url = url
        self.dataStore = dataStore ?? MWKDataStore.shared()
        self.theme = theme
        self.articleSource = articleSource
        self.previousPageViewObjectID = previousPageViewObjectID
        self.tabConfig = tabConfig
    }
    
    @discardableResult
    func start() -> Bool {
        
        let destination = Self.destination(for: url)
        
        switch destination {
        case .article:
            let articleCoordinator: ArticleCoordinator = ArticleCoordinator(
                navigationController: navigationController,
                articleURL: url,
                dataStore: dataStore,
                theme: theme,
                source: articleSource,
                previousPageViewObjectID: previousPageViewObjectID,
                tabConfig: self.tabConfig)
            
            return articleCoordinator.start()
        case .location(let coordinates):
            guard let rootViewController = navigationController.viewControllers.first,
                  let tabBarController = rootViewController.tabBarController as? WMFAppViewController else {
                return false
            }
            
            tabBarController.selectedIndex = AppTab.places.rawValue
            let placesViewController = tabBarController.placesViewController
            placesViewController.showCoordinates(coordinates)
            return true

        case .unknown:
            return false
        }
    }

    static func extractCoordinatesFromURL(url: URL) -> CLLocation? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }

        let params = queryItems.reduce(into: [:]) { partialResult, item in
            return partialResult[item.name] = item.value
        }

        guard let lat = params["lat"], let doubleLat = Double(lat),
              let lng = params["lng"], let doubleLng = Double(lng) else {
            return nil
        }

        return CLLocation(latitude: doubleLat, longitude: doubleLng)
    }

    static func destination(for url: URL) -> Destination {
        
        guard let siteURL = url.wmf_site,
              let project = WikimediaProject(siteURL: siteURL) else {
            return .unknown
        }
        
        // Copied from Router.swift's destinationForHostURL
        
        let canonicalURL = url.canonical
        
        guard let path = canonicalURL.wikiResourcePath else {
            return .unknown
        }
        
        let language = project.languageCode ?? "en"
        
        let namespaceAndTitle = path.namespaceAndTitleOfWikiResourcePath(with: language)
        let namespace = namespaceAndTitle.0
        let title = namespaceAndTitle.1
        
        switch namespace {
        case .main:
            guard project.mainNamespaceGoesToNativeArticleView else {
                return .unknown
            }
            
            // Do not navigate donate thankyou page to article view
            guard let host = url.host,
                  host != "thankyou.wikipedia.org" else {
                return .unknown
            }
            
            let isMainPageTitle = WikipediaURLTranslations.isMainpageTitle(title, in: language)

            if title == "location", let coordinates = extractCoordinatesFromURL(url: canonicalURL) {
                return .location(coordinates: coordinates)
            }

            guard !isMainPageTitle else {
                return .unknown
            }
            
            return .article
        default:
            return .unknown
        }
    }
}
