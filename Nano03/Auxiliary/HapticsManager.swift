//
//  HapticsManager.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 06/10/25.
//

import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    private let generator = UINotificationFeedbackGenerator()
    private init() {}
    func play(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
