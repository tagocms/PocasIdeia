//
//  Tag.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 04/10/25.
//

import Foundation
import SwiftData

@Model
class Tag: Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    @Relationship(deleteRule: .nullify) var items: [Item]? = []
    
    init(id: UUID, name: String, items: [Item]? = nil) {
        self.id = id
        self.name = name
        self.items = items
    }
}
