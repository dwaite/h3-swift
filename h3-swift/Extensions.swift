//
//  GeoBoundary.swift
//  h3-swift
//
//  Created by David Waite on 2/13/20.
//  Copyright © 2020 David Van Duzer. All rights reserved.
//

import Foundation

public extension GeoBoundary {
    var vertices: [GeoCoord] {
        var v = __verts
        return withUnsafePointer(to: &v.0) { ptr in
            [GeoCoord](UnsafeBufferPointer(start: ptr, count: Int(__numVerts)))
        }
    }

    init(vertices: [GeoCoord]) {
        guard vertices.count <= MAX_CELL_BNDRY_VERTS else {
            fatalError("Too many vertices: \(vertices.count) > \(MAX_CELL_BNDRY_VERTS)")
        }
        self.init()
        __numVerts = Int32(vertices.count)
        withUnsafeMutablePointer(to: &__verts.0) { ptr in
            vertices.withContiguousStorageIfAvailable { buffer in
                ptr.assign(from: buffer.baseAddress!, count: vertices.count)
            }
        }
    }

    init(cell: H3Index) {
        self.init()
        __h3ToGeoBoundary(cell, &self)
    }
}

public extension Geofence {
    var vertices: [GeoCoord] {
        return [GeoCoord](UnsafeBufferPointer(start: __verts, count: Int(__numVerts)))
    }

    init(vertices: [GeoCoord]) {
        let __verts = malloc(MemoryLayout<GeoCoord>.stride * vertices.count).assumingMemoryBound(to: GeoCoord.self)
        let __numVerts = Int32(vertices.count)
        vertices.withContiguousStorageIfAvailable { buffer in
            __verts.assign(from: buffer.baseAddress!, count: vertices.count)
        }
        self.init(__numVerts: __numVerts, __verts: __verts)
    }
}

public extension GeoPolygon {
    var holes: [Geofence] {
        return [Geofence](UnsafeBufferPointer(start: __holes, count: Int(__numHoles)))
    }

    init(geofence: Geofence, holes: [Geofence]) {
        if holes.isEmpty {
            self.init(geofence: geofence, __numHoles: 0, __holes: nil)
        }
        else {
            let __holes = malloc(MemoryLayout<Geofence>.stride * holes.count).assumingMemoryBound(to: Geofence.self)
            let __numHoles = Int32(holes.count)
            holes.withContiguousStorageIfAvailable { buffer in
                __holes.assign(from: buffer.baseAddress!, count: holes.count)
            }
            self.init(geofence: geofence, __numHoles: __numHoles, __holes: __holes)
        }
    }
}

public extension GeoMultiPolygon {
    var polygons: [GeoPolygon] {
        return [GeoPolygon](UnsafeBufferPointer(start: __polygons, count: Int(__numPolygons)))
    }

    init(polygons: [GeoPolygon]) {
        let __polygons = malloc(MemoryLayout<GeoPolygon>.stride * polygons.count).assumingMemoryBound(to: GeoPolygon.self)
        let __numPolygons = Int32(polygons.count)

        polygons.withContiguousStorageIfAvailable { buffer in
            __polygons.assign(from: buffer.baseAddress!, count: polygons.count)
        }
        self.init(__numPolygons: __numPolygons, __polygons: __polygons)
    }
}

public extension GeoCoord {
    func h3(resolutionCell: Int) -> H3Index {
        var coord = self
        return __geoToH3(&coord, Int32(resolutionCell))
    }

    init(cell: H3Index) {
        self.init()
        __h3ToGeo(cell, &self)
    }
}
