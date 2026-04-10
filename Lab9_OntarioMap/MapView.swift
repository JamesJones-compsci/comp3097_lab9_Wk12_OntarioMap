//
//  MapView.swift
//  Lab9_OntarioMap
//
//  Created by Tech on 2026-04-09.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var locations: [CLLocationCoordinate2D]
    @Binding var routes: [MKRoute]
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        // Add pins
        for loc in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            uiView.addAnnotation(annotation)
        }
        
        // Draw triangle
        if locations.count == 3 {
            let polygon = MKPolygon(coordinates: locations, count: locations.count)
            uiView.addOverlay(polygon)
        }
        
        // Draw routes
        for route in routes {
            uiView.addOverlay(route.polyline)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // MARK: - Tap Handling
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let mapView = parent.mapView
            let point = gesture.location(in: mapView)
            let coord = mapView.convert(point, toCoordinateFrom: mapView)
            
            // Remove if close
            if let index = parent.locations.firstIndex(where: {
                CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                .distance(from: CLLocation(latitude: coord.latitude, longitude: coord.longitude)) < 100
            }) {
                parent.locations.remove(at: index)
            } else if parent.locations.count < 3 {
                parent.locations.append(coord)
            }
        }
        
        // MARK: - Draw Triangle & Routes
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            // Triangle
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
                renderer.strokeColor = UIColor.green
                renderer.lineWidth = 3
                return renderer
            }
            
            // Route lines
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 4
                return renderer
            }
            
            return MKOverlayRenderer()
        }
    }
}
