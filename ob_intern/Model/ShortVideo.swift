//
//  ShortVideo.swift
//  ob_intern
//
//  Created by Soft Liampisan on 4/7/2566 BE.
//

import Foundation
import SwiftyJSON

class ShortVideo {
    
    var user: User?
    var media: MediaModel?
    var hashtag: [String] = []
  
    
    init(user: User?,
         media: MediaModel?,
         hashtag: [String]) {
        self.user = User.mock()
        self.media = MediaModel.mock()
        self.hashtag = hashtag
        
        
    }
    init(json: JSON) {
        self.user = User.init(json: json["owner"])
        self.media = MediaModel.init(json: json["media"])
        self.hashtag = json["hashtag"].arrayValue.map { $0.stringValue }
        
        
    }
    init() {
        
    }
    
    class func mock() -> ShortVideo {
        
        let video = ShortVideo.init()
        
        video.user = User.mock()
        video.media = MediaModel.mock()
        //video.hashtag = mockHashtag.randomElement() ?? []
        
        return video
        
    }
    
}
