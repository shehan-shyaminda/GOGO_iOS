//
//  DriverHomeView.swift
//  GOGO
//
//  Created by Snippets on 11/7/24.
//

import SwiftUI

struct DriverHomeView: View {
    @StateObject private var driverHomeVM = DriverHomeViewModel()
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Text("Bookings")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                NavigationLink(destination: DriverSettingsView(), label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                })
            })
            .padding(.bottom)
            if let trips = driverHomeVM.avialableTrips, trips.count > 0 {
                ScrollView(showsIndicators: false, content: {
                    LazyVStack(content: {
                        ForEach(trips.reversed(), id: \.id) { trip in
                                VStack(content: {
                                    HStack(content: {
                                        Text("$ \(trip.tripCharge, specifier: "%.2f")")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Spacer()
                                        HStack(content: {
                                            Image(systemName: "phone.connection.fill")
                                                .foregroundStyle(Color.blue)
                                            Text("Get in contact")
                                                .foregroundStyle(Color.blue)
                                        })
                                        .onTapGesture {
                                            UIApplication.shared.open(URL(string: "tel:0777123456")!)
                                        }
                                    })
                                    .padding(.bottom)
                                    HStack(content: {
                                        Image(systemName: "circle.fill")
                                        Text(trip.pickDescription)
                                        Spacer()
                                    })
                                    HStack(content: {
                                        Image(systemName: "arrowshape.down.fill")
                                        Spacer()
                                    })
                                    .padding(.vertical, 2)
                                    HStack(content: {
                                        Image(systemName: "app.fill")
                                        Text(trip.dropDescription)
                                        Spacer()
                                    })
                                    .padding(.bottom)
                                    HStack(content: {
                                        Image(systemName: "timer")
                                        Text("On \(Date(timeIntervalSince1970: trip.tripTimeStamp).dayWithSuffixAndMonth)")
                                        Spacer()
                                    })
                                    .padding(.bottom)
                                    Button(action: {
                                        driverHomeVM.updateTrip(tripId: trip.id, status: 1)
                                    }, label: {
                                        HStack(content: {
                                            Spacer()
                                            Text("Accept")
                                                .foregroundColor(.white)
                                                .padding()
                                            Spacer()
                                        })
                                    })
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.black)
                                    )
                                })
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                                )
                        }
                    })
                })
            } else {
                Text("No Bookings Available")
                    .font(.title2)
                    .foregroundStyle(Color.gray)
            }
            Spacer()
        })
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $driverHomeVM.navigateToDiverMap){
            if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.DRIVER_TRIP_STARTED)) {
                DriverMapView(tripId: UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.DRIVER_TRIP_ID))
            }
        }
    }
}

#Preview {
    DriverHomeView()
}
