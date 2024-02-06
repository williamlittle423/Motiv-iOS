//
//  LocationSearchData.swift
//  Motiv
//
//  Created by William Little on 2024-01-28.
//

import Foundation
import MapKit

struct LocationSearchData: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
    }
}
