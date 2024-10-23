import SwiftUI

struct AccountFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var initialBalance: String? // Use String for initial balance to handle empty state
    @State private var selectedIcon: String

    var accountToEdit: AccountModel?

    // Initialize with optional account data for editing
    init(accountToEdit: AccountModel? = nil) {
        self.accountToEdit = accountToEdit
        _name = State(initialValue: accountToEdit?.name ?? "")
        _initialBalance = State(initialValue: accountToEdit?.initialBalance != nil ? String(accountToEdit!.initialBalance) : "")
        _selectedIcon = State(initialValue: accountToEdit?.iconString ?? "questionmark")
    }

    let sfSymbols = [
        "star", "heart", "bolt", "cloud", "flame", "moon", "sun.max", "cart", "bookmark", "bell",
        "flag", "gift", "house", "pencil", "clock", "folder", "gear", "person", "car", "bicycle",
        "airplane", "scissors", "calendar", "gamecontroller", "graduationcap", "lock", "key", "map",
        "paintbrush", "camera", "music.note", "globe", "magnifyingglass", "leaf", "doc",
        "printer", "trash", "phone", "message", "envelope", "cart.fill", "bag.fill",
        "cup.and.saucer.fill", "wrench.and.screwdriver.fill", "hammer.fill", "shield.fill",
        "antenna.radiowaves.left.and.right", "questionmark", "briefcase.fill", "bubble.right",
        "cart.badge.plus", "cart.badge.minus", "bell.slash", "wifi", "tv", "car.fill", "creditcard",
        "envelope.fill", "eye", "eyeglasses", "eyedropper", "binoculars.fill", "face.smiling",
        "puzzlepiece", "house.fill", "homepod.fill", "key.fill", "map.fill", "map.circle",
        "bell.badge.fill", "trash.circle", "arrow.up", "arrow.down", "arrow.left", "arrow.right",
        "paperplane", "paperclip", "paperplane.fill", "suit.heart.fill", "suit.club.fill",
        "suit.spade.fill", "suit.diamond.fill", "brain.head.profile", "battery.100", "battery.25",
        "hand.raised", "hands.sparkles", "leaf.fill", "tortoise", "hare.fill", "flame.fill",
        "moon.fill", "sun.max.fill", "gearshape.fill", "gearshape.2.fill", "clock.fill", "timer",
        "stopwatch.fill", "hourglass.tophalf.fill", "sun.dust.fill", "cloud.drizzle.fill",
        "cloud.sun.fill", "cloud.moon.fill", "umbrella.fill", "snow", "thermometer", "lightbulb.fill",
        "bolt.fill", "hare", "bicycle.circle.fill", "ant.fill", "tropicalstorm", "bolt.slash.fill",
        "tornado", "drop.fill", "fanblades.fill", "circle", "square",
        "triangle.fill", "hexagon.fill", "octagon.fill", "sparkles", "sparkles.rectangle.stack.fill",
        "cloud.rain.fill", "cloud.snow.fill", "camera.fill", "tv.fill", "phone.fill",
        "video.fill", "waveform.path.ecg", "ear", "megaphone.fill", "speaker.fill", "guitars",
        "music.mic", "building.columns.fill", "star.fill", "trophy.fill", "medal.fill",
        "wand.and.stars", "books.vertical.fill", "globe.europe.africa.fill", "camera.aperture",
        "rectangle.and.pencil.and.ellipsis"
    ]

    let rows = [
        GridItem(.adaptive(minimum: 50)) // Define grid items based on the available space horizontally
    ]

    var body: some View {
        Form {
            Section(header: Text("Account Details")) {
                TextField("Account Name", text: $name)
                // TextField for initial balance that accepts a String
                TextField("Initial Balance", text: Binding(
                    get: { initialBalance ?? "" },
                    set: { initialBalance = $0 }
                ))
                .keyboardType(.decimalPad)
            }

            Section(header: Text("Select Icon")) {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 16) {
                        ForEach(sfSymbols, id: \.self) { symbol in
                            IconItem(symbol: symbol, isSelected: symbol == selectedIcon)
                                .onTapGesture {
                                    selectedIcon = symbol
                                }
                        }
                    }
                    .frame(height: 240) // Adjust the height for horizontal scrolling
                }
            }
        }
        .navigationTitle(accountToEdit == nil ? "Add Account" : "Edit Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Leading toolbar button for cancel action during edit mode
            if accountToEdit != nil {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss() // Dismiss the form without saving
                    }
                }
            }
            // Save or Update button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(accountToEdit == nil ? "Save" : "Update") {
                    saveAccount()
                }
            }
        }
    }

    func saveAccount() {
        // Convert initialBalance to Double
        let balance = Double(initialBalance ?? "") ?? 0.0
        
        if let account = accountToEdit {
            // Update existing account
            account.name = name
            account.initialBalance = balance
            account.iconString = selectedIcon
        } else {
            // Create new account
            let newAccount = AccountModel(name: name, initialBalance: balance, iconString: selectedIcon)
            modelContext.insert(newAccount)
        }

        // Save the changes
        try? modelContext.save()
        // Dismiss the form after saving
        dismiss()
    }
}

struct IconItem: View {
    let symbol: String
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.gray.opacity(0.4) : Color.clear)
                .frame(width: 50, height: 50)

            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.accentColor)
        }
    }
}

#Preview("Create Account"){
    Group {
        // Preview for creating a new account
        NavigationView {
            AccountFormView()
                .modelContainer(for: [AccountModel.self], inMemory: true)
        }
        
    }
}

#Preview("Edit Account") {
    Group {

        // Preview for editing an existing account
        NavigationView {
            AccountFormView(accountToEdit: AccountModel(name: "Sample Account", initialBalance: 100.0, iconString: "star"))
                .modelContainer(for: [AccountModel.self], inMemory: true)
        }
    }
}
