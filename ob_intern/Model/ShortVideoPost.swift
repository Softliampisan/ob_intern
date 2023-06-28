//
//  ShortVideoPost.swift
//  ob_intern
//
//  Created by Soft Liampisan on 28/6/2566 BE.
//

import Foundation

var mockImagePostUrls: [String] = ["https://images3.alphacoders.com/110/1108129.jpg",
                               "https://wallpaperaccess.com/full/6193236.jpg",
                               "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059",
                               "https://i.pinimg.com/originals/4e/52/2d/4e522df5de3a6903cf2272572eb471aa.jpg"]
let mockHashtag: [[String]] = [["music", "basketball", "movies"],
                               ["basketball", "lifestyle"],
                               []]
let mockCaption: [String] = ["Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum ", "Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text", "Lorem Ipsum is"]
let mockDate1 = Date.parse("2023-06-27")
let mockDate2 = Date.parse("2023-06-28")

var prevNumber: UInt32? // used in randomNumber()

func randomNum() -> UInt32? {
    var randomNumber = arc4random_uniform(1000000)
    while previousNumber == randomNumber {
        randomNumber = arc4random_uniform(1000000)
    }
    previousNumber = randomNumber
    return randomNumber
}

func numFormat() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(randomNumber() ?? 0)))
    return formattedNumber
}

class ShortVideoPost {
    
    var user: User?
    var hashtag: [String] = []
    var caption: String = ""
    var postImage: String = ""
    var numberOfLikes: String = ""
    var numberOfComments: String = ""
    var datePosted: String = ""
    
    init(user: User?,
         hashtag: [String],
         caption: String,
         postImage: String,
         numLike: String,
         numComment: String,
         datedPosted: String) {
        self.user = User.mock()
        self.hashtag = hashtag
        self.caption = caption
        self.postImage = postImage
        self.numberOfLikes = numLike
        self.numberOfComments = numComment
        self.datePosted = datedPosted
        
    }
    init() {
    
    }
    
    
    class func mock() -> ShortVideoPost {
        
        let post = ShortVideoPost.init()
        
        post.user = User.mock()
        post.hashtag = mockHashtag.randomElement() ?? []
        post.caption = mockCaption.randomElement() ?? ""
        post.postImage = mockImagePostUrls.randomElement() ?? ""
        post.numberOfLikes = numFormat() ?? ""
        post.numberOfComments = numFormat() ?? ""
        let ogDate = Date.randomBetween(start: mockDate1, end: mockDate2)
        post.datePosted = ogDate.timeAgo
        print("og date \(ogDate)")
        
        return post
        
    }
    
}
