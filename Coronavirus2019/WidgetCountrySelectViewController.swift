//
//  WidgetCountrySelectViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/23/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit
import SwiftyJSON

class WidgetCountrySelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
//    var countryArray = ["China","Italy","Iran","S.Korea","Spain","Germany","USA","Japan","Switzerland","Netherlands","UK","Norway","Belgium","Denmark","Austria","Singapore","Malaysia","Hong Kong","Bahrain","Austrlia","Greece","Canada","UAE","Iraq","Iceland"]
//
    var globalData : JSON?
    var countriesData : JSON?
              
    var selectedCountry = ""
    var selectedRow = 0
    var countOfCountries = 0
    
    private var sharedContainer : UserDefaults?
    private let kAppGroupName = "group.mia.tsung.com.2019coro"
    

    @IBOutlet weak var countryPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
       
       
       
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let countriesArray = countriesData?.array {
            countOfCountries = countriesArray.count + 1
            return countOfCountries
        } else {
            return 1
        }
    }
     
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Global"
        } else {
            return countriesData?.array![row-1]["country"].stringValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        
        if let sharedContainer = self.sharedContainer {
            print("get sharedcontainer")
            if row == 0 {
                sharedContainer.set("Global", forKey: "selectedCountry")
                
                sharedContainer.set(globalData?["cases"].stringValue, forKey: "cases")
                sharedContainer.set(globalData?["deaths"].stringValue, forKey: "deaths")
                sharedContainer.set(globalData?["recovered"].stringValue, forKey: "recovered")
                sharedContainer.set("-", forKey: "todayCases")
                sharedContainer.set("-", forKey: "todayDeaths")
                sharedContainer.set("-", forKey: "critical")

            } else {
            
                if let selectedCountryObj = countriesData?.array![row - 1] {
                    print("get contry obj")
                    sharedContainer.set(selectedCountryObj["country"].stringValue, forKey: "selectedCountry")
                    
                    sharedContainer.set(selectedCountryObj["cases"].stringValue, forKey: "cases")
                    sharedContainer.set(selectedCountryObj["deaths"].stringValue, forKey: "deaths")
                    sharedContainer.set(selectedCountryObj["recovered"].stringValue, forKey: "recovered")
                    sharedContainer.set(selectedCountryObj["todayCases"].stringValue, forKey: "todayCases")
                    sharedContainer.set(selectedCountryObj["todayDeaths"].stringValue, forKey: "todayDeaths")
                    sharedContainer.set(selectedCountryObj["critical"].stringValue, forKey: "critical")
                }
            }
            
            sharedContainer.synchronize()
            print("Write data to shared")
        }
    }

}
