//
//  ViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/9/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Constants
    let GLOBAL_URL = "https://corona.lmao.ninja/all"
    let CORONAVIRUS_URL = "https://corona.lmao.ninja/countries"
    let fileURL = ""
    
    let countryArray = ["China","Italy","Iran","S.Korea","Spain","Germany","USA","Japan","Switzerland","Netherlands","UK","Norway","Belgium","Denmark","Austria","Singapore","Malaysia","Hong Kong","Bahrain","Austrlia","Greece","Canada","UAE","Iraq","Iceland"]
    
    
    var selectedCountry = ""
    private var sharedContainer : UserDefaults?
    private let kAppGroupName = "group.mia.tsung.com.2019coro"
    private var coronaData : JSON?
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.selectRow(0, inComponent: 0, animated: true)
            
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
        
        getCoronaData()
    }
    
    //3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        self.selectedCountry = countryArray[row]
        return countryArray[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = countryArray[row]
        print(self.selectedCountry)
        
        if let sharedContainer = self.sharedContainer
        {
            sharedContainer.set(self.selectedCountry, forKey: "selectedCountry")
            sharedContainer.synchronize()
            print("Write data to shared")
        }

        
    }
    
    //Networking
    func getCoronaData() {

        var jsonData:JSON?
        Alamofire.request(CORONAVIRUS_URL, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got coro data")
                jsonData = JSON(response.result.value!)
                print(jsonData)
                self.saveJsonToFile(json: jsonData!, filepath: self.getLocalCacheJsonPath())
                
                self.coronaData = jsonData
            } else {
                print("Error \(String(describing: response.result.error))")
                self.coronaData = self.readDataFromLocalFile()
            }
        }
//
//        if let jsonResponse = getApiData() {
//            // get data from online successful
//            print("get data from online successful")
//            print(jsonResponse)
//            print(getLocalCacheJsonPath())
//            saveJsonToFile(json: jsonResponse, filepath: getLocalCacheJsonPath())
//            return jsonResponse
//        } else {
//            print("get data from online failed")
//            return readDataFromLocalFile()
//        }
    }
//
//    func getApiData() -> JSON? {
//        var jsonData:JSON?
//        Alamofire.request(CORONAVIRUS_URL, method: .get).responseJSON { response in
//            if response.result.isSuccess {
//                print("Success! Got coro data")
//
//                jsonData = JSON(response.result.value!)
//                print(jsonData)
//                self.saveJsonToFile(json: jsonData!, filepath: self.getLocalCacheJsonPath())
//
//                self.coronaData = jsonData
//            } else {
//                print("Error \(String(describing: response.result.error))")
//                self.coronaData = self.readDataFromLocalFile()
//            }
//        }
//
//        return jsonData
//    }
    
    func getLocalCacheJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")
        let file = "api.json" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(file)
        }
        return path
    }
    
    func saveJsonToFile(json:JSON, filepath:URL) {
        let coroDataStr = json.rawString() //just a text
        
        //writing
        do {
            print(coroDataStr)
            try coroDataStr!.write(to: filepath, atomically: true, encoding: .utf8)
            print("Success in writing corodata to local file")
        }
        catch {
            print("Fail in writing corodata to local file")
        }
            
    }
    
    
    //reading data from output.txt
    func readDataFromLocalFile() -> JSON {
        do {
            let filepath = getLocalCacheJsonPath()
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
       
    
   
    func updateUI() {
        
    }
//       func updateCoroData(json : JSON) {
//           print(json[0]["cases"].stringValue)
//           casesNumLabel.text = json[0]["cases"].stringValue
//           deathNumLabel.text = json[0]["deaths"].stringValue
//           recoverdNumLabel.text = json[0]["recovered"].stringValue
//           todayCasesNumLabel.text = json[0]["todayCases"].stringValue
//           todayDeathNumLabel.text = json[0]["todayDeaths"].stringValue
//           criticalNumLabel.text = json[0]["critical"].stringValue
//
//       }
//
}

