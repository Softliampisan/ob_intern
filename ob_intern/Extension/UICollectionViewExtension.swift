//
//  UICollectionView+Extension.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/6/2566 BE.
//

import Foundation

import UIKit

extension UICollectionView {

    func register(cell anyClass: Any) {
        let name = String(describing: anyClass)
        register(UINib(nibName: name, bundle: Bundle.main), forCellWithReuseIdentifier: name)
    }
}
