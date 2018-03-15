//
//  ActivityTableViewCell.swift
//  playWithMe
//
//  Created by Murray on 2018/2/26.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

extension UIView {
    
    func setCardView(view : UIView){
        
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 3.0;
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.backgroundColor = UIColor.white

    }
}

extension UIButton {
    static func setButton(button: UIButton){
        button.layer.cornerRadius = 5.0
        //button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        //button.backgroundColor = UIColor.greenColor()
        button.layer.backgroundColor = UIColor.blue.cgColor
        
    }
}


class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var addBT: UIButton!
    
    override func awakeFromNib() {
        backgroundCardView.backgroundColor = UIColor.white
        setCardView(view: backgroundCardView)
        
        activityImage.layer.cornerRadius = 3.0
        activityImage.layer.masksToBounds = true
        
        UIButton.setButton(button: addBT)
        
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func add(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
