//
//  TokenStorage.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation

final class TokenStorage {
    static let shared = TokenStorage()
    private init() {}
    
    private let tokenKey = "cleari_auth_token"
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
