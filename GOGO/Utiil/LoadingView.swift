//
//  LoadingView.swift
//  GOGO
//
//  Created by Snippets on 8/19/25.
//  

import SwiftUI

struct LoadingView: View {
    var message: String? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                if let message = message {
                    Text(message)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(24)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
