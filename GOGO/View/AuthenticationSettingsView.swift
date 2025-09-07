//
//  AuthenticationSettingsView.swift
//  GOGO
//
//  Created by Snippets on 9/5/25.
//

import Foundation
import SwiftUI

struct AuthenticationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var useFaceID: Bool = UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_FACEID_CHECK)
    
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
            Text("Authentication Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                Toggle("Enable Face ID / Touch ID", isOn: $useFaceID)
                    .fontWeight(.semibold)
                    .onChange(of: useFaceID) { newValue in
                        UserDefaultsManager.shared.setBool(newValue, forKey: UserDefaultsManager.IS_FACEID_CHECK)
                    }
            }
            Spacer()
        })
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AuthenticationSettingsView()
}
