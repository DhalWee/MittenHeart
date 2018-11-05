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
    
    var index: Int = 0
    var title: [[String]] = [["Мой ребёнок", "Мои дети"],
                           ["Подписка"],
                           ["Чат"],
                           ["Дополнительно"],
                           ["Настройки"]]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lightImg.layer.cornerRadius = lightImg.bounds.height/2
        addLineToView(view: self.contentView, position: .bottom, color: UIColor.init(hex: lightGray), width: 0.5)
    }
    
    func setHeader(_ index: Int) {
        if index == 0 {
            actionBtn.isHidden = false
        } else {
            actionBtn.isHidden = true
        }
        titlelLbl.text = title[index][0]
        lightImg.image = UIImage(named: "\(index)Light")
    }
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        actionBtn.rotate360Degrees()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
