//
//  NFHTTPManager.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 29/7/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import Alamofire
import ObjectMapper
import MBProgressHUD
import AlamofireObjectMapper

protocol NFHTTPTaskDelegate: NSObjectProtocol {
    
    func parentViewForHUD(aciton: String) -> UIView?
    
    func textDisplayWhenExecuteAction(action: String) -> String?
    
    func didExecuteFinish(action: String, tag: Int, response: NFBaseResponse?, error: NSError?)
    
    func didExecuteFinish(action: String, response: NFBaseResponse?, error: NSError?)
}

extension NFHTTPTaskDelegate {
    
    func parentViewForHUD(aciton: String) -> UIView? {
        return nil
    }
    
    func textDisplayWhenExecuteAction(action: String) -> String? {
        return "加载中..."
    }
    
    func didExecuteFinish(action: String, tag: Int, response: NFBaseResponse?, error: NSError?) {
        
    }
    
    func didExecuteFinish(action: String, response: NFBaseResponse?, error: NSError?) {
    
    }
}

class NFHTTPTask<T: Mappable>: NSObject {
    
    var method: Alamofire.Method = .POST
    var action = ""
    var tag: Int = 0
    var params: [String: AnyObject]?
    var headers: [String: String]?
    weak var delegate: NFHTTPTaskDelegate?
    
    var hud: MBProgressHUD?
    
    deinit{
        NFLogDebug("xxxxx")
    }
    
    init(_ action: String, target: NFHTTPTaskDelegate? = nil, params: [String: AnyObject]? = nil, headers: [String: String]? = nil, tag: Int = 0, method: Alamofire.Method = .POST) {
        super.init()
        self.action = action
        self.params = params
        self.tag = tag
        self.method = method
        self.headers = headers
        self.delegate = target
    }
    
    convenience init(action: String, target: NFHTTPTaskDelegate? = nil, req: NFBaseRequest? = nil, tag: Int = 0, method: Alamofire.Method = .POST) {
        self.init(action, target: target, params: req?.params(), headers: req?.headers(), tag: tag, method: method)
    }
    
    func doRequest() -> Self {
        
        // show HUD
        self.showLoadingHUD()
        
        // request
        let doneBlock = { (response: Response<T, NSError>) in
            // hide HUD
            self.hideLoadingHUD()
            
            // print log
            self.printResponse(response)
            
            // perform selector
            self.processResponse(response)
        }
        
        var paramsEncodeing: ParameterEncoding
        if method == .POST {
            paramsEncodeing = .JSON
        } else {
            paramsEncodeing = .URL
        }
        
        let url = NFBaseRequest.baseUrl() + action
        let request = Alamofire.request(method, url, parameters: params, encoding: paramsEncodeing, headers: headers).responseObject(completionHandler: doneBlock)
        
        // print log
        self.printRequest(request)
        
        return self
    }
    
    func showLoadingHUD() {
        guard let parentView = delegate?.parentViewForHUD(action) else {
            return
        }
        
        var preHud = MBProgressHUD(forView: parentView)
        if preHud == nil {
            let text = delegate?.textDisplayWhenExecuteAction(action) ?? ""
            preHud = MBProgressHUD.loadingHud(text, view: parentView)
        }
        preHud?.showAnimated(true)
        hud = preHud
    }
    
    func hideLoadingHUD() {
        hud?.hideAnimated(true)
    }
    
    func processResponse(response: Response<T, NSError>) {
        if let _ = response.result.error {
            // 请求服务器出错或者解析数据出错
            // 显示错误HUD,终止数据转发
            MBProgressHUD.showError("网络不给力")
            return
        }
        
        if let result = response.result.value as? NFBaseResponse {
            // 校验服务器返回数据
            let error = result.preprocess()
            if let err = error {
                MBProgressHUD.showError(err.description)
            }
            
            if result.isForward() {
                self.delegate?.didExecuteFinish("", tag: tag, response: result, error: nil)
            }
        } else {
            NFLogError("你的类必须继承自NFBaseResponse类型")
        }
    }
    
    func printResponse(response: Response<T, NSError>) {
    #if DEBUG
        if let error = response.result.error {
            NFLogError("<-----------------\(response.request!.URLString)\n\(error)")
            return
        }
        
        if let data = response.data {
            NFLogDebug("<-----------------\(response.request!.URLString)\n\(NSString(data: data, encoding: NSUTF8StringEncoding))")
        } else {
            NFLogDebug("<-----------------\(response.request!.URLString)")
        }
    #endif
    }
    
    func printRequest(request: Request) {
    #if DEBUG
        guard let _ = request.request else {
            NFLogError("request can not be nil.")
            return
        }
        
        NFLogDebug("----------------->")
        debugPrint(request)
    #endif
    }
}