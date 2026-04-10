//
//  ContentView.swift
//  Lab9_OntarioMap
//
//  Created by Tech on 2026-04-09.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var locations: [CLLocationCoordinate2D] = []
    @State private var routes: [MKRoute] = []
    
    var body: some View {
        ZStack {
            
            MapView(locations: $locations, routes: $routes)
                .edgesIgnoringSafeArea(.all)
            
            if locations.count == 3 {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("A → B: \(Int(distanceBetween(locations[0], locations[1]))) m")
                        Text("B → C: \(Int(distanceBetween(locations[1], locations[2]))) m")
                        Text("C → A: \(Int(distanceBetween(locations[2], locations[0]))) m")
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 70)
                }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    
                    // ROUTE BUTTON
                    Button(action: calculateRoutes) {
                        Text("Show Route")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // RESET BUTTON
                    Button(action: resetMap) {
                        Text("Reset")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Route Calculation
    private func calculateRoutes() {
        guard locations.count == 3 else { return }
        
        routes.removeAll()
        
        let sequence = [0,1,2,0]
        var newRoutes: [MKRoute] = []
        let group = DispatchGroup()
        
        for i in 0..<sequence.count-1 {
            group.enter()
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[sequence[i]]))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: locations[sequence[i+1]]))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    newRoutes.append(route)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            routes = newRoutes
        }
    }
    
    private func resetMap() {
        locations.removeAll()
        routes.removeAll()
    }
    
    private func distanceBetween(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        let locA = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let locB = CLLocation(latitude: b.latitude, longitude: b.longitude)
        return locA.distance(from: locB) // meters
    }
    
}
