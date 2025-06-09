//
//  LocationsListApp.swift
//  LocationsList
//
//  Created by Sebastian Cancinos on 08/06/2025.
//

import SwiftUI

@main
struct LocationsListApp: App {
    var body: some Scene {
        WindowGroup {
            Self.buildFeatureScene()
        }
    }

    private static func buildFeatureScene() -> LocationsListView {
        return LocationsListViewController.setupVIP()
    }
}
