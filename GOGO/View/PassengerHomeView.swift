//
//  PassengerHomeView.swift
//  GOGO
//
//  Created by Snippets on 11/7/24.
//

import SwiftUI

struct PassengerHomeView: View {
    @StateObject private var locationVM = PassengerHomeViewModel()
    @State private var isDatePickerPresented = false
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Text("GOGO")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                NavigationLink(destination: PassengerSettingsView(), label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                })
            })
            .padding(.bottom)
            ScrollView(.vertical, showsIndicators: false, content: {
                Image("Banner")
                    .resizable()
                    .aspectRatio(2, contentMode: .fit)
                    .frame(maxHeight: 150)
                    .clipped()
                    .padding(.bottom)
                NavigationLink(destination: SelectLocationView(locationType: .PICKUP).environmentObject(locationVM), label: {
                    HStack(content: {
                        if let location = locationVM.pickUpLocation {
                            Text(location.name)
                                .foregroundStyle(Color.black)
                        } else {
                            Text("PickUp Locaiton")
                                .foregroundStyle(Color.black)
                        }
                        Spacer()
                        Image(systemName: "location.magnifyingglass")
                            .foregroundStyle(Color.black)
                    })
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                NavigationLink(destination: SelectLocationView(locationType: .DROP).environmentObject(locationVM), label: {
                    HStack(content: {
                        if let location = locationVM.dropLocation {
                            Text(location.name)
                                .foregroundStyle(Color.black)
                        } else {
                            Text("Drop Locaiton")
                                .foregroundStyle(Color.black)
                        }
                        Spacer()
                        Image(systemName: "location.magnifyingglass")
                            .foregroundStyle(Color.black)
                    })
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                HStack(content: {
                    Text(locationVM.selectedDate.fullDateString)
                    Spacer()
                    Image(systemName: "timer")
                })
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 3)
                )
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    isDatePickerPresented = true
                }
                
                if let pickup = locationVM.pickUpLocation, let drop = locationVM.dropLocation {
                    RouteMapView(
                        source: .constant(pickup.coordinate),
                        destination: .constant(drop.coordinate),
                        style: .curved(amount: 0.6)
                    )
                    .frame(height: 270)
                    .cornerRadius(12)
                    .padding(.top, 10)
                }
                VStack(spacing: 10) {
                    ForEach(locationVM.vehicles.reversed(), id: \.id) { vehicle in
                        VehicleRowView(
                            vehicle: vehicle,
                            isSelected: locationVM.selectedVehichleType == vehicle.id,
                            tripDuration: locationVM.tripDuration,
                            tripDistance: locationVM.tripDistance
                        )
                        .onTapGesture {
                            locationVM.selectedVehichleType = vehicle.id
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                Spacer()
            })
            Button(action: {
                locationVM.makeTripBooking()
            }, label: {
                HStack(content: {
                    Spacer()
                    Text("Book Hire")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                })
            })
            .disabled(!locationVM.checkProceedWithBook())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
        })
        .padding(.horizontal)
        .sheet(isPresented: $isDatePickerPresented) {
            DatePickerDialog(selectedDate: $locationVM.selectedDate, showPicker: $isDatePickerPresented)
                .presentationDetents([.medium])
                .presentationCompactAdaptation(.sheet)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $locationVM.navigateToMapView) {
            if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.PASSENGER_TRIP_STARTED)) {
                PassengerMapView(tripId: UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.PASSENGER_TRIP_ID))
            }
        }
    }
}

#Preview {
    PassengerHomeView()
}

struct DatePickerDialog: View {
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .onTapGesture {
                showPicker = false
            }
        }
        .padding()
        .preferredColorScheme(.light)
        .presentationDetents([.fraction(0.2)])
    }
}

struct VehicleRowView: View {
    let vehicle: VehicleTypes
    let isSelected: Bool
    let tripDuration: String?
    let tripDistance: Double

    var body: some View {
        HStack(content: {
            Image(vehicle.icon)
                .resizable()
                .frame(width: 50, height:  50)
                .padding(.trailing, 20)
            VStack(alignment: .leading, content: {
                Text(vehicle.name)
                    .font(.title3)
                if let duration = tripDuration {
                    Text("Estimated Time : \(duration)")
                        .font(.caption)
                } else {
                    Text("Estimated Time : Calculating...")
                        .font(.caption)
                }
            })
            Spacer(minLength: 0)
            VStack(content: {
                Text("$\(vehicle.tripCharge, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(tripDistance, specifier: "%.1f") Km")
                    .font(.callout)
            })
        })
        .padding(.horizontal, 20)
        .padding(.vertical)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 3)
        )
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
