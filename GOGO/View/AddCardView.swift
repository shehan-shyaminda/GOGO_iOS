//
//  AddCardView.swift
//  GOGO
//
//  Created by Snippets on 11/14/24.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var passengerInfoVM: PassengerInfoViewModel
    @State private var isSuccess: Bool = false
    
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
            Text("Add new Card")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack(spacing: 15, content: {
                TextField("Name on Card", text: $passengerInfoVM.accountName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Card Number", text: $passengerInfoVM.accountNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Bank Name", text: $passengerInfoVM.bankName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Branch Name", text: $passengerInfoVM.branchName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            Spacer()
            Button(action: {
                if passengerInfoVM.validateValue() {
                    let newBank = PassengerBank(accountName:  passengerInfoVM.accountName,
                                                accountNumber: passengerInfoVM.accountNumber,
                                                bankName: passengerInfoVM.bankName,
                                                branchName: passengerInfoVM.branchName)
                    self.passengerInfoVM.addNewPassengerBank(bank: newBank.toDict(), completion: { it in
                        self.isSuccess = it
                    })
                }
            }, label: {
                HStack(content: {
                    Spacer()
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                })
            })
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
        })
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .onChange(of: isSuccess, perform: { it in
            if it {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}
