//
//  StateCell.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/28/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import UIKit

class StateCell: UITableViewCell {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
