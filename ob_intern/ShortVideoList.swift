//
//  MockShortVideoList.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//

import Foundation

let mockImageUrls: [[String]] = [
    ["https://images.unsplash.com/photo-1613852348439-82fa38ec01da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dGVlbmFnZSUyMGJveXxlbnwwfHwwfHw%3D&w=1000&q=80"],
    ["https://i.insider.com/5eb47f7c42278d1355041423?width=600&format=jpeg&auto=webp", "https://elcomercio.pe/resizer/6ncgh-leKSroX-xWP8p5TK5-bSE=/980x528/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/PLWTDLOTVFGC7FHAA3IJ5LXQHQ.jpeg"],
    ["https://i.pinimg.com/originals/86/e8/21/86e821eb7d8d3d8fbd16533488c1ab8d.jpg", "https://www.hleatherjackets.com/wp-content/uploads/2020/03/6-3.jpg"],
    ["https://www.etonline.com/sites/default/files/styles/max_970x546/public/images/2018-11/tatb_lana_condor.jpg?h=c673cd1c&itok=RsGLxWfl", "https://i.pinimg.com/originals/08/d1/2d/08d12d38b01fc2ff1483cb4d797e7232.jpg", "https://i.pinimg.com/originals/9f/84/02/9f8402d00fec8a57b63ac22ea414eac4.jpg"],
    ["https://deadline.com/wp-content/uploads/2021/03/MCDTOAL_ZX039.jpg", "https://www.animationsource.org/images/users/19311/Kevin%20big.jpg", "https://y.yarn.co/a94a4a70-af65-4079-80f8-2da88633dbd7_screenshot.jpg"]
]

var previousNumber: UInt32? // used in randomNumber()

func randomNumber() -> UInt32 {
    var randomNumber = arc4random_uniform(10)
    while previousNumber == randomNumber {
        randomNumber = arc4random_uniform(10)
    }
    previousNumber = randomNumber
    return randomNumber
}

class ShortVideoList {
    
    var numViews: Int = 0
    var videoImage: [String] = []
    
    init(numViews: Int,
         videoImage: [String]) {
        self.numViews = numViews
        self.videoImage = videoImage
        
    }
    init() {
    
    }
    
    
    class func mock() -> ShortVideoList {
        
        let video = ShortVideoList.init()
        
        video.numViews = Int(randomNumber())
        video.videoImage = mockImageUrls.randomElement() ?? []
        
        return video
        
    }
    
}
