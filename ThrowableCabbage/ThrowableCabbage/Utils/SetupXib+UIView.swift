//
//  SetupXib+UIView.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 13.11.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupXib(withNibNamed nibName: String) {
        
        let mainView = self.loadViewFromNib(nibName: nibName)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainView)
        
        mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}
