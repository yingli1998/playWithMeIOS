//
//  RuningActivityCell.swift
//  playWithMe
//
//  Created by murray on 2018/3/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class RuningActivityCell: UITableViewCell {

    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var finishBT: UIButton!
    @IBOutlet weak var numLB: UILabel!
    @IBOutlet weak var activityLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backImageView.backgroundColor = UIColor.clear
        
        finishBT.layer.borderColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0).cgColor
        finishBT.layer.borderWidth = 1.0
        finishBT.layer.cornerRadius = 10.0
        finishBT.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func finish(_ sender: Any) {
    }
}
