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
                           ["Еще"],
                           ["Настройки"]]
    
    var light: [UIImage] = [UIImage(named: "HomeLight")!,
                            UIImage(named: "SubscribeLight")!,
                            //HTC delete chat image
                            UIImage(named: "SettingsLight")!,
                            UIImage(named: "FunctionsLight")!,
                            UIImage(named: "SettingsLight")!]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addLineToView(view: self.contentView, position: .LINE_POSITION_BOTTOM, color: UIColor.init(hex: lightGray), width: 0.5)
    }
    
    func setHeader(_ index: Int) {
        titlelLbl.text = title[index][0]
        lightImg.image = light[index]
    }
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        actionBtn.rotate360Degrees()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
