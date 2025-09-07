//
//  SwiftUIView.swift
//  GOGO
//
//  Created by Snippets on 11/14/24.
//  

import SwiftUI

struct PassengerBankDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var passengerInfoVM = PassengerInfoViewModel()
    
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
            ScrollView(showsIndicators: false, content: {
                if let passengerBanks = passengerInfoVM.passengerInfo?.passengerBanks {
                    ForEach(passengerBanks, id: \.id) { bank in
                        ZStack {
                            Image("BC")
                                .resizable()
                                .frame(maxHeight: 230)
                                .clipped()
                            VStack(content: {
                                VStack(content: {
                                    HStack(content: {
                                        Spacer()
                                        Text(bank.bankName)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    })
                                    .padding(.bottom, 2)
                                    HStack(content: {
                                        Spacer()
                                        Text(bank.branchName)
                                            .font(.callout)
                                            .foregroundColor(.white)
                                    })
                                })
                                .padding(.bottom, 25)
                                VStack(content: {
                                    HStack(content: {
                                        Text(bank.accountNumber)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Spacer()
                                    })
                                    .padding(.bottom, 2)
                                    HStack(content: {
                                        Text(bank.accountName)
                                            .font(.callout)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Button(action: {
                                            passengerInfoVM.removePassengerBank(bankId: bank.id)
                                        }, label: {
                                            Image(systemName: "xmark.bin.fill")
                                                .foregroundStyle(Color.black)
                                        })
                                    })
                                })
                                .padding(.top, 25)
                            })
                            .padding()
                        }
                    }
                }
                NavigationLink(destination: AddCardView().environmentObject(passengerInfoVM), label: {
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
            })
            Spacer()
        })
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PassengerBankDetailsView()
}
