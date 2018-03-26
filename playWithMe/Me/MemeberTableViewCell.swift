//
//  MemeberTableViewCell.swift
//  playWithMe
//
//  Created by murray on 2018/3/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class MemeberTableViewCell: UITableViewCell {
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var creditLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        creditLB.layer.cornerRadius = 30.0
        creditLB.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
