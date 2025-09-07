//
//  RouteMapView.swift
//  GOGO
//
//  Created by Snippets on 8/21/25.
//  

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    enum LineStyle {
        case straight
        case geodesic
        case curved(amount: Double)
    }

    @Binding var source: CLLocationCoordinate2D
    @Binding var destination: CLLocationCoordinate2D
    var style: LineStyle = .curved(amount: 0.18)

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)

        let start = MKPointAnnotation()
        start.coordinate = source
        start.title = "PickUp"

        let end = MKPointAnnotation()
        end.coordinate = destination
        end.title = "Drop"

        map.addAnnotations([start, end])

        let overlay: MKPolyline
        switch style {
        case .straight:
            var coords = [source, destination]
            overlay = MKPolyline(coordinates: &coords, count: coords.count)

        case .geodesic:
            var coords = [source, destination]
            overlay = MKGeodesicPolyline(coordinates: &coords, count: coords.count)

        case .curved(let amount):
            overlay = curvedPolyline(from: source, to: destination, curvature: amount)
        }

        map.addOverlay(overlay)

        map.setVisibleMapRect(
            overlay.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40),
            animated: true
        )
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let r = MKPolylineRenderer(polyline: polyline)
                r.strokeColor = .black
                r.lineWidth = 5
                r.lineCap = .round
                return r
            }
            return MKOverlayRenderer()
        }
    }
}

private func curvedPolyline(from a: CLLocationCoordinate2D,
                            to b: CLLocationCoordinate2D,
                            curvature k: Double,
                            segments: Int = 100) -> MKPolyline {
    let k = max(0.0, min(1.0, k))

    let p0 = MKMapPoint(a)
    let p2 = MKMapPoint(b)

    let mid = MKMapPoint(x: (p0.x + p2.x)/2.0, y: (p0.y + p2.y)/2.0)

    let dx = p2.x - p0.x, dy = p2.y - p0.y
    let len = max(1.0, hypot(dx, dy))
    let ux = -dy / len, uy = dx / len

    let maxOffset = 0.25 * len
    let c = MKMapPoint(x: mid.x + ux * maxOffset * k,
                       y: mid.y + uy * maxOffset * k)
    
    var coords: [CLLocationCoordinate2D] = []
    coords.reserveCapacity(segments + 1)
    for i in 0...segments {
        let t = Double(i) / Double(segments)
        let mt = 1.0 - t
        let x = mt*mt*p0.x + 2*mt*t*c.x + t*t*p2.x
        let y = mt*mt*p0.y + 2*mt*t*c.y + t*t*p2.y
        coords.append(MKMapPoint(x: x, y: y).coordinate)
    }
    return MKPolyline(coordinates: coords, count: coords.count)
}
