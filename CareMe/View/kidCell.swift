//
//  childCell.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class kidCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameAndSurname: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var batteryImg: UIImageView!
    @IBOutlet weak var batteryPercentage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = img.bounds.height/2
        addLineToView(view: lineView, position: .bottom, color: UIColor.init(hex: lightGray), width: 0.5)
    }
    
    func setKid(_ nameAndSurname: String,_ desc: String,_ imgName: String,_ batteryPercentage: String ) {
        self.nameAndSurname.text = nameAndSurname
        self.desc.text = desc
        self.img.image = UIImage(named: imgName)
        self.batteryPercentage.text = "\(batteryPercentage) %"
        if let percentage = Int(batteryPercentage) {
            if percentage > 80 {
                self.batteryImg.image = UIImage(named: "Battery100")
            } else if percentage > 60 {
                self.batteryImg.image = UIImage(named: "Battery75")
            } else if percentage > 40 {
                self.batteryImg.image = UIImage(named: "Battery60")
            } else if percentage > 20 {
                self.batteryImg.image = UIImage(named: "Battery40")
            } else if percentage > 10 {
                self.batteryImg.image = UIImage(named: "Battery20")
            } else {
                self.batteryImg.image = UIImage(named: "Battery5")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
