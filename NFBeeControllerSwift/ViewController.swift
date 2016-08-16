//
//  ViewController.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 26/7/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import ObjectMapper
import SVProgressHUD


public func printLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

class WeatherResponse: NFBaseResponse {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    class func test() {
        NFLogVerbose("类方法")
    }
    
    override func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class ForecastBase: Mappable {
    var day: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        day <- map["day"]
    }
}

class Forecast: ForecastBase {

    var temperature: Int?
    var conditions: String?
    var ss: String!
    
    required init?(_ map: Map){
        NFLogDebug(map)
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        temperature <- map["temperature"]
        conditions <- map["conditions"]
        ss <- map["ss"]
    }
}

struct Point {
    var x = 0, y = 0
    
    mutating func moveXBy(x:Int,yBy y:Int) {
        self.x += x
        // Cannot invoke '+=' with an argument list of type '(Int, Int)'
        self.y += y
        // Cannot invoke '+=' with an argument list of type '(Int, Int)'
    }
}

class ViewController: UIViewController, NFHTTPTaskDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherResponse.test()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let request1 = Alamofire.request(.GET, "https://httpbin.org/get")
//            .validate()
//            .responseString { response in
//                printLog("Response String: \(response.result.value)")
//                printLog(response.request)  // original URL request
//                printLog(response.response) // URL response
//                printLog(response.data)     // server data
//                printLog(response.result)   // result of response serialization
//            }
//            .responseJSON { response in
//                printLog("Rlkesponse JSON: \(response.result.value)")
//        }
//        NFLogDebug("-------------------->")
//        debugPrint(request1)
//        
//        let request2 = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["ss": "ss"], encoding: .URL, headers: nil).responseJSON { (response) in
//            
//        }
//        NFLogDebug("-------------------->")
//        debugPrint(request2)
        
        
//
//        Alamofire.request(.GET, "https://httpbin.org/get").responseSwiftyJSON { (response) in
//            printLog(response)
//            //println(error)
//        }
        
//        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
//            .responseSwiftyJSON({ (request, response, json, error) in
//                println(json)
//                println(error)
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//            })
        
        
        
//        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
//        SVProgressHUD.showWithStatus("loading...")
//        SVProgressHUD.setDefaultStyle(.Dark)
//        let request = Alamofire.request(.GET, URL, parameters: ["ss": "qq"]).responseObject { (response: Response<WeatherResponse, NSError>) in
//            debugPrint(response.response)
//            SVProgressHUD.dismiss()
//            NFLogDebug(response.result.debugDescription)
//            
//            let weatherResponse = response.result.value
//            NFLogDebug(weatherResponse?.location)
//            
//            if let threeDayForecast = weatherResponse?.threeDayForecast {
//                for forecast in threeDayForecast {
//                    NFLogDebug(forecast.day)
//                    NFLogDebug(forecast.temperature)
//                }
//            }
//        }
//        NFLogDebug("-------------------->")
//        debugPrint(request)
//        
//        let ss = UITableView()
//        ss.delegate = self
        
        let task = NFHTTPTask<WeatherResponse>()
        task.delegate = self
        task.doRequest()
        
        /*
         参数  url，method， 参数，T，
         1. hud start
         
         
         */

    }
    
//    func didExecuteFinish(action: String, tag: Int, response: NFBaseResponse?, error: NSError?) {
//        NFLogDebug("adfasdfsafd")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

