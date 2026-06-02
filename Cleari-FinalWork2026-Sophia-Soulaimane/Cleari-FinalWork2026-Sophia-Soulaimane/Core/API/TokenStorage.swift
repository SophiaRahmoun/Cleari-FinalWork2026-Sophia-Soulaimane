//
//  TokenStorage.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}

final class TokenStorage {

    static let shared = TokenStorage()
    private init() {}

    private let tokenKey                   = "cleari_auth_token"
    private let roleKey                    = "cleari_user_role"
    private let userIdKey                  = "cleari_user_id"
    private let subscriptionStatusKey      = "cleari_subscription_status"
    private let profilePictureKey          = "cleari_profile_picture_url"
    private let dermVerificationStatusKey  = "cleari_derm_verification_status"

    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }

    var userRole: String? {
        get { UserDefaults.standard.string(forKey: roleKey) }
        set { UserDefaults.standard.set(newValue, forKey: roleKey) }
    }

    var userId: Int? {
        get {
            let v = UserDefaults.standard.integer(forKey: userIdKey)
            return v == 0 ? nil : v
        }
        set { UserDefaults.standard.set(newValue, forKey: userIdKey) }
    }

    var profilePictureUrl: String? {
        get { UserDefaults.standard.string(forKey: profilePictureKey) }
        set { UserDefaults.standard.set(newValue, forKey: profilePictureKey) }
    }

    var subscriptionStatus: String? {
        get { UserDefaults.standard.string(forKey: subscriptionStatusKey) }
        set { UserDefaults.standard.set(newValue, forKey: subscriptionStatusKey) }
    }

    var dermVerificationStatus: String? {
        get { UserDefaults.standard.string(forKey: dermVerificationStatusKey) }
        set { UserDefaults.standard.set(newValue, forKey: dermVerificationStatusKey) }
    }

    var hasFakeTrendAccess: Bool {
        if userRole == "dermatologist" {
            return true
        }

        return subscriptionStatus == "active"
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: roleKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: subscriptionStatusKey)
        UserDefaults.standard.removeObject(forKey: profilePictureKey)
        UserDefaults.standard.removeObject(forKey: dermVerificationStatusKey)

        NotificationCenter.default.post(name: .didLogout, object: nil)
    }
}
