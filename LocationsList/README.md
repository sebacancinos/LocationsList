# Locations List

A SwiftUI application that displays a list of locations with their coordinates and provides Wikipedia integration.

## Features

- Display a list of locations with their coordinates
- Loading state handling with spinner
- Wikipedia integration for each location
- Clean Swift (VIP) architecture implementation
- Async/await for network operations
- SwiftUI-native state management
- Comprehensive unit testing with Quick and Nimble

## Architecture

This project follows the Clean Swift (VIP) architecture pattern, which provides a clear separation of concerns and unidirectional data flow. The main components are:

### View Layer

- `LocationsListView`: SwiftUI view that displays the list of locations
- `LocationListViewState`: Observable state object that manages the view's state and UI updates

### Interactor Layer

- `LocationsListInteractor`: Handles business logic and coordinates between the view and data layers
- `LocationsListWorker`: Handles data operations (network requests)
- Manages async operations with proper Task handling

### Presenter Layer

- `LocationsListPresenter`: Formats data for display and manages view state updates
- Uses `@MainActor` for thread-safe UI updates
- Direct state management through `LocationListViewState`

### Router Layer

- `LocationsListRouter`: Handles navigation and external app interactions (Wikipedia)
- Manages external URL handling

## Project Structure

```
LocationsList/
├── LocationsListProtocols.swift    # Protocol definitions and models
├── LocationsListInteractor.swift   # Business logic
├── LocationsListPresenter.swift    # Data formatting
├── LocationsListRouter.swift       # Navigation
├── LocationsListWorker.swift       # Data operations
└── LocationsListView.swift         # SwiftUI views

LocationsListTests/
├── LocationsListInteractorTests.swift  # Interactor tests
├── LocationsListPresenterTests.swift   # Presenter tests
└── LocationsListWorkerTests.swift      # Worker tests
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Quick and Nimble for testing

## Installation

1. Clone the repository
2. Open `LocationsList.xcodeproj` in Xcode
3. Build and run the project

## Testing

The project uses Quick and Nimble for BDD-style testing. Tests are organized by component:

### Interactor Tests

- Tests business logic
- Verifies loading states
- Tests error handling
- Verifies routing behavior

### Presenter Tests

- Tests data formatting
- Verifies state updates
- Tests loading state management

### Worker Tests

- Tests network requests
- Verifies default data
- Tests error handling

To run the tests:

1. Open the project in Xcode
2. Press Cmd+U or select Product > Test

## Usage

The app will automatically load a list of locations. Each location entry shows:

- Location name (if available)
- Latitude
- Longitude
- Wikipedia button

## Architecture Details

### VIP Cycle

1. View triggers an action through the interactor
2. Interactor processes the business logic using async/await
3. Presenter formats the data and updates the view state
4. View reacts to state changes through SwiftUI's binding system

### State Management

- Uses `@MainActor` for thread-safe UI updates
- Observable state object (`LocationListViewState`) for reactive UI updates
- Async/await for network operations
- Direct state updates through the presenter
