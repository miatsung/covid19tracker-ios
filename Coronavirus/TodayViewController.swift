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
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var recoverLabel: UILabel!
    @IBOutlet weak var todayConLabel: UILabel!
    @IBOutlet weak var todayDeLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    
    
    @IBOutlet weak var widgetView: UIView!
    
    // Constants
    
    let GLOBAL_URL = "https://corona.lmao.ninja/all"
    let CORONAVIRUS_URL = "https://corona.lmao.ninja/countries"

    let buttonTitle = NSLocalizedString("bear", comment: "The name of the animal")
    private let kAppGroupName = "group.mia.tsung.com.2019coro"
    private var sharedContainer : UserDefaults?
    
    private var langStr : String!
    
    // Variable
//    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        countryLabel.textColor = .white
//        confirmedLabel.textColor = .white
//        deathLabel.textColor = .white
//        recoverLabel.textColor = .white
//        todayConLabel.textColor = .white
//        todayDeLabel.textColor = .white
//        criticalLabel.textColor = .white
        
        langStr = Locale.current.languageCode
        
        casesNumLabel.textColor = .systemOrange // orange
        todayCasesNumLabel.textColor = .systemOrange
        deathNumLabel.textColor = .systemRed // red
        todayDeathNumLabel.textColor = .systemRed
        recoverdNumLabel.textColor = .systemGreen // green
        criticalNumLabel.textColor = .systemBlue // blue
        
//        casesNumLabel.textColor = UIColor(red: 240, green: 170, blue: 105, alpha: 1) // orange
//        todayCasesNumLabel.textColor = UIColor(red: 240, green: 170, blue: 105, alpha: 1)
//        deathNumLabel.textColor = UIColor(red: 192, green: 110, blue: 129, alpha: 1) // red
//        todayDeathNumLabel.textColor = UIColor(red: 192, green: 110, blue: 129, alpha: 1)
//        recoverdNumLabel.textColor = UIColor(red: 139, green: 183, blue: 155, alpha: 1) // green
//        criticalNumLabel.textColor = UIColor(red: 23, green: 190, blue: 214, alpha: 1) // blue
        
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
        self.fetchDataFromSharedContainer()
        self.widgetView.setNeedsDisplay()
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
                if langStr == "zh" {
                    self.countryLabel.text = CountriesDict.NAMES[ String(selectedCountry) ]
                } else {
                    self.countryLabel.text = String(selectedCountry).uppercased()
                }
            }
            
            if let value = sharedContainer.string(forKey: "cases") {
                self.casesNumLabel.text = value
            } else {
                self.casesNumLabel.text = "-"
            }
            
            if let value = sharedContainer.string(forKey: "deaths") {
                self.deathNumLabel.text = value
            } else {
                self.deathNumLabel.text = "-"
            }
            
            if let value = sharedContainer.string(forKey: "recovered") {
                self.recoverdNumLabel.text = value
            } else {
                self.recoverdNumLabel.text = "-"
            }
            
            if let value = sharedContainer.string(forKey: "todayCases") {
                self.todayCasesNumLabel.text = value
            } else {
                self.todayCasesNumLabel.text = "-"
            }
            
            if let value = sharedContainer.string(forKey: "todayDeaths") {
                self.todayDeathNumLabel.text = value
            } else {
                self.todayDeathNumLabel.text = "-"
            }
            
            if let value = sharedContainer.string(forKey: "critical") {
                self.criticalNumLabel.text = value
            } else {
                self.criticalNumLabel.text = "-"
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

        
}
