//
//  ViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/9/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let countryArray = ["China","Italy","Iran","S.Korea","Spain","Germany","USA","Japan","Switzerland","Netherlands","UK","Norway","Belgium","Denmark","Austria","Singapore","Malaysia","Hong Kong","Bahrain","Austrlia","Greece","Canada","UAE","Iraq","Iceland"]
    var selectedCountry = ""
    private var sharedContainer : UserDefaults?
    private let kAppGroupName = "group.mia.tsung.com.2019coro"
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.selectRow(0, inComponent: 0, animated: true)
            
        self.sharedContainer = UserDefaults(suiteName: kAppGroupName)
        
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
        
//        NotificationCenter.default.post(name: Notification.Name("didReceiveData"), object: self, userInfo: ["country": self.selectedCountry])
//        print("posted")
//        getCoconavirusData()
        
        
        
    }
}

