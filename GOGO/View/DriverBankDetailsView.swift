//
//  BankDetailsView.swift
//  GOGO
//
//  Created by Snippets on 11/10/24.
//

import SwiftUI

struct DriverBankDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var driverInfoVM: DriverInfoViewModel
    
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
            Text("Bank Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            if driverInfoVM.driverInfo?.bankInfo != nil {
                ZStack{
                    Image("BC")
                        .resizable()
                        .frame(maxHeight: 230)
                        .clipped()
                    VStack(content: {
                        VStack(content: {
                            HStack(content: {
                                Spacer()
                                if let driverBankName = driverInfoVM.driverInfo?.bankInfo?.driverBankName {
                                    Text(driverBankName)
                                        .font(.callout)
                                        .foregroundColor(.white)
                                } else {
                                    Text("N/A")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                            })
                            .padding(.bottom, 2)
                            HStack(content: {
                                Spacer()
                                if let driverBankBranch = driverInfoVM.driverInfo?.bankInfo?.driverBankBranch {
                                    Text(driverBankBranch)
                                        .font(.callout)
                                        .foregroundColor(.white)
                                } else {
                                    Text("N/A")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                            })
                        })
                        .padding(.bottom, 25)
                        VStack(content: {
                            HStack(content: {
                                if let driverBankAccount = driverInfoVM.driverInfo?.bankInfo?.driverBankAccount {
                                    Text(driverBankAccount)
                                        .font(.callout)
                                        .foregroundColor(.white)
                                } else {
                                    Text("N/A")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            })
                            .padding(.bottom, 2)
                            HStack(content: {
                                if let driverName = driverInfoVM.driverInfo?.bankInfo?.driverName {
                                    Text(driverName)
                                        .font(.callout)
                                        .foregroundColor(.white)
                                } else {
                                    Text("N/A")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            })
                        })
                        .padding(.top, 25)
                    })
                    .padding()
                }
            } else {
                NavigationLink(destination: DriverAddCardView().environmentObject(driverInfoVM), label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 5){
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .foregroundStyle(Color.black)
                                Text("Add New Card")
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
                })
            }
            Spacer()
        })
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DriverBankDetailsView()
}
