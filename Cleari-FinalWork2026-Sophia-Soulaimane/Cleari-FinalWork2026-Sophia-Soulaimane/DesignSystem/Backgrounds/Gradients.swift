//
//  Gradients.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import UIKit

final class RadialGradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    var colors: [UIColor] = [.white, .clear] {
        didSet { updateGradient() }
    }
    
    var locations: [NSNumber] = [0.0, 1.0] {
        didSet { gradientLayer.locations = locations }
    }
    
    convenience init(startHex: String, endHex: String) {
        self.init(frame: .zero)
        colors = [
            UIColor(hex: startHex),
            UIColor(hex: endHex)
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.addSublayer(gradientLayer)
        
        updateGradient()
        gradientLayer.locations = locations
        
        isUserInteractionEnabled = false
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

final class LinearGradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    var colors: [UIColor] = [.white, .black] {
        didSet { updateGradient() }
    }
    
    var locations: [NSNumber] = [0.0, 1.0] {
        didSet { gradientLayer.locations = locations }
    }
    
    convenience init(startHex: String, endHex: String) {
        self.init(frame: .zero)
        colors = [
            UIColor(hex: startHex),
            UIColor(hex: endHex)
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        gradientLayer.type = .axial
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.addSublayer(gradientLayer)
        
        updateGradient()
        gradientLayer.locations = locations
        
        isUserInteractionEnabled = false
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
