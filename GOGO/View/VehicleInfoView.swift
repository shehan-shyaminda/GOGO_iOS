//
//  VehicleInfoView.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//  

import SwiftUI

struct VehicleInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vehicleInfoVM = DriverInfoViewModel()
    
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
            Text("Vehicle info")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack (spacing: 15) {
                NavigationLink(destination: RevenueLicenseView().environmentObject(vehicleInfoVM), label: {
                    HStack(content: {
                        Text("Revenue License")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
                NavigationLink(destination: VehicleDetailsView().environmentObject(vehicleInfoVM), label: {
                    HStack(content: {
                        Text("Vehicle Details")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
            }
            .foregroundColor(.black)
            .padding(.vertical)
            Spacer()
        })
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VehicleInfoView()
}
