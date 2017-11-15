//
//  ShoutButtonView.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 13.11.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import UIKit
import RxSwift

class ShoutButtonView: UIView {

    private let nibName: String = "ShoutButtonView"
  
    private(set) var shout: PublishSubject<Void> = PublishSubject<Void>()
    
    @IBAction func shoutTapped(_ sender: UIButton) {
        self.shout.onNext(())
    }
    
    override init(frame: CGRect) {
        let phoneFrame = UIScreen.main.bounds
        let viewHeight: CGFloat = phoneFrame.height/5
        let viewFrame: CGRect = CGRect(x: 0, y: phoneFrame.height - viewHeight, width: phoneFrame.width, height: viewHeight)
        super.init(frame: viewFrame)
        self.setupXib(withNibNamed: self.nibName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupXib(withNibNamed: self.nibName)
    }
}
