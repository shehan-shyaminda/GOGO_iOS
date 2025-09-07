//
//  AddVehicleDetailsView.swift
//  GOGO
//
//  Created by Snippets on 9/4/25.
//

import Foundation
import SwiftUI

struct AddVehicleDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var driverInfoVM: DriverInfoViewModel
    @State private var isSuccess: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack(content: {
                    Image(systemName: "chevron.left")
                    Spacer()
                })
            })
            .foregroundColor(.black)
            Text("Update Vehicle Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack(spacing: 15, content: {
                HStack {
                    Picker(selection: $driverInfoVM.selectedOption, label: Text("Select Vehicle Type")) {
                        ForEach(driverInfoVM.typeOptions, id: \.self) { option in
                            if option == "tuk" {
                                Text("Tuk").tag(option)
                            } else if option == "car" {
                                Text("Car").tag(option)
                            } else {
                                Text("Van").tag(option)
                            }
                                
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 3)
                )
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 50)
                TextField("Vehicle Brand", text: $driverInfoVM.brand)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Vehicle Model", text: $driverInfoVM.model)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Year of Manufacturer", text: $driverInfoVM.yom)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Registration Number", text: $driverInfoVM.regNum)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Seat Count", text: $driverInfoVM.seatCount)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Engine Power", text: $driverInfoVM.enginePower)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                })
            Spacer()
            Button(action: {
                if driverInfoVM.validateVehicle() {
                    let vehicle = VehicleInfo(vehicleType: driverInfoVM.selectedOption,
                                              vehicleBrand: driverInfoVM.brand,
                                              vehicleModel: driverInfoVM.model,
                                              vehicleRegNum: driverInfoVM.regNum,
                                              vehicleYear: driverInfoVM.yom,
                                              vehicleSeats: driverInfoVM.seatCount,
                                              vehicleEngine: "\(driverInfoVM.enginePower) cc")
                    self.driverInfoVM.updateVehicle(vehicle: vehicle.toDict(), completion: { it in
                        self.isSuccess = it
                    })
                }
            }, label: {
                HStack(content: {
                    Spacer()
                    Text("Submit")
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
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .onChange(of: isSuccess, perform: { it in
            if it {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}
