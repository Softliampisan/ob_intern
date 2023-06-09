//
//  MockShortVideoList.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//

import Foundation

let mockImageUrls: [String] = ["https://images.unsplash.com/photo-1609171712489-45b6ba7051a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60",
    "https://plus.unsplash.com/premium_photo-1679599983488-4968d587e00b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609824462369-3d5b0a00fbdb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1536195892759-c8a3c8e1945e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1554101690-bea9f60fd647?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjZ8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1514489024785-d5ba8dfb2198?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1512790941078-1158a9cc3255?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzF8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60"]

var previousNumber: UInt32? // used in randomNumber()

func randomNumber() -> UInt32 {
    var randomNumber = arc4random_uniform(1000)
    while previousNumber == randomNumber {
        randomNumber = arc4random_uniform(1000)
    }
    previousNumber = randomNumber
    return randomNumber
}

class ShortVideoList {
    
    var numViews: Int = 0
    var videoImage: String = ""
    
    init(numViews: Int,
         videoImage: String) {
        self.numViews = numViews
        self.videoImage = videoImage
        
    }
    init() {
    
    }
    
    
    class func mock() -> ShortVideoList {
        
        let video = ShortVideoList.init()
        
        video.numViews = Int(randomNumber())
        video.videoImage = mockImageUrls.randomElement() ?? ""
        
        return video
        
    }
    
}
