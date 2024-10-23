import SwiftUI
import SwiftData

struct AccountListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var accounts: [AccountModel]
    
    @State private var selectedAccount: AccountModel? = nil
    @State private var isShowingEditForm = false

    var body: some View {
        NavigationView {
            List {
                ForEach(accounts, id: \.id) { account in
                    AccountListRow(account: account)
                        .swipeActions {
                            Button("", systemImage: "trash", role: .destructive, action: {
                                deleteAccount(account: account)
                            })
                            Button("", systemImage: "pencil") {
                                selectedAccount = account
                                isShowingEditForm = true
                            }
                            .tint(.blue)
                                
                        }
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteAccount(account: accounts[index])
                    }
                }
            }
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                NavigationLink(destination: AccountFormView()) {
                    Image(systemName: "plus")
                }
            }
        }
        // Present the form for editing
        .sheet(item: $selectedAccount) { accountToEdit in
            NavigationView {
                AccountFormView(accountToEdit: accountToEdit)
            }
        }
    }
    
    func deleteAccount(account: AccountModel) {
        modelContext.delete(account)
        try? modelContext.save() // Ensure the context is saved after deletion
    }
}

#Preview {
    AccountListView()
        .modelContainer(for: [AccountModel.self], inMemory: true)
}
