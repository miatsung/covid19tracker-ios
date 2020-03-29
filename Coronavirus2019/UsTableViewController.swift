//
//  UsTableViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/28/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UsTableViewController: UITableViewController {

    let US_API = "https://covidtracking.com/api/states"
    var usJsonData : JSON?
    let US_LOCAL_FILENAME = "us.json"
    
    var langStr = Locale.current.languageCode
    
    let symbolToStateZh = [
        "AL": "阿拉巴马州",
        "AK": "阿拉斯加州",
        "AS": "美属萨摩亚",
        "AZ": "亚利桑那",
        "AR": "阿肯色州",
        "CA": "加利福尼亚州",
        "CO": "科罗拉多州",
        "CT": "康乃狄克州",
        "DE": "特拉华州",
        "DC": "哥伦比亚特区",
        "FM": "密克罗尼西亚联邦",
        "FL": "佛罗里达",
        "GA": "佐治亚州",
        "GU": "关岛",
        "HI": "夏威夷",
        "ID": "爱达荷州",
        "IL": "伊利诺伊州",
        "IN": "印第安那州",
        "IA": "爱荷华州",
        "KS": "堪萨斯州",
        "KY": "肯塔基州",
        "LA": "路易斯安那州",
        "ME": "缅因州",
        "MH": "马绍尔群岛",
        "MD": "马里兰州",
        "MA": "马萨诸塞州",
        "MI": "密西根州",
        "MN": "明尼苏达州",
        "MS": "密西西比州",
        "MO": "密苏里州",
        "MT": "蒙大拿",
        "NE": "内布拉斯加",
        "NV": "内华达州",
        "NH": "新罕布什尔",
        "NJ": "新泽西州",
        "NM": "新墨西哥",
        "NY": "纽约",
        "NC": "北卡罗来纳",
        "ND": "北达科他州",
        "MP": "北马里亚纳群岛",
        "OH": "俄亥俄",
        "OK": "俄克拉荷马州",
        "OR": "俄勒冈州",
        "PW": "帕劳",
        "PA": "宾夕法尼亚州",
        "PR": "波多黎各",
        "RI": "罗德岛",
        "SC": "南卡罗来纳",
        "SD": "南达科他州",
        "TN": "田纳西州",
        "TX": "德州",
        "UT": "犹他州",
        "VT": "佛蒙特",
        "VI": "维尔京群岛",
        "VA": "维吉尼亚州",
        "WA": "华盛顿州",
        "WV": "西弗吉尼亚",
        "WI": "威斯康星州",
        "WY": "怀俄明"
    ]
    
    let symbolToState = [
        "AL": "Alabama",
        "AK": "Alaska",
        "AS": "American Samoa",
        "AZ": "Arizona",
        "AR": "Arkansas",
        "CA": "California",
        "CO": "Colorado",
        "CT": "Connecticut",
        "DE": "Delaware",
        "DC": "District Of Columbia",
        "FM": "Federated States Of Micronesia",
        "FL": "Florida",
        "GA": "Georgia",
        "GU": "Guam",
        "HI": "Hawaii",
        "ID": "Idaho",
        "IL": "Illinois",
        "IN": "Indiana",
        "IA": "Iowa",
        "KS": "Kansas",
        "KY": "Kentucky",
        "LA": "Louisiana",
        "ME": "Maine",
        "MH": "Marshall Islands",
        "MD": "Maryland",
        "MA": "Massachusetts",
        "MI": "Michigan",
        "MN": "Minnesota",
        "MS": "Mississippi",
        "MO": "Missouri",
        "MT": "Montana",
        "NE": "Nebraska",
        "NV": "Nevada",
        "NH": "New Hampshire",
        "NJ": "New Jersey",
        "NM": "New Mexico",
        "NY": "New York",
        "NC": "North Carolina",
        "ND": "North Dakota",
        "MP": "Northern Mariana Islands",
        "OH": "Ohio",
        "OK": "Oklahoma",
        "OR": "Oregon",
        "PW": "Palau",
        "PA": "Pennsylvania",
        "PR": "Puerto Rico",
        "RI": "Rhode Island",
        "SC": "South Carolina",
        "SD": "South Dakota",
        "TN": "Tennessee",
        "TX": "Texas",
        "UT": "Utah",
        "VT": "Vermont",
        "VI": "Virgin Islands",
        "VA": "Virginia",
        "WA": "Washington",
        "WV": "West Virginia",
        "WI": "Wisconsin",
        "WY": "Wyoming"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        langStr = Locale.current.languageCode

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.backgroundColor = Consts.MAIN_BG_COLOR
        fetchData()
    }
    
    func fetchData() {
        var jsonData:JSON?
        Alamofire.request(US_API, method: .get).responseJSON { response in
            if response.result.isSuccess {
                jsonData = JSON(response.result.value!)
                               
                let arrayJsonData = jsonData?.arrayValue
                let sortedJsonData = arrayJsonData!.sorted { $0["positive"].intValue > $1["positive"].intValue }
                                
                self.usJsonData = JSON(sortedJsonData)
                self.saveUsJsonToFile(json: self.usJsonData!, filepath: self.getUsLocalBackupJsonPath())
                
                self.tableView.reloadData()
            } else {
                print("Error \(String(describing: response.result.error))")
                self.usJsonData = self.readUsDataFromLocalFile()
            }
            
            // update data in the view
            if let _usJsonData = self.usJsonData {
                self.updateUsJsonData(json: _usJsonData)
            } else {
                self.usJsonData = []
            }
        }
    }
    
    func getUsLocalBackupJsonPath() -> URL {
        var path : URL = URL.init(fileURLWithPath: "")

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path = dir.appendingPathComponent(US_LOCAL_FILENAME)
        }
        return path
    }
    
    // TODO: refactor this method
    func saveUsJsonToFile(json:JSON, filepath:URL) {
        let coroDataStr = json.rawString() //just a text
        
        do {
            try coroDataStr!.write(to: filepath, atomically: true, encoding: .utf8)
            print("Success in writing global corodata to local file")
        }
        catch {
            print("Fail in writing global corodata to local file")
        }
           
    }
    
    //reading US data from local file
    func readUsDataFromLocalFile() -> JSON {
        do {
            let filepath = getUsLocalBackupJsonPath()
            let content = try String(contentsOf: filepath, encoding: .utf8)
            
            let json = JSON(parseJSON: content)
            return json
        }
        catch {/* error handling here */
            print("Parsing US JSON failed")
            return JSON.init(parseJSON: "")
        }
    }

    
    func updateUsJsonData(json: JSON) {
//        coroDataModel.globalCasesNum = json["cases"].intValue
//        coroDataModel.globalDeathsNum = json["deaths"].intValue
//        coroDataModel.globalRecoverNum = json["recovered"].intValue
//        coroDataModel.globalActiveNum = json["active"].intValue
//
//        updateUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usJsonData?.arrayValue.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! StateCell
        cell.backgroundColor = UIColor.clear
        
        if let stateObj = self.usJsonData?.arrayValue[indexPath.row] {
            if langStr == "zh" {
                cell.stateLabel.text = symbolToStateZh[stateObj["state"].stringValue]
            }
            else {
                cell.stateLabel.text = symbolToState[stateObj["state"].stringValue]
            }
            cell.confirmedLabel.text = stateObj["positive"].stringValue
            cell.deathsLabel.text = stateObj["death"].stringValue
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
