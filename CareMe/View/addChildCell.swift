//
//  addChildCell.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class addChildCell: UITableViewCell {
    
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLineTop(_ bool: Bool) {
        addLineToView(view: self.contentView, position: (bool ? .LINE_POSITION_TOP : .LINE_POSITION_BOTTOM), color: UIColor.init(hex: lightGray), width: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
