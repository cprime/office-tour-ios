//
//  TourViewController.swift
//  Office-Tour
//
//  Created by Colden Prime on 8/31/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import UIKit
import GVRKit
import IP_UIKit_Wisdom
import AVKit

class TourViewController: UIViewController {
    var pathSelectionView: PathSelectionView!
    var panoramaView: GVRPanoramaView!
    var headRotationTimer: Timer?
    let tourMap = TourMap.appartmentTour
    var transitioning = false

    var currentLocation: TourLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Panorama"
        view.backgroundColor = .black

        currentLocation = tourMap.locations.first
        panoramaView = createPanoramaView(with: currentLocation)
        view.addSubview(panoramaView)

        pathSelectionView = PathSelectionView()
        pathSelectionView.delegate = self
        pathSelectionView.update(currentLocation: currentLocation,
                                 otherLocations: tourMap.validDestinations(from: currentLocation))
        view.addSubview(pathSelectionView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headRotationTimer = Timer.scheduledTimer(withTimeInterval: (1.0/30.0), repeats: true) { [weak self] _ in
            guard let panoramaView = self?.panoramaView, let pathSelectionView = self?.pathSelectionView else {
                return
            }
            print(panoramaView.headRotation)
            pathSelectionView.transform = CGAffineTransform.identity.rotated(by: -panoramaView.headRotation.yaw.ip_radians)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headRotationTimer?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        panoramaView.frame = view.bounds
        pathSelectionView.frame = CGRect(x: 0,
                                         y: view.bounds.height - view.bounds.width,
                                         width: view.bounds.width,
                                         height: view.bounds.width)
    }

//    func relacePanoramaView(with location: TourLocation) {
//        guard !transitioning else { return }
//        transitioning = true
//
//        let panoramaView = createPanoramaView(with: location)
//        panoramaView.alpha = 0
//        view.addSubview(panoramaView)
//
//        UIView.animate(withDuration: 0.25, delay: 0.25, animations: {
//            self.panoramaView.alpha = 0
//            panoramaView.alpha = 1.0
//        }, completion: { finished in
//            self.panoramaView.removeFromSuperview()
//            self.panoramaView = panoramaView
//            self.currentLocation = location
//            self.transitioning = false
//        })
//    }

    func createPanoramaView(with location: TourLocation) -> GVRPanoramaView {
        let panoramaView = GVRPanoramaView(frame: view.bounds)
        panoramaView.delegate = self
        panoramaView.enableInfoButton = false
        panoramaView.displayMode = .embedded
        panoramaView.hidesTransitionView = true
        panoramaView.enableTouchTracking = false
        panoramaView.load(UIImage(named: location.imageName), of: .mono)
        return panoramaView
    }
}

extension TourViewController: GVRWidgetViewDelegate {
    func widgetViewDidTap(_ widgetView: GVRWidgetView!) {
        print(#function)
    }

    func widgetView(_ widgetView: GVRWidgetView!, didChange displayMode: GVRWidgetDisplayMode) {
        print(#function, displayMode)
    }

    func widgetView(_ widgetView: GVRWidgetView!, didLoadContent content: Any!) {
        print(#function, content)
    }

    func widgetView(_ widgetView: GVRWidgetView!, didFailToLoadContent content: Any!, withErrorMessage errorMessage: String!) {
        print(#function, content, errorMessage)
    }
}

extension TourViewController: PathSelectionViewDelegate {
    func pathSelectionView(_ view: PathSelectionView, didSelect location: TourLocation) {
        panoramaView.load(UIImage(named: location.imageName), of: .mono)
        pathSelectionView.update(currentLocation: location,
                                 otherLocations: tourMap.validDestinations(from: location))
        currentLocation = location
    }
}
