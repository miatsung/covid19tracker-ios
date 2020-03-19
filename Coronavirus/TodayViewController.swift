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


class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var casesNumLabel: UILabel!
    @IBOutlet weak var deathNumLabel: UILabel!
    @IBOutlet weak var recoverdNumLabel: UILabel!
    @IBOutlet weak var todayCasesNumLabel: UILabel!
    @IBOutlet weak var todayDeathNumLabel: UILabel!
    @IBOutlet weak var criticalNumLabel: UILabel!
    
    
    @IBOutlet weak var widgetView: UIView!
    
    // Constants
    let GLOBAL_URL = "https://corona.lmao.ninja/all"
    let CORONAVIRUS_URL = "https://corona.lmao.ninja/countries"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let buttonTitle = NSLocalizedString("bear", comment: "The name of the animal")
    private let kAppGroupName = "group.mia.tsung.com.2019coro"
    private var sharedContainer : UserDefaults?

    // Variable
//    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        NotificationCenter.defaultCenter().addObserver(self, selector: "dataReceived:", name: "SpecialKey", object: nil)
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
        self.fetchDataFromSharedContainer()
        self.widgetView.setNeedsDisplay()
        print("viewdidload")
//        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didReceiveData"), object: nil)
//        print("starting to observe")
        

    }
       
    
    //MARK: Private Methods
    /// This method fetches the data to be displayed in widget from shared container.
    fileprivate func fetchDataFromSharedContainer()
    {
        print("in #fetchDataFromSharedContainer")
        if let sharedContainer = self.sharedContainer {
            print("get shared container, now next")
            if let selectedCountry = sharedContainer.string(forKey: "selectedCountry")
            {
                print("in set label")
                print(selectedCountry)
                self.countryLabel.text = String(selectedCountry).uppercased()
                
            }
        } else {
            print("Not in set label")
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // Widget receive courty data from main view controller
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("Received Data")
        print(notification.userInfo!)
         
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
        print(json[0]["cases"].stringValue)
        casesNumLabel.text = json[0]["cases"].stringValue
        deathNumLabel.text = json[0]["deaths"].stringValue
        recoverdNumLabel.text = json[0]["recovered"].stringValue
        todayCasesNumLabel.text = json[0]["todayCases"].stringValue
        todayDeathNumLabel.text = json[0]["todayDeaths"].stringValue
        criticalNumLabel.text = json[0]["critical"].stringValue

    }
    
    //MARK: - Location Manager Delegate Methods
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[locations.count-1]
//        if location.horizontalAccuracy > 0 {
//            locationManager.stopUpdatingLocation()
//            
//            print("longtitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
//            
//            let latitude = String(location.coordinate.latitude)
//            let longtitude = String(location.coordinate.longitude)
//            
//            let params : [String : String] = ["lat" : latitude, "lon" : longtitude, "appid" : APP_ID]
//            print("Param is \(params)")
//            
//            getCoroData(url: CORONAVIRUS_URL)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//        countryLabel.text = "Location Unavailable"
//        
//    }
        
}
