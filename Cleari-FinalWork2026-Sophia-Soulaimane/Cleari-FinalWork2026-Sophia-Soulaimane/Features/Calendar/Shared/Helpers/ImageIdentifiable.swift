//
//  ImageIdentifiable.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import UIKit

extension UIImage: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}
