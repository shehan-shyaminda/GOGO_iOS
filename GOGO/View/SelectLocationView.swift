//
//  SelectLocationView.swift
//  GOGO
//
//  Created by Snippets on 11/13/24.
//  

import SwiftUI

struct SelectLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationVM: PassengerHomeViewModel
    @State var locationType: LocationType = .DROP
//    let items = ["Colombo, Fort Railway station", "Colombo, Bandaranaike International Airport"]
    @State private var query = ""
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                TextField(locationType == .PICKUP ? "Pickup Location" : "Drop Location", text: $query)
                    .onChange(of: query) { newValue in
                        locationVM.updateQuery(newValue)
                    }
                Spacer()
                Image(systemName: "location.magnifyingglass")
            })
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 3)
            )
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 10)
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(locationVM.results) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                if !item.subtitle.isEmpty {
                                    Text(item.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color(.systemBackground))
                        .onTapGesture {
                            locationVM.mapItem(for: item) { mapItem in
                                if let mapItem = mapItem {
                                    print("Selected Name: \(mapItem.name ?? "")")
                                    print("Description: \(mapItem.description)")
                                    print("Coordinates: \(mapItem.placemark.coordinate.latitude), \(mapItem.placemark.coordinate.longitude)")
                                    
                                    if (locationType == .DROP) {
                                        locationVM.dropLocation = (
                                            name: mapItem.name ?? item.title,
                                            description: mapItem.placemark.title ?? item.subtitle,
                                            coordinate: mapItem.placemark.coordinate
                                        )
                                    } else {
                                        locationVM.pickUpLocation = (
                                            name: mapItem.name ?? item.title,
                                            description: mapItem.placemark.title ?? item.subtitle,
                                            coordinate: mapItem.placemark.coordinate
                                        )
                                    }
                                    if (locationVM.dropLocation != nil && locationVM.pickUpLocation != nil) {
                                        locationVM.fetchGoogleDistance()
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            Button(action: {}) {
                HStack(content: {
                    Spacer()
                    Button("Cancel", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                    .foregroundColor(.black)
                    Spacer()
                })
            }
        })
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

enum LocationType {
  case DROP, PICKUP
}

#Preview {
    SelectLocationView()
}
