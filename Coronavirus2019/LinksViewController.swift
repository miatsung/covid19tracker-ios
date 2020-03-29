//
//  LinksViewController.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/28/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit

class LinksViewController: UIViewController {


    @IBOutlet weak var bingLinkButton: UIButton!
    @IBOutlet weak var gisandButton: UIButton!
    @IBOutlet weak var onePointButton: UIButton!
    @IBOutlet weak var v2019nButton: UIButton!
    @IBOutlet weak var cdcButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bingLinkButton.addTarget(self, action: Selector(("go to Bing")), for: .touchUpInside)
        view.backgroundColor = Consts.MAIN_BG_COLOR
        bingLinkButton.setTitleColor(Consts.LINK_COLOR, for: .normal)
        gisandButton.setTitleColor(Consts.LINK_COLOR, for: .normal)
        onePointButton.setTitleColor(Consts.LINK_COLOR, for: .normal)
        v2019nButton.setTitleColor(Consts.LINK_COLOR, for: .normal)
        cdcButton.setTitleColor(Consts.LINK_COLOR, for: .normal)
        
    }
    

    @IBAction func bingButtonClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://bing.com/covid")!)
    }
    
    @IBAction func gisandButtonClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6")!)
    }
    
    @IBAction func onePointButtonClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://coronavirus.1point3acres.com/en")!)
    }
    
    @IBAction func v2019nButtonCLicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://twitter.com/v2019n")!)
    }
    
    @IBAction func cdcButtonClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://twitter.com/CDCemergency")!)
    }
    
    
//    override func viewDidLoad() {
//    let attributedString = NSMutableAttributedString(string: "Want to learn iOS?")
//    attributedString.addAttribute(.link, value: "https://bing.com/covid", range: NSRange(location: 19, length: 55))
//
//    bingLink.attributedText = attributedString
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        UIApplication.shared.open(URL)
//        return false
//    }
//
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
