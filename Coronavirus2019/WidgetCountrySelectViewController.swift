//
//  WidgetCountrySelectViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/23/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI


class WidgetCountrySelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate {

    
//    var countryArray = ["China","Italy","Iran","S.Korea","Spain","Germany","USA","Japan","Switzerland","Netherlands","UK","Norway","Belgium","Denmark","Austria","Singapore","Malaysia","Hong Kong","Bahrain","Austrlia","Greece","Canada","UAE","Iraq","Iceland"]
//
    var globalData : JSON?
    var countriesData : JSON?
    var currentSelectedRow = 0
    let COUNTRIES_FILENAME = "countries.json"
    let GLOBAL_FILENAME = "global.json"
    
    private var sharedContainer : UserDefaults?
    private let kAppGroupName = "group.mia.tsung.com.2019coro"

    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var feedbackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Consts.MAIN_BG_COLOR        

        // Do any additional setup after loading the view.
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
        
        // choose row
        presetPickerViewSelection()
        fetchData()
    }
    
    func fetchData() {
        self.countriesData = self.readCountriesDataFromLocalFile()
        self.globalData = self.readGlobalDataFromLocalFile()
        countryPickerView.reloadAllComponents()

    }
        
    //reading global data from output.txt
    func readGlobalDataFromLocalFile() -> JSON {
        do {
            let filepath = getGlobalLocalBackupJsonPath()
            print(filepath)
            let content = try String(contentsOf: filepath, encoding: .utf8)
            print(content)
            
            let json = JSON(parseJSON: content)
            return json
        }
        catch {/* error handling here */
            print("Parsing JSON failed")
            return JSON.init(parseJSON: "")
        }
    }
       
    func getGlobalLocalBackupJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")
        let file = GLOBAL_FILENAME //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(file)
        }
        return path
    }

    func readCountriesDataFromLocalFile() -> JSON {
        do {
            let filepath = getCountriesLocalBackupJsonPath()
            print(filepath)
            let content = try String(contentsOf: filepath, encoding: .utf8)
            print(content)
            
            let json = JSON(parseJSON: content)
            return json
        }
        catch {/* error handling here */
            print("Parsing JSON failed")
            return JSON.init(parseJSON: "")
        }
    }
    
    func getCountriesLocalBackupJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")
        let file = COUNTRIES_FILENAME //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(file)
        }
        return path
    }
        
    func presetPickerViewSelection() {
        if let _sharedContainer = self.sharedContainer {
            let selectedCountry = _sharedContainer.string(forKey: "selectedCountry")
            
            if selectedCountry == "Global" {
                return
            }
            
            if let _countriesArray = countriesData?.array {
                for (index, countryObj) in _countriesArray.enumerated() {
                    if countryObj["country"].stringValue == selectedCountry {
                        currentSelectedRow = index + 1
                        return
                    }
                }
            }
        }
        
        countryPickerView.selectRow(currentSelectedRow, inComponent:0, animated:true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let countriesArray = countriesData?.array {
            return countriesArray.count + 1
        } else {
            return 1
        }
    }
     
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let sharedContainer = self.sharedContainer {
            print("get sharedcontainer")
            if row == 0 {
                sharedContainer.set("Global", forKey: "selectedCountry")
                
                print("global data", globalData)
                
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

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string : String!
        if row == 0 {
            string = CountriesDict.NAMES["Global"]
        } else {
            string = CountriesDict.NAMES[ (countriesData?.array![row-1]["country"].stringValue)! ]
        }
        
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction func sendFeedbackEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mia.tsung311@gmail.com"])
            mail.setMessageBody("<p>Hello, I have some feedbacks to COVID 19 tracker app</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            print("open mail failed")
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
