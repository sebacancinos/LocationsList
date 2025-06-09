//
//  LocationsListWorker.swift
//  LocationsList
//
//  Created by Sebastian Cancinos on 08/06/2025.
//

import Foundation

class LocationsListWorker: LocationsListFetcher {

    func fetchLocations() async throws -> [Location] {
        return [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
    }
}

struct LocationsListResponse: Decodable {
    let locations: [Location]
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
}

class NetworkLocationsFetcher: LocationsListFetcher {
    func fetchLocations() async throws -> [Location] {
        let decoder = JSONDecoder()
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                let locations = try decoder.decode(LocationsListResponse.self, from: data)
                return locations.locations
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError(error)
            }
        } catch {
            print("Network error: \(error)")
            throw NetworkError.networkError(error)
        }
    }
}
