//
//  EventViewModel.swift
//  Motiv
//
//  Created by William Little on 2024-01-28.
//

import Foundation
import MapKit

class EventViewModel: ObservableObject {
    
    @Published var displayCreateEvent = false
    @Published var displaySearchLocation = false
    
    @Published var eventTitle = ""
    @Published var eventDescription = ""
    @Published var eventFullAddress = ""
    @Published var eventAddress = ""
    
    
    
    // MARK: Location search related code
    @Published var cityText = "" {
        didSet {
            searchForCity(text: cityText)
        }
    }
    
    @Published var poiText = "" {
        didSet {
            searchForPOI(text: poiText)
        }
    }
    
    @Published var viewData = [LocationSearchData]()
    
    var service: LocalSearchService
    
    init() {
        // Queen's coordinates
        let center = CLLocationCoordinate2D(latitude: 44.2253, longitude: -76.4951)
        service = LocalSearchService(in: center)
        
        service.searchCities(searchText: "") { [weak self] mapItems in
            if let mapItems = mapItems {
                DispatchQueue.main.async {
                    self?.viewData = mapItems.map({ LocationSearchData(mapItem: $0) })
                }
            }
        }
    }
    
    private func searchForCity(text: String) {
        service.searchCities(searchText: text) { [weak self] mapItems in
            if let mapItems = mapItems {
                DispatchQueue.main.async {
                    self?.viewData = mapItems.map({ LocationSearchData(mapItem: $0) })
                }
            }
        }
    }
    
    private func searchForPOI(text: String) {
        service.searchPointOfInterests(searchText: text) { [weak self] mapItems in
            if let mapItems = mapItems {
                DispatchQueue.main.async {
                    self?.viewData = mapItems.map({ LocationSearchData(mapItem: $0) })
                }
            }
        }
    }
    
}
