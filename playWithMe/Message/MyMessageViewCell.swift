//
//  MyMessageViewCell.swift
//  playWithMe
//
//  Created by murray on 2018/4/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class MyMessageViewCell: UITableViewCell {
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
