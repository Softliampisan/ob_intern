//
//  ShortVDOService.swift
//  ob_intern
//
//  Created by Soft Liampisan on 29/6/2566 BE.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShortVDOService {
    
    func getShortVDOPost(completion: @escaping ( ([ShortVideoPost]) -> Void),
                         errorHandler: @escaping ( (Error) -> Void)){
        let link = "https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/getVideoList"
        let request = AF.request(link, method: .get)
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let value = JSON(value)
                let data = value["data"]
                let videoPosts = data.arrayValue.map ({ return ShortVideoPost.init(json: $0)})
                print(videoPosts)
                completion(videoPosts)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    func getShortVDOList(completion: @escaping ( ([ShortVideoList]) -> Void),
                         errorHandler: @escaping ( (Error) -> Void)){
        let link = "https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/getVideoList"
        let request = AF.request(link, method: .get)
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let value = JSON(value)
                let data = value["data"]
                let videoList = data.arrayValue.map ({ return ShortVideoList.init(json: $0)})
                print(videoList)
                completion(videoList)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    func getShortVDO(completion: @escaping ( ([ShortVideo]) -> Void),
                         errorHandler: @escaping ( (Error) -> Void)){
        let link = "https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/getVideoPost"
        let request = AF.request(link, method: .get)
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let value = JSON(value)
                let data = value["data"]
                let videoList = data.arrayValue.map ({ return ShortVideo.init(json: $0)})
                print(videoList)
                completion(videoList)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    func createShortVDO(coverImageURL: String,
                        caption: String,
                        isAllowComments: Bool,
                        isPublic: Bool,
                        isAllowGifts: Bool,
                        completion: @escaping ( () -> Void),
                        errorHandler: @escaping ( (Error) -> Void)){
        let link = "https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/createShortVideo"
        var param: Parameters = ["coverImageURL": coverImageURL,
                                 "caption": caption,
                                 "isAllowComments": isAllowComments,
                                 "isPublic": isPublic,
                                 "isAllowGifts": isAllowGifts]
     
        let request = AF.request(link, method: .post, parameters: param)
        request.responseJSON { response in
            print("response \(response)")
            switch response.result {
            case .success(let value):
                let isSuccess = JSON(value)["isSuccess"].boolValue
                if isSuccess {
                    completion()
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
        
    }
    
}

