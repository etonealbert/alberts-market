//
//  Data.swift
//  TaskManager
//
//  Created by  on 20/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

public struct Item {
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(name: "Multiple_Dashboard", items: [
        Item(name: "Default Dashboard"),
        Item(name: "Dashboard 1")
    ])
]
