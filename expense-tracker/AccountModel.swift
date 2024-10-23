//
//  AccountModel.swift
//  expense-tracker
//
//  Created by Noel Dupuis on 23/10/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class AccountModel: Identifiable {
    @Attribute(.unique)
    var id: String
    
    var name: String
    var initialBalance: Double
    var iconString: String
    
    init(name: String, initialBalance: Double, iconString: String) {
        self.id = UUID().uuidString
        self.name = name
        self.initialBalance = initialBalance
        self.iconString = iconString
    }
}
