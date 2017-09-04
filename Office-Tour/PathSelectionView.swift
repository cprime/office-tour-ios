//
//  PathSelectionView.swift
//  Office-Tour
//
//  Created by Colden Prime on 8/31/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation
import Intrepid

protocol PathSelectionViewDelegate: class {
    func pathSelectionView(_ view: PathSelectionView, didSelect location: TourLocation)
}

class PathSelectionView: UIView {
    let buttonWidth: CGFloat = 44
    var buttons = [(TourLocation, UIButton)]()

    weak var delegate: PathSelectionViewDelegate?

    private(set) var currentLocation: TourLocation!
    private(set) var otherLocations: [TourLocation]!

    func update(currentLocation: TourLocation, otherLocations: [TourLocation]) {
        backgroundColor = .clear
        buttons.forEach({
            $0.1.removeFromSuperview()
        })
        buttons.removeAll()

        self.currentLocation = currentLocation
        self.otherLocations = otherLocations

        for (index, location) in otherLocations.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle("^", for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = index
            button.frame = CGRect(x: 0,
                                  y: 0,
                                  width: buttonWidth,
                                  height: buttonWidth)
            button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            addSubview(button)

            buttons.append((location, button))
        }

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buttons.forEach({ (location, button) in
            let vector = CGPoint(x: location.position.x - currentLocation.position.x,
                                 y: location.position.y - currentLocation.position.y)
            let magnitude = sqrt(vector.x * vector.x + vector.y * vector.y)
            let normalizedVector = CGPoint(x: vector.x / magnitude,
                                           y: vector.y / magnitude)

            let angle = atan2(normalizedVector.y, -normalizedVector.x)
            let radius = buttonWidth * 2
            let centerX = bounds.ip_halfWidth
            let centerY = bounds.ip_halfHeight
            let xi = cos(angle) * radius
            let yi = sin(angle) * radius

            button.center = CGPoint(x: centerX - xi, y: centerY - yi)
            button.transform = CGAffineTransform.identity.rotated(by: angle - 90.ip_radians)
        })


    }

    func didTapButton(_ sender: Any) {
        guard let button = sender as? UIButton, let location = otherLocations[ip_safely: button.tag] else {
            return
        }
        delegate?.pathSelectionView(self, didSelect: location)
    }
}
