//
//  LoginView.swift
//  GOGO
//
//  Created by Snippets on 11/7/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authVM = LoginViewModel()
    @State private var isRegister: Bool = false
    @State private var isNavigate: Bool = false

    var termsConditions: AttributedString {
        var text = AttributedString("By clicking Next, you agree with our\nTerms and Conditions and Privacy Policy")
        
        if let termsRange = text.range(of: "Terms and Conditions") {
            text[termsRange].font = .body.bold()
        }
        
        if let privacyRange = text.range(of: "Privacy Policy") {
            text[privacyRange].font = .body.bold()
        }
        
        return text
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, content: {
                HStack(content: {
                    Text(isRegister ? "Join us today!\nWe’re excited to have you." : "Welcome back! Glad\nto see you, Again!")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                })
                .padding(.top, 45)
                TextField("Email Address", text: $authVM.logEmail)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                SecureField("Password", text: $authVM.logPassword)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                HStack(content: {
                    Spacer()
                    Text(termsConditions)
                        .multilineTextAlignment(.center)
                    Spacer()
                })
                Button(action: {
                    if isRegister {
                        authVM.userRegister()
                    } else {
                        authVM.userLogin()
                    }
                }, label: {
                    Spacer()
                    Text(isRegister ? "Sign Up" : "Continue")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                )
                .padding(.horizontal)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation{
                            self.isRegister.toggle()
                        }
                    }, label: {
                        Text(isRegister ? "Already have an account? Login" : "Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .padding()
                    })
                    Spacer()
                }
                .padding(.bottom, 10)
            })
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $authVM.jumpToMain, destination: {
                PassengerHomeView()
            })
            .onChange(of: authVM.isRegCompleted, perform: { newValue in
                if newValue {
                    self.isRegister = false
                }
            })

            if authVM.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    LoginView()
}
