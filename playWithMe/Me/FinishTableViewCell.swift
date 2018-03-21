//
//  FinishTableViewCell.swift
//  playWithMe
//
//  Created by murray on 2018/3/20.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class FinishTableViewCell: UITableViewCell {

    @IBOutlet weak var backCardView: UIView!
    @IBOutlet weak var rateBT: UIButton!
    @IBOutlet weak var numLB: UILabel!
    @IBOutlet weak var activityLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backCardView.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
