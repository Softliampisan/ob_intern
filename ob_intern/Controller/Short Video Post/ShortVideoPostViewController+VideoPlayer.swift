//
//  ShortVideoPostViewController+VideoPlayer.swift
//  ob_intern
//
//  Created by Soft Liampisan on 11/7/2566 BE.
//

import Foundation
import UIKit
import AVFoundation


extension ShortVideoPostViewController: ShortVideoPlayerDelegate {
    func updateCurrentTime(currentTime: CMTime) {
        if let indexPath = tableView.indexPathForRow(at: tableView.bounds.center) {
            if let cell = tableView.cellForRow(at: indexPath) as? ShortVideoPostTableViewCell {
                cell.setPlayerTime(time: currentTime)
            }
        }
    }
}
