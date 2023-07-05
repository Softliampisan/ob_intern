//
//  MediaModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 29/6/2566 BE.
//

import Foundation
import SwiftyJSON

let coverImageUrls: [String] = ["https://images3.alphacoders.com/110/1108129.jpg",
                                   "https://wallpaperaccess.com/full/6193236.jpg",
                                   "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059",
                                   "https://i.pinimg.com/originals/4e/52/2d/4e522df5de3a6903cf2272572eb471aa.jpg"]
let videoUrls: [String] = []
let mockCaption: [String] = ["Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum ", "Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text", "Lorem Ipsum is"]
let mockDate1 = Date.parse("2023-06-27")
let mockDate2 = Date.parse("2023-06-28")

func dateFormat(postTime: String) -> Date? {
    let originalDate = postTime
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    guard let date = dateFormatter.date(from: originalDate) else { return nil }
    return date
}

class MediaModel {
    
    var coverImage: String = ""
    var video: String = ""
    var datePosted: String = ""
    var caption: String = ""
    
    init(postImage: String,
         video: String,
         datedPosted: String,
         caption: String) {
        self.coverImage = postImage
        self.video = video
        self.datePosted = datedPosted
        self.caption = caption
        
    }
    init(json: JSON) {
        self.coverImage = json["coverImageUrl"].stringValue
        self.video = json["videoUrl"].stringValue
        self.datePosted = dateFormat(postTime: json["postTime"].stringValue)?.timeAgo ?? ""
        self.caption = json["caption"].stringValue
        
    }
    
    init() {
        
    }
    
    class func mock() -> MediaModel {
        
        let media = MediaModel.init()
        
        media.caption = mockCaption.randomElement() ?? ""
        media.coverImage = coverImageUrls.randomElement() ?? ""
        media.video = videoUrls.randomElement() ?? ""
        let randomDate = Date.randomBetween(start: mockDate1, end: mockDate2)
        media.datePosted = randomDate.timeAgo
        
        return media
        
    }
    
    
}
