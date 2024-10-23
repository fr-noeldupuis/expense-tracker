//
//  AccountListRow.swift
//  expense-tracker
//
//  Created by Noel Dupuis on 23/10/2024.
//

import SwiftUI

struct AccountListRow: View {
    let account: AccountModel
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accentColor.opacity(0.7))
                    .frame(width: 56, height: 48)
                Image(systemName: account.iconString)
                    .frame(width: 48, height: 48)
                    .foregroundColor(.white)
            }
            Text(account.name)
                .font(.headline)
            
            Spacer()
            
            Text(account.initialBalance, format: .currency(code: "EUR"))
        }
    }
}

#Preview {
    AccountListRow(account: AccountModel(name: "Test", initialBalance: 0, iconString: "questionmark"))
}
