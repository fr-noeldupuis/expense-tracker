//
//  AccountListView.swift
//  expense-tracker
//
//  Created by Noel Dupuis on 23/10/2024.
//

import SwiftUI
import SwiftData

struct AccountListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var accounts: [AccountModel]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) { account in
                    Text(account.name)
                }
                .onDelete() {
                    indexes in
                    for index in indexes {
                        deleteAccount(account: accounts[index])
                    }
                    
                }
            }
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button {
                    addAccount()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func addAccount() {
        let account = AccountModel(name: "Test", initialBalance: 0, iconString: "questionmark")
        modelContext.insert(account)
    }
    
    func deleteAccount(account: AccountModel) {
        modelContext.delete(account)
    }
}

#Preview {
    AccountListView()
        .modelContainer(for: [AccountModel.self], inMemory: true)
}
