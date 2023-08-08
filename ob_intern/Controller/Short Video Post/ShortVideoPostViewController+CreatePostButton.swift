//
//  ShortVideoPostViewController+CreatePostButton.swift
//  ob_intern
//
//  Created by Soft Liampisan on 11/7/2566 BE.
//

import Foundation
import UIKit

extension ShortVideoPostViewController: CreatePostButtonViewDelegate {
    func presentPopupMenu() {
        AppDirector.sharedInstance().presentMenuViewController()
    }
}
