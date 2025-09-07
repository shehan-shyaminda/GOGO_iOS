//
//  PassengerSettingsView.swift
//  GOGO
//
//  Created by Snippets on 11/14/24.
//  

import SwiftUI

struct PassengerSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoggedOut = false
    @State private var navigateToDriver = false
    
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
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack (spacing: 15) {
                NavigationLink(destination: PassengerBankDetailsView(), label: {
                    HStack(content: {
                        Text("Manage Payment Info")
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
                UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.IS_DRIVER)
                self.navigateToDriver = true
            }, label: {
                HStack(content: {
                    Spacer()
                    Text("Switch to Driver")
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
        .navigationDestination(isPresented: $navigateToDriver) {
            DriverHomeView()
        }
    }
}

#Preview {
    PassengerSettingsView()
}
