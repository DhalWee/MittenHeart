//
//  ChatMessageCell.swift
//  CareMe
//
//  Created by baytoor on 11/18/18.
//  Copyright © 2018 unicorn. All rights reserved.
//

import UIKit
import PureLayout

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.text = "Some example text"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textColor = UIColor(hex: preBlack)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
//        backgroundColor = UIColor(hex: green)
        
        textView.autoSetDimensions(to: CGSize(width: 200, height: self.bounds.height))
        textView.autoPinEdge(.right, to: .right, of: self)
        textView.autoPinEdge(.top, to: .top, of: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
