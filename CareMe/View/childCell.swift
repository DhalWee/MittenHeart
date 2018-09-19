//
//  childCell.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class childCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameAndSurname: UILabel!
    @IBOutlet weak var desc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addLineToView(view: lineView, position: .LINE_POSITION_BOTTOM, color: UIColor.init(hex: lightGray), width: 0.5)
    }
    
    func setChild(_ nameAndSurname: String,_ desc: String,_ imgName: String) {
        self.nameAndSurname.text = nameAndSurname
        self.desc.text = desc
        self.img.image = UIImage(named: imgName)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
