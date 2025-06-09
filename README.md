# AMRO - Wikipedia Location Integration

This project consists of two iOS applications that work together to provide a seamless experience for viewing Wikipedia articles about locations:

1. **Modified Wikipedia iOS App**: A customized version of the Wikipedia iOS app that can handle deeplinks with coordinates and display locations on a map.
2. **LocationsList App**: A SwiftUI-based app that fetches places from a backend provider and can open the Wikipedia app with specific coordinates.

## Features

### Modified Wikipedia iOS App

- Handles deeplinks with latitude and longitude parameters
- Displays locations on an interactive map
- Shows Wikipedia articles related to specific locations
- Supports both map and list views of locations
- Includes location-based search functionality
- Maintains all standard Wikipedia app features

### LocationsList App

- Fetches places from a backend provider
- Displays a list of locations with their names and coordinates
- Allows adding custom locations with specific coordinates
- Integrates with the Wikipedia app through deeplinks
- Built using SwiftUI and follows VIP architecture
- Supports pull-to-refresh for updating the location list

## Integration

The apps are integrated through URL schemes and deeplinks:

1. The LocationsList app can open the Wikipedia app using a URL scheme with coordinates:

   ```
   https://en.wikipedia.org/wiki/location?lat={latitude}&lng={longitude}
   ```

2. The Wikipedia app handles these deeplinks and:
   - Opens the Places tab
   - Centers the map on the specified coordinates
   - Shows relevant Wikipedia articles for that location

## Architecture

### Wikipedia iOS App

- Uses UIKit for the main interface
- Implements a custom URL scheme handler
- Includes a PlacesViewController for map and location functionality
- Maintains the original Wikipedia app architecture

### LocationsList App

- Built with SwiftUI
- Follows VIP (View-Interactor-Presenter) architecture
- Uses async/await for network operations
- Implements clean separation of concerns

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Setup

1. Clone repository
2. Install dependencies (if any)
3. Build and run each app separately
4. Ensure both apps are installed on the same device for full functionality

## Usage

1. Open the LocationsList app
2. Browse the list of available locations
3. Tap on the Wikipedia button of the location to open it in the Wikipedia app
4. Alternatively, open a custom location using the "Show custom location" button
5. The Wikipedia app will open and show the location on its map
