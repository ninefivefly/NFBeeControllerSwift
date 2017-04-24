//
//  NFBaseResponse.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 17/8/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import ObjectMapper

class NFBaseResponse: Mappable {
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        
    }
    
    func preprocess() -> NSError? {
        return nil
    }
    
    func isForward() -> Bool {
        return true
    }
}