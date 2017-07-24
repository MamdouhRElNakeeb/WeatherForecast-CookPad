//
//  Day7ForecastTVCell.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/25/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import UIKit

class Day7ForecastTVCell: UITableViewCell {

    @IBOutlet weak var dayNameL: UILabel!
    @IBOutlet weak var tempMinMaxL: UILabel!
    @IBOutlet weak var weatherStateIV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
