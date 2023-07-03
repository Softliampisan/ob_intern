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
        let request = AF.request("https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/getVideoPost",
                                 method: .get)
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
        let request = AF.request("https://cccfefc5-f8d5-4f42-b9c0-1a17022434cb.mock.pstmn.io/getVideoPost",
                                 method: .get)
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
}

