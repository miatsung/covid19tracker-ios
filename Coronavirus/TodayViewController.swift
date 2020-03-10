//
//  TodayViewController.swift
//  Coronavirus
//
//  Created by Mia Tsung on 3/9/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet weak var casesNumLabel: UILabel!
    @IBOutlet weak var deathNumLabel: UILabel!
    @IBOutlet weak var recoverdNumLabel: UILabel!
    @IBOutlet weak var todayCasesNumLabel: UILabel!
    @IBOutlet weak var todayDeathNumLabel: UILabel!
    @IBOutlet weak var criticalNumLabel: UILabel!
    
    
    
    // Constants
    let GLOBAL_URL = "https://corona.lmao.ninja/all"
    let CORONAVIRUS_URL = "https://corona.lmao.ninja/countries"
    
    
    // Variable
    let locationManager = CLLocationManager()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("widget viewdidload")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        getCoroData(url: CORONAVIRUS_URL)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    //Networking
    func getCoroData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
             if response.result.isSuccess {
                
                print("Success! Got coro data")
               
                let coroDataJSON : JSON = JSON(response.result.value!)
                print(coroDataJSON)
                self.updateCoroData(json: coroDataJSON)
               
             } else {
               print("Error \(String(describing: response.result.error))")
            }
                           
        }
    }
    
    
    //JSON Parsing
    
    func updateCoroData(json : JSON) {
        print("result is ")

        casesNumLabel.text = json[0]["cases"].stringValue
        deathNumLabel.text = json[0]["deaths"].stringValue
        recoverdNumLabel.text = json[0]["recovered"].stringValue
        todayCasesNumLabel.text = json[0]["todayCases"].stringValue
        todayDeathNumLabel.text = json[0]["todayDeaths"].stringValue
        criticalNumLabel.text = json[0]["critical"].stringValue

    }
    
}
