//
//  MessageDetailCell.swift
//  CareMe
//
//  Created by baytoor on 11/13/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import PureLayout

class MessageDetailCell: UITableViewCell {
    
    var messageDetail: MessageDetail!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMsg(_ msg: MessageDetail) {
        bubbleView(msg)
    }
    
    private func bubbleView(_ msg: MessageDetail) {
        
        var role: Int {
            if defaults.string(forKey: "role") == "parent" {
                return 0
            } else {
                return 1
            }
        }
        
        let myID = defaults.string(forKey: "uid")
        
        var backgroundColor: UIColor {
            
            if role == Int(msg.type) {
                return UIColor(hex: green)
            } else {
                return UIColor(hex: msgGrey)
            }
        }
        
        let height = estimateFrameForText(text: msg.message).height
        let width = estimateFrameForText(text: msg.message).width
        
        var textColor: UIColor {
            if role == Int(msg.type) {
                return UIColor(hex: preWhite)
            } else {
                return UIColor(hex: preBlack)
            }
        }
        
        let bubbleView: UIView = {
            let bv = UIView()
            bv.layer.masksToBounds = true
            bv.backgroundColor = backgroundColor
            bv.autoSetDimensions(to: CGSize(width: width+25, height: height+20))
            bv.layer.cornerRadius = 15
            return bv
        }()
        
        let msgLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = msg.message
            lbl.textColor = textColor
            lbl.font = UIFont(name: "Montserrat-Medium", size: 14)
//            lbl.autoresizingMask
            lbl.numberOfLines = 0
            return lbl
        }()
        
        let dateLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = msg.date
            lbl.textColor = UIColor(hex: darkGrey)
            lbl.font = UIFont(name: "Montserrat", size: 10)
            return lbl
        }()
        
        self.addSubview(bubbleView)
        self.addSubview(dateLbl)
        bubbleView.addSubview(msgLbl)
        
        bubbleView.autoPinEdge(.top, to: .top, of: self, withOffset: 8)
        
        if Int(msg.type)! != role {
            bubbleView.autoPinEdge(.left, to: .left, of: self, withOffset: 8)
            dateLbl.autoPinEdge(.leading, to: .leading, of: bubbleView, withOffset: 7)
        } else {
            bubbleView.autoPinEdge(.right, to: .right, of: self, withOffset: -8)
            dateLbl.autoPinEdge(.trailing, to: .trailing, of: bubbleView, withOffset: -7)
        }
        msgLbl.autoPinEdge(.leading, to: .leading, of: bubbleView, withOffset: 10)
        msgLbl.autoPinEdge(.trailing, to: .trailing, of: bubbleView, withOffset: 10)
        msgLbl.autoPinEdge(.top, to: .top, of: bubbleView)
        msgLbl.autoPinEdge(.bottom, to: .bottom, of: bubbleView)
        
        dateLbl.autoPinEdge(.top, to: .bottom, of: bubbleView, withOffset: 5)
        
    }

}
