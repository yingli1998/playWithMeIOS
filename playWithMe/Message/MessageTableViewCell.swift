//
//  messageTableViewCell.swift
//  playWithMe
//
//  Created by Murray on 2018/2/25.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var MessageLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
