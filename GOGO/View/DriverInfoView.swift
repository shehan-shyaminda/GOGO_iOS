//
//  DriverInfoView.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//  

import SwiftUI

struct DriverInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var driverInfoVM = DriverInfoViewModel()
    
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
            .foregroundStyle(Color.black)
            Text("Driver info")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack (spacing: 15) {
                NavigationLink(destination: DriverLicenseView().environmentObject(driverInfoVM), label: {
                    HStack(content: {
                        Text("Driver info")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
                NavigationLink(destination: DriverBankDetailsView().environmentObject(driverInfoVM), label: {
                    HStack(content: {
                        Text("Bank Details")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
            }
            .foregroundStyle(Color.black)
            .padding(.vertical)
            Spacer()
        })
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DriverInfoView()
}
