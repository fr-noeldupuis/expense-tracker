//
//  Item.swift
//  expense-tracker
//
//  Created by Noel Dupuis on 23/10/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
