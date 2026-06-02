//
//  ImageIdentifiable.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import UIKit

extension UIImage: @retroactive Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
