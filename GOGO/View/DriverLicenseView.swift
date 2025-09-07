//
//  DriverLicenseView.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct DriverLicenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var driverInfoVM: DriverInfoViewModel
    
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
            Text("Driver License")
                .font(.largeTitle)
                .fontWeight(.bold)
            if let license = driverInfoVM.driverInfo?.driverLicense,
               !license.isEmpty,
               let url = URL(string: license) {
                KFImage(url)
                    .resizable()
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(maxHeight: 250)
                    .clipped()
                    .cornerRadius(15)
            } else {
                Image("placeholderImage")
                    .resizable()
                    .frame(maxHeight: 250)
                    .clipped()
                    .cornerRadius(15)
            }
            Spacer()
            PhotosPicker(selection: $selectedItem,
                         matching: .images,
                         photoLibrary: .shared()) {
                HStack {
                    Spacer()
                    Text("Update License")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
            .onChange(of: selectedItem) { newItem in
                if let newItem {
                    self.driverInfoVM.updateFirebaseImages(from: newItem, isRevenueLicense: false, isVehicleImage: false)
                }
            }
        })
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
