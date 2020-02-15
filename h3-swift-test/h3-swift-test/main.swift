//
//  h3-swift.swift
//  h3-swift
//
//  Created by David Van Duzer on 2/11/18.
//  Copyright © 2018 SCUPPER™ Foundation. All rights reserved.
//

import Foundation
import h3

func haversineDistance(th1: Double, ph1: Double, th2: Double, ph2: Double) -> Double{
    var dx, dy, dz: Double
    let R = 6371.0088
    dz = sin(th1) - sin(th2)
    dx = cos(ph1 - ph2) * cos(th1) - cos(th2)
    dy = sin(ph1 - ph2) * cos(th1)
    return asin(sqrt(dx * dx + dy * dy + dz * dz) / 2) * 2 * R
}

func main() {
    // 1455 Market St @ resolution 15
    let geoHQ1: GeoCoord = GeoCoord(cell: stringToH3("8f2830828052d25"))

    // 555 Market St @ resolution 15
    let geoHQ2: GeoCoord = GeoCoord(cell: stringToH3("8f283082a30e623"))

    print(String(
        format: """
            origin: (%lf°, %lf°)
            destination: (%lf°, %lf°)
            distance: %lf km
        """,
        radsToDegs(geoHQ1.latitudeInRadians), radsToDegs(geoHQ1.longitudeInRadians),
        radsToDegs(geoHQ2.latitudeInRadians), radsToDegs(geoHQ2.longitudeInRadians),
        haversineDistance(th1: geoHQ1.latitudeInRadians, ph1: geoHQ1.longitudeInRadians, th2: geoHQ2.latitudeInRadians, ph2: geoHQ2.longitudeInRadians)
    ))
    // Output:
    // origin: (37.775236, 237.580245)
    // destination: (37.789991, 237.597879)
    // distance: 2.256850km
}

main()
