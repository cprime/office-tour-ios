//
//  TourMap.swift
//  Office-Tour
//
//  Created by Colden Prime on 8/31/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

struct TourLocation {
    let identifier: String
    let position: CGPoint

    var imageName: String {
        return "\(identifier).jpg"
    }
}

struct TourPath {
    var start: TourLocation
    var end: TourLocation
}

struct TourMap {
    let locations: [TourLocation]
    let paths: [TourPath]

    init(locations: [TourLocation], pathIdentifierPairs: [(String,String)]) {
        self.locations = locations
        var paths = [TourPath]()
        for (start, end) in pathIdentifierPairs {
            let startLocation = locations.first(where: { $0.identifier == start })!
            let endLocation = locations.first(where: { $0.identifier == end })!
            paths.append(TourPath(start: startLocation, end: endLocation))
            paths.append(TourPath(start: endLocation, end: startLocation))
        }
        self.paths = paths
    }

    func validDestinations(from: TourLocation) -> [TourLocation] {
        return paths.filter({ $0.start.identifier == from.identifier }).map({ $0.end })
    }

    static var appartmentTour: TourMap {
        let locations = [
            TourLocation(identifier: "entrance", position: CGPoint(x: 0, y: 0)),
            TourLocation(identifier: "stairs", position: CGPoint(x: 0, y: 1)),
            TourLocation(identifier: "kitchen", position: CGPoint(x: 0, y: 2)),
            TourLocation(identifier: "living-room", position: CGPoint(x: 1, y: 1)),
            TourLocation(identifier: "play-room", position: CGPoint(x: 1, y: 2))
        ]
        let paths = [
            ("entrance", "stairs"),
            ("stairs", "kitchen"),
            ("stairs", "living-room"),
            ("living-room", "play-room"),
            ("kitchen", "play-room")
        ]
        return TourMap(locations: locations, pathIdentifierPairs: paths)
    }
}
