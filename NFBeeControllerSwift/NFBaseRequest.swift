//
//  NFBaseRequest.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 17/8/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import ObjectMapper

class NFBaseRequest: Mappable {
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        
    }
    
    func params() -> [String: AnyObject]? {
        return self.toJSON()
    }
    
    func headers() -> [String: String]? {
        return nil
    }
    
    class func baseUrl() -> String {
        return ""
    }

}