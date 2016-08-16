//
//  NFHTTPManager.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 29/7/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import MBProgressHUD

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




protocol NFHTTPTaskDelegate: NSObjectProtocol {
    func didExecuteFinish(action: String, tag: Int, response: NFBaseResponse?, error: NSError?)
}

extension NFHTTPTaskDelegate {
    func didExecuteFinish(action: String, tag: Int, response: NFBaseResponse?, error: NSError?){
        NFLogDebug("uuuuuu")
    }
}

class NFHTTPTask<T: Mappable>: NSObject {
    
    var action: String!
    var params: String?
    var tag: Int = 0
    weak var delegate: NFHTTPTaskDelegate?
    weak var hud: MBProgressHUD?
    
    deinit{
        NFLogDebug("xxxxx")
    }
    
    func doRequest() -> Self {
        
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        
        // show HUD
        self.showLoadingHUD()
        
        // request
        let request = Alamofire.request(.GET, URL, parameters: ["ss": "qq"]).responseObject { (response: Response<T, NSError>) in
            // hide HUD
            self.hideLoadingHUD()
            
            // print log
            self.printResponse(response)
            
            // perform selector
            self.processResponse(response)
        }
        
        // print log
        NFLogDebug("-------------------->")
        debugPrint(request)
        
        return self
    }
    
    func showLoadingHUD(view: UIView? = nil) {
        
    }
    
    func hideLoadingHUD(view: UIView? = nil) {
        
    }
    
    func showErrorHUD(view: UIView? = nil) {
        
    }
    
    func processResponse(response: Response<T, NSError>) {
        if let error = response.result.error {
            // 请求服务器出错或者解析数据出错
            // 是否显示错误HUD
            
            
            self.delegate?.didExecuteFinish(action, tag: tag, response: nil, error: error)
            return
        }
        
        if let result = response.result.value as? NFBaseResponse {
            // 校验服务器返回数据
            
            
            self.delegate?.didExecuteFinish(action, tag: tag, response: result, error: nil)
        } else {
            NFLogError("你的类必须继承自NFBaseResponse类型")
        }
    }
    
    func printResponse(response: Response<T, NSError>){
    #if DEBUG
        if let error = response.result.error {
            NFLogError("<-----------------\(response.request!.URLString)\(error)")
            return
        }
        
        if let data = response.data {
            NFLogDebug("<-----------------\(response.request!.URLString)\(NSString(data: data, encoding: NSUTF8StringEncoding))")
        } else {
            NFLogDebug("<-----------------\(response.request!.URLString)")
        }
    #endif
    }
}