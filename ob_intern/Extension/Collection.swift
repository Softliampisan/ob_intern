//
//  Collection.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func takeSafe(index : Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    

}
