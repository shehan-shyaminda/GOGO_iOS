//
//  VehicleDetailsView.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct VehicleDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vehicleInfoVM: DriverInfoViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
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
            Text("Vehicle Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            ScrollView(.vertical, content: {
                if let vehicleImage = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleImage {
                    KFImage(URL(string: vehicleImage))
                        .resizable()
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .placeholder({
                            ProgressView()
                        })
                        .resizable()
                        .frame(maxHeight: 250)
                        .clipped()
                        .padding(.bottom)
                } else {
                    PhotosPicker(selection: $selectedItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                VStack(spacing: 5){
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                        .foregroundStyle(Color.black)
                                    Text("Add Vehicle Image")
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.black)
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(height: 230)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                    )
                    .onChange(of: selectedItem) { newItem in
                        if let newItem {
                            self.vehicleInfoVM.updateFirebaseImages(from: newItem, isRevenueLicense: false, isVehicleImage: true)
                        }
                    }
                }
                VStack(spacing: 15, content: {
                    VStack(content: {
                        HStack(content: {
                            Text("Brand")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleBrand = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleBrand {
                                Text(vehicleBrand)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                    VStack(content: {
                        HStack(content: {
                            Text("Model")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleModel = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleModel {
                                Text(vehicleModel)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                    VStack(content: {
                        HStack(content: {
                            Text("Year of Manufacture")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleYear = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleYear {
                                Text(vehicleYear)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                    VStack(content: {
                        HStack(content: {
                            Text("Seat Count")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleSeats = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleSeats {
                                Text(vehicleSeats)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                    VStack(content: {
                        HStack(content: {
                            Text("Engine Power")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleEngine = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleEngine {
                                Text(vehicleEngine)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                    VStack(content: {
                        HStack(content: {
                            Text("Registration Number")
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        })
                        .padding(.bottom, 2)
                        HStack(content: {
                            if let vehicleRegNum = vehicleInfoVM.driverInfo?.vehicleInfo?.vehicleRegNum {
                                Text(vehicleRegNum)
                                    .fontWeight(.semibold)
                            } else {
                                Text("N/A")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        })
                    })
                })
            })
            Spacer()
            NavigationLink(destination: AddVehicleDetailsView().environmentObject(vehicleInfoVM), label: {
                HStack(content: {
                    Spacer()
                    Text("Update Vehicle Details")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VehicleDetailsView()
}
