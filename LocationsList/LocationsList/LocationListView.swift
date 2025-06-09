import SwiftUI

protocol LocationListViewStateProtocol {
    var locations: [Location] { get set }
    var loading: Bool { get set }
}

class LocationListViewState: LocationListViewStateProtocol, ObservableObject{

    @Published var locations: [Location] = []
    @Published var loading: Bool = false
}

struct CustomLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    let action: (_ lat: Double, _ long: Double) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Coordinates")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Show Wikipedia") {
                        guard let lat = Double(latitude), let lng = Double(longitude) else {
                            return
                        }

                        action(lat, lng)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LocationView: View {
    let location: Location
    let action: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(location.name ?? "Unknown Location")
                    .font(.headline)
                Text("Latitude: \(location.lat)")
                    .font(.subheadline)
                Text("Longitude: \(location.long)")
                    .font(.subheadline)
            }
            .padding(.vertical, 4)
            Spacer()
            Button(action: action) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Wikipedia")
            }
        }
    }
}

struct ShowCustomLocationButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "location.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Show custom location")
            }
        }
    }
}

struct LocationsListView: View {
    @ObservedObject var viewState: LocationListViewState
    let interactor: LocationsListBusinessLogic
    @State private var showingCustomLocation = false

    var body: some View {
        VStack{
            if viewState.loading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
            else
            {
                List(viewState.locations) { location in
                    LocationView(location: location) {
                        let req = LocationsList.ShowCustomLocation.Request(latitude: location.lat, longitude: location.long)
                        interactor.showLocation(request: req)
                    }
                }
                .refreshable {
                    interactor.fetchLocations(request: LocationsList.FetchLocations.Request())
                }
            }
            Spacer()
            ShowCustomLocationButton {
                showingCustomLocation = true
            }
        }
        .sheet(isPresented: $showingCustomLocation) {
            CustomLocationView() {lat,long in
                let req = LocationsList.ShowCustomLocation.Request(latitude: lat, longitude: long)

                interactor.showLocation(request: req)
            }
        }
        .onAppear() {
            interactor.fetchLocations(request: LocationsList.FetchLocations.Request())
        }
    }
}
