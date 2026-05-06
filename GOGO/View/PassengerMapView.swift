//
//  PassengerMapView.swift
//  GOGO
//
//  Created by Snippets on 11/13/24.
//

import SwiftUI
import MapKit

struct PassengerMapView: View {
    @StateObject private var passengerMapVM: PassengerMapViewModel
    @StateObject private var passengerInfoVM = PassengerInfoViewModel()
    @State private var makeTripEnd: Bool = false
    @State private var rating: Int = 0
    
    @State private var selectedPayType: Int = 0
    let payTypes = ["Cash", "•••• 9432"]
    let payTypesImages = ["cash", "card"]
    
    init(tripId: String) {
        _passengerMapVM = StateObject(wrappedValue: PassengerMapViewModel(tripId: tripId))
    }
    
    var body: some View {
        ZStack(content: {
            if (passengerMapVM.tripModel?.tripStatus == 6) {
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
                            self.passengerMapVM.updateTrip()
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
            if (passengerMapVM.tripModel?.tripStatus == 4 || passengerMapVM.tripModel?.tripStatus == 5) {
                Group {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    VStack(spacing: 5) {
                        Text("$ 12.00")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Your trip is complete. Please proceed to payment to finalize your journey.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        VStack(content: {
                            let cards = passengerInfoVM.passengerInfo?.passengerBanks ?? []
                            VStack {
                                Button(action: {
                                    selectedPayType = -1
                                }) {
                                    HStack {
                                        Image("cash")
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 40)
                                            .clipped()
                                        Text("Cash")
                                            .foregroundStyle(Color.black)
                                        Spacer()
                                        if selectedPayType == -1 {
                                            Image("select")
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal)

                                if !cards.isEmpty {
                                    ForEach(cards.indices, id: \.self) { index in
                                        Button(action: {
                                            selectedPayType = index
                                        }) {
                                            HStack {
                                                Image("card")
                                                    .resizable()
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .frame(width: 40)
                                                    .clipped()
                                                Text(cards[index].accountNumber.maskedAccountNumber())
                                                    .foregroundStyle(Color.black)
                                                Spacer()
                                                if selectedPayType == index {
                                                    Image("select")
                                                }
                                            }
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        })
                        .padding(.vertical)
                        Button(action: {
                            self.passengerMapVM.updateTrip()
                        }, label: {
                            HStack(content: {
                                Spacer()
                                if (passengerMapVM.tripModel?.tripStatus == 4) {
                                    Text("Pay")
                                        .foregroundColor(.white)
                                        .padding()
                                } else {
                                    ProgressView()
                                        .foregroundColor(.white)
                                        .padding()
                                }
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
                if let trip = passengerMapVM.tripModel {
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
                            if let status = passengerMapVM.tripModel?.tripStatus,
                               status != 0 && status != 1 && status != 2 {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        let sms = "sms:\(+94777123456))&body=\(passengerMapVM.getEmergencyMessage())"
                                        if let urlString = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                           let url = URL(string: urlString) {
                                            if UIApplication.shared.canOpenURL(url) {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                    }, label: {
                                        HStack(content: {
                                            Image(systemName: "figure.wave.circle.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.white)
                                                .padding(1)
                                                .background(Color.black.opacity(0.7))
                                                .clipShape(Circle())
                                        })
                                    })
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    passengerMapVM.openGoogleMapsNavigation()
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
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("Loading trip...")
                }
                if passengerMapVM.tripModel?.tripStatus == 0 ||
                    passengerMapVM.tripModel?.tripStatus == 1 ||
                    passengerMapVM.tripModel?.tripStatus == 2 ||
                    passengerMapVM.tripModel?.tripStatus == 3 {
                    ZStack {
                        Rectangle()
                            .frame(height: 80)
                            .foregroundColor(.white)
                        HStack(content: {
                            Spacer()
                            if let trip = passengerMapVM.tripModel {
                                if (trip.tripStatus == 0) {
                                    Text("Waiting for Driver...")
                                        .foregroundColor(.black)
                                        .padding()
                                } else if (trip.tripStatus == 1) {
                                    Text("Driver is on the Way...")
                                        .foregroundColor(.black)
                                        .padding()
                                } else if (trip.tripStatus == 2) {
                                    Text("Driver Arrived...")
                                        .foregroundColor(.black)
                                        .padding()
                                }else if (trip.tripStatus == 3) {
                                    Text("Ride Started...")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }
                            ProgressView()
                            Spacer()
                        })
                    }
                }
            })
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
        })
        .onReceive(passengerMapVM.$tripModel.compactMap { $0?.passengerTripCompleted == 1 }) { status in
            if status {
                self.makeTripEnd = true
            }
        }
        .navigationDestination(isPresented: $makeTripEnd) {
            PassengerHomeView()
        }
    }
}

//TRIP STATUS
//0 - Trip Created - passenger loading customer - driver will see listed as new trip
//1 - Driver Assigned - passenger show driver is on the way - driver map view with pickup location
//2 - Driver Assigned - passenger show driver arrived - driver map view with pickup location with start ride button
//3 - Ride Started - passenger show ride started - driver map view with drop location
//4 - Ride Completed (Pending Rating) - passenger show payment screen to pay - driver show accept money with disabled button
//5 - Ride Completed (Pending Rating) - passenger show payment screen waiting confirm driver - driver show accept money with enabled button
//6 - Rating Completed - passenger show Rating screen  - driver show Rating screen
