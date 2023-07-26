//
//  ShortVideoPost.swift
//  ob_intern
//
//  Created by Soft Liampisan on 28/6/2566 BE.
//

import Foundation
import SwiftyJSON

let mockHashtag: [String] = ["music", "basketball", "movies", "basketball", "lifestyle"]

var prevNumber: UInt32? // used in randomNumber()

func randomNum() -> UInt32? {
    var randomNumber = arc4random_uniform(1000000)
    while previousNumber == randomNumber {
        randomNumber = arc4random_uniform(1000000)
    }
    previousNumber = randomNumber
    return randomNumber
}

func numFormat(num: String) -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(num) ?? 0))
    return formattedNumber
}

class ShortVideoPost {
    
    var user: User?
    var media: MediaModel?
    var postID: Int = 0
    var hashtag: [String] = []
    var numberOfLikes: String = ""
    var numberOfComments: String = ""
    
    init(user: User?,
         media: MediaModel?,
         postID: Int,
         hashtag: [String],
         numLike: String,
         numComment: String) {
        self.user = User.mock()
        self.media = MediaModel.mock()
        self.postID = postID
        self.hashtag = hashtag
        self.numberOfLikes = numLike
        self.numberOfComments = numComment
        
    }
    init(json: JSON) {
        self.user = User.init(json: json["owner"])
        self.media = MediaModel.init(json: json["media"])
        self.postID = json["postID"].intValue
        if let hashtags = json["hashtag"].arrayObject as? [String] {
            self.hashtag = hashtags
        }
        self.numberOfLikes = numFormat(num: json["like"].stringValue) ?? ""
        self.numberOfComments = numFormat(num: json["comment"].stringValue) ?? ""
        //self.isLike = json["isLike"].boolValue
        
    }
    
    init() {
    
    }
    
    
    class func mock() -> ShortVideoPost {
        
        let post = ShortVideoPost.init()
        
        post.postID = Int(Date().timeIntervalSince1970) + Int.random(in: 0...999)
        post.user = User.mock()
        post.media = MediaModel.mock()
        post.hashtag = [mockHashtag.randomElement() ?? ""]
        post.numberOfLikes = numFormat(num: String(randomNum() ?? 0)) ?? ""
        post.numberOfComments = numFormat(num: String(randomNum() ?? 0)) ?? ""
        
        return post
        
    }
    
}
