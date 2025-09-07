//
//  DriverSettings.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//  

import SwiftUI

struct DriverSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoggedOut = false
    @State private var navigateToPassenger = false
    
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
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack (spacing: 15) {
                NavigationLink(destination: DriverInfoView(), label: {
                    HStack(content: {
                        Text("Driver info")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
                NavigationLink(destination: VehicleInfoView(), label: {
                    HStack(content: {
                        Text("Vehicle info")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
                NavigationLink(destination: AuthenticationSettingsView(), label: {
                    HStack(content: {
                        Text("Authentication Settings")
                            .font(.title2)
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                })
            }
            .foregroundColor(.black)
            .padding(.vertical)
            Spacer()
            Button(action: {
                UserDefaultsManager.shared.setBool(false, forKey: UserDefaultsManager.IS_DRIVER)
                self.navigateToPassenger = true
            }, label: {
                HStack(content: {
                    Spacer()
                    Text("Switch to Customer")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                })
            })
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
            Button(action: {
                UserDefaultsManager.shared.setBool(false, forKey: UserDefaultsManager.IS_LOGGEDIN)
                UserDefaultsManager.shared.setBool(false, forKey: UserDefaultsManager.IS_DRIVER)
                isLoggedOut = true
            }) {
                HStack(content: {
                    Spacer()
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                })
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
        })
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView()
        }
        .navigationDestination(isPresented: $navigateToPassenger) {
            PassengerHomeView()
        }
    }
}

#Preview {
    DriverSettingsView()
}
