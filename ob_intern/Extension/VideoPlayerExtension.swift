//
//  VideoPlayerExtension.swift
//  ob_intern
//
//  Created by Soft Liampisan on 11/7/2566 BE.
//

import Foundation
import UIKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
