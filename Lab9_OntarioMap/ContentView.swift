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
            
            VStack {
                Spacer()
                
                Button(action: calculateRoutes) {
                    Text("Show Route A → B → C → A")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
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
        
        for i in 0..<sequence.count-1 {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[sequence[i]]))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: locations[sequence[i+1]]))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    DispatchQueue.main.async {
                        routes.append(route)
                    }
                }
            }
        }
    }
}
