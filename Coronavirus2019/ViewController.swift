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
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
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
//        getCoconavirusData()
    }


}

