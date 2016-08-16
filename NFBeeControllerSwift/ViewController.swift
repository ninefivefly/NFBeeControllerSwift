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

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    required init?(_ map: Map){
        
    }
    
    class func test() {
        NFLogVerbose("类方法")
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    var ss: String!
    
    required init?(_ map: Map){
        NFLogDebug(map)
    }
    
    func mapping(map: Map) {
        day <- map["day"]
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

class ViewController: UIViewController {
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
        
        
        
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        SVProgressHUD.showWithStatus("loading...")
        SVProgressHUD.setDefaultStyle(.Dark)
        let request = Alamofire.request(.GET, URL, parameters: ["ss": "qq"]).responseObject { (response: Response<WeatherResponse, NSError>) in
            debugPrint(response.response)
            SVProgressHUD.dismiss()
            NFLogDebug(response.result.debugDescription)
            
            let weatherResponse = response.result.value
            NFLogDebug(weatherResponse?.location)
            
            if let threeDayForecast = weatherResponse?.threeDayForecast {
                for forecast in threeDayForecast {
                    NFLogDebug(forecast.day)
                    NFLogDebug(forecast.temperature)
                }
            }
        }
        NFLogDebug("-------------------->")
        debugPrint(request)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

