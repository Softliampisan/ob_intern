//
//  TextEditDragDropViewController.swift
//  TextOverlay
//
//  Created by Saharat Petcharayuttapan on 21/9/2565 BE.
//

import UIKit

extension TextEditDragDropViewController: UIGestureRecognizerDelegate {

    // MARK: GESTURE

    func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))

        pinchGesture.delegate = self
        rotationGesture.delegate = self

        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(rotationGesture)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)

            for label in self.displayedTexts {
                let viewFrame = self.view.convert(label.frame, from: label.superview)

                if viewFrame.contains(position) {

                    self.movingItem = label
                    if let position = touches.first?.location(in: self.view) {
                        beginTouch = position
                        oldCenter = label.center
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let item = self.movingItem else { return }
        if let position = touches.first?.location(in: self.view) {
            let deltaX = position.x - self.beginTouch.x
            let deltaY = position.y - self.beginTouch.y
            let magnitude = Int(sqrt((deltaX * deltaX) + (deltaY * deltaY)))

            if magnitude < self.thresholdValue {
                self.editingItem = item
                self.setState(state: .editing)
            }
        }
        self.movingItem = nil
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            let viewFrame = self.view.convert(self.displayContentView.frame, from: displayContentView.superview)

            if viewFrame.contains(position) {
                if let position = touches.first?.location(in: self.view) {
                    let deltaX = position.x - beginTouch.x
                    let deltaY = position.y - beginTouch.y

                    if let item = self.movingItem {

                        item.center = CGPoint.init(x: oldCenter.x + deltaX, y: oldCenter.y + deltaY)
                        print("MOVING")
                    }
                }
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("CANCELLED")
    }

    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            if let item = self.movingItem {
                self.identity = item.transform
            }

        case .changed,.ended:
            if let item = self.movingItem {
                item.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
            }

        case .cancelled:
            break

        default:
            break
        }
    }

    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        if let item = self.movingItem {
            item.transform = item.transform.rotated(by: gesture.rotation)
        }
    }
}
