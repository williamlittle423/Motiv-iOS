//
//  LocationSearchService.swift
//  Motiv
//
//  Created by William Little on 2024-01-28.
//

import Foundation
import MapKit

final class LocalSearchService {
    private let center: CLLocationCoordinate2D
    private let radius: CLLocationDistance

    init(in center: CLLocationCoordinate2D,
         radius: CLLocationDistance = 350_000) {
        self.center = center
        self.radius = radius
    }

    public func searchCities(searchText: String, completion: @escaping ([MKMapItem]?) -> Void) {
        request(resultType: .address, searchText: searchText, completion: completion)
    }

    public func searchPointOfInterests(searchText: String, completion: @escaping ([MKMapItem]?) -> Void) {
        request(searchText: searchText, completion: completion)
    }

    private func request(resultType: MKLocalSearch.ResultType = .address,
                         searchText: String,
                         completion: @escaping ([MKMapItem]?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: radius,
                                            longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)

        search.start { response, _ in
            guard let response = response else {
                completion(nil)
                return
            }

            completion(response.mapItems)
        }
    }
}
