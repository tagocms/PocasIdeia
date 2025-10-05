//
//  Item.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 04/10/25.
//

import Foundation
import SwiftData

@Model
class Item: Identifiable {
    var id: UUID = UUID()
    var title: String = ""
    var irritationLevel: Int = 1
    var summary: String = ""
    var images: [Data] = []
    var tags: [Tag]? = []
    var createdDate: Date = Date.now
    
    init(id: UUID = UUID(), title: String, irritationLevel: Int, summary: String, images: [Data], tags: [Tag]? = nil, createdDate: Date = Date.now) {
        self.id = id
        self.title = title
        self.irritationLevel = irritationLevel
        self.summary = summary
        self.images = images
        self.tags = tags
        self.createdDate = createdDate
    }
}
