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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    // Constants
    let defaults = UserDefaults.standard
    
    let GLOBAL_URL = "https://corona.lmao.ninja/all"
    let COUNTRIES_URL = "https://corona.lmao.ninja/countries"
    let globalFileURL = ""
    let FileURL = ""
    
    let coroDataModel = CoroDataModel()
    
    var countryArray = ["China","Italy","Iran","S.Korea","Spain","Germany","USA","Japan","Switzerland","Netherlands","UK","Norway","Belgium","Denmark","Austria","Singapore","Malaysia","Hong Kong","Bahrain","Austrlia","Greece","Canada","UAE","Iraq","Iceland"]
          

   
    private var globalCoronaData : JSON?
    private var countriesCoronaData : JSON?
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!

    @IBOutlet weak var globalCasesLabel: UILabel!
    @IBOutlet weak var globalDeathsLabel: UILabel!
    @IBOutlet weak var globalRecoverLabel: UILabel!

    @IBOutlet weak var countryDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        label1.layer.cornerRadius = 14
//
        getGlobalCoronaData()
        getCountryCoronaData()
        
        countryDataTableView.delegate = self
        countryDataTableView.dataSource = self
        
        // Register CountryDataTableViewCell.xib
        countryDataTableView.register(UINib(nibName: "CountryDataTableViewCell", bundle: nil), forCellReuseIdentifier: "customCountryDataCell")
    
        
    }
    
    
    
    
    
    // CountryTableView delegate & datasource protocols
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCountryDataCell", for: indexPath) as! CountryDataTableViewCell
        let index = indexPath.row
        
        if let countryObj = countriesCoronaData?.array![index] {
            cell.countryNameLabel.text = countryObj["country"].stringValue
                   cell.confirmedNumLabel.text = countryObj["cases"].stringValue
                   cell.deathsNumLabel.text = countryObj["deaths"].stringValue
                   cell.revoceredNumLabel.text = countryObj["recovered"].stringValue
        } else {
            regionLabel.text = "Data unavailable, please try again later"
        }
       
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    //Networking & async call save to local
        //Global
    func getGlobalCoronaData() {

        var jsonData:JSON?
        Alamofire.request(GLOBAL_URL, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got global coro data")
                jsonData = JSON(response.result.value!)
               
                self.saveGlobalJsonToFile(json: jsonData!, filepath: self.getGlobalLocalBackupJsonPath())
                
                self.globalCoronaData = jsonData
            } else {
                print("Error \(String(describing: response.result.error))")
                self.globalCoronaData = self.readGlobalDataFromLocalFile()
            }
            
            if let globalJsonData = self.globalCoronaData {
                self.updateGlobalCorodata(json: globalJsonData)
            } else {
                self.regionLabel.text = "Data unavailable, please try again later"
            }
            
        }
    }

    func getGlobalLocalBackupJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")
        let file = "api.json" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(file)
        }
        return path
    }
    
    //writing
    func saveGlobalJsonToFile(json:JSON, filepath:URL) {
        let coroDataStr = json.rawString() //just a text
        
        do {
            try coroDataStr!.write(to: filepath, atomically: true, encoding: .utf8)
            print("Success in writing global corodata to local file")
        }
        catch {
            print("Fail in writing global corodata to local file")
        }
            
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
       
        
    //Countries
    func getCountryCoronaData() {

        var jsonData:JSON?
        Alamofire.request(COUNTRIES_URL, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got countries coro data")
                jsonData = JSON(response.result.value!)
               
                self.saveCountriesJsonToFile(json: jsonData!, filepath: self.getCountriesLocalBackupJsonPath())
                self.countriesCoronaData = jsonData
                
                if let countriesJsonData = self.countriesCoronaData {
                    self.updateCountriesCorodata(json: countriesJsonData)
                } else {
                    self.regionLabel.text = "Data unavailable, please try again later"
                }
                // set countries
                
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.countriesCoronaData = self.readCountriesDataFromLocalFile()
            }
        }
    }

    
    func getCountriesLocalBackupJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")
        let file = "api.json" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(file)
        }
        return path
    }
    
    
    //writing
    func saveCountriesJsonToFile(json:JSON, filepath:URL) {
        let coroDataStr = json.rawString() //just a text
        
        
        do {
            try coroDataStr!.write(to: filepath, atomically: true, encoding: .utf8)
            print("Success in writing corodata to local file")
        }
        catch {
            print("Fail in writing corodata to local file")
        }
            
    }
    
    
    //reading countries data from output.txt
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
       
    // JSON Parsing
    
    func updateGlobalCorodata(json: JSON) {
        coroDataModel.globalCasesNum = json["cases"].intValue
        coroDataModel.globalDeathsNum = json["deaths"].intValue
        coroDataModel.globalRecoverNum = json["recovered"].intValue
        
        updateUI()
    }
   
    func updateCountriesCorodata(json: JSON) {
        var array : [String] = []
        
        for country : JSON in json.array! {
            array.append(country["country"].stringValue)
        }
        
        countryArray = array
        print(countryArray)
        
        
        countryDataTableView.reloadData()
    }
    
    // UI Update
    func updateUI() {
        globalCasesLabel.text = String(coroDataModel.globalCasesNum)
        globalDeathsLabel.text = String(coroDataModel.globalDeathsNum)
        globalRecoverLabel.text = String(coroDataModel.globalRecoverNum)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWidgetCountryPicker" {
            let destinationVC = segue.destination as! WidgetCountrySelectViewController
            destinationVC.countryArray = countryArray            
        }
    }
}

