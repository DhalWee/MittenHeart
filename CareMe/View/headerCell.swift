//
//  headerCell.swift
//  CareMe
//
//  Created by baytoor on 9/19/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit

class headerCell: UITableViewCell {
    
    @IBOutlet weak var lightImg: UIImageView!
    @IBOutlet weak var titlelLbl: UILabel!
    @IBOutlet weak var actionBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLineTop(_ bool: Bool) {
        addLineToView(view: self.contentView, position: (bool ? .LINE_POSITION_TOP : .LINE_POSITION_BOTTOM), color: UIColor.init(hex: lightGray), width: 0.5)
    }
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        actionBtn.rotate360Degrees()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
