//
//  DriverMapView.swift
//  GOGO
//
//  Created by Snippets on 11/9/24.
//

import SwiftUI
import MapKit

struct DriverMapView: View {
    @StateObject private var driverMapVM: DriverMapViewModel
    @State private var makeTripEnd: Bool = false
    @State private var rating: Int = 0
    
    init(tripId: String) {
        _driverMapVM = StateObject(wrappedValue: DriverMapViewModel(tripId: tripId))
    }
    
    var body: some View {
        ZStack(content: {
            if (driverMapVM.tripModel?.tripStatus == 4 || driverMapVM.tripModel?.tripStatus == 5) {
                Group {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    VStack(spacing: 5) {
                        Text("$ 12.00")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Your trip is complete. Please collect your cash to finalize your journey.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Button(action: {
                            self.driverMapVM.updateTrip()
                        }, label: {
                            HStack(content: {
                                Spacer()
                                Text("Cash Collected")
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            })
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.top, 10)
                        .disabled(driverMapVM.tripModel?.tripStatus == 4)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                }
                .zIndex(1)
            }
            if (driverMapVM.tripModel?.tripStatus == 6) {
                Group {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    VStack(spacing: 5) {
                        Text("How was your ride?")
                            .font(.title3)
                        Text("Your feedback will help improve\ndriving experience")
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                        HStack(content: {
                            ForEach(0..<5) { index in
                                Button(action: {
                                    rating = index + 1
                                }, label: {
                                    Image(systemName: index < rating ? "star.fill" : "star")
                                        .foregroundColor(index < rating ? .yellow : .gray)
                                        .font(.title)
                                })
                                .padding(.vertical, 10)
                            }
                        })
                        Button(action: {
                            self.driverMapVM.updateTrip()
                        }, label: {
                            HStack(content: {
                                Spacer()
                                Text("Done")
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            })
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                }
                .zIndex(1)
            }
            VStack(spacing: 0,content: {
                if let trip = driverMapVM.tripModel {
                    let sourceCoordinate = CLLocationCoordinate2D(
                        latitude: trip.pickLatitude,
                        longitude: trip.pickLongitude
                    )
                    
                    let destinationCoordinate = CLLocationCoordinate2D(
                        latitude: trip.dropLatitude,
                        longitude: trip.dropLongitude
                    )
                    ZStack {
                        RouteMapView(
                            source: .constant(sourceCoordinate),
                            destination: .constant(destinationCoordinate),
                            style: .curved(amount: 0.6)
                        )
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    driverMapVM.openGoogleMapsNavigation()
                                }, label: {
                                    HStack(content: {
                                        Image(systemName: "car.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(1)
                                            .background(Color.black.opacity(0.7))
                                            .clipShape(Circle())
                                    })
                                })
                                .padding()
                            }
                        }
                    }
                } else {
                    Text("Loading trip...")
                }
                if driverMapVM.tripModel?.tripStatus == 1 ||
                    driverMapVM.tripModel?.tripStatus == 2 ||
                    driverMapVM.tripModel?.tripStatus == 3 {
                    ZStack {
                        Rectangle()
                            .frame(height: 100)
                            .foregroundColor(.white)
                        Button(action: {
                            self.driverMapVM.updateTrip()
                        }, label: {
                            HStack(content: {
                                Spacer()
                                if let trip = driverMapVM.tripModel {
                                    if (trip.tripStatus == 1) {
                                        Text("Mark As Arrived")
                                            .foregroundColor(.white)
                                            .padding()
                                    } else if (trip.tripStatus == 2) {
                                        Text("Mark As Picked")
                                            .foregroundColor(.white)
                                            .padding()
                                    }  else if (trip.tripStatus == 3) {
                                        Text("End Trip")
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                Spacer()
                            })
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.horizontal, 20)
                    }
                }
            })
            .edgesIgnoringSafeArea(.all)
        })
        .navigationBarBackButtonHidden(true)
        .onReceive(driverMapVM.$tripModel.compactMap { $0?.driverTripCompleted == 1 }) { status in
            if status {
                self.makeTripEnd = true
            }
        }
        .navigationDestination(isPresented: $makeTripEnd) {
            DriverHomeView()
        }
    }
}
