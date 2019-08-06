//
//  MDLocalization.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.localizeUI()
    }
    
    func localizeUI()
    {
        for view:UIView in self.subviews
        {
            if let potentialButton = view as? UIButton
            {
                if let titleString = potentialButton.titleLabel?.text {
                    potentialButton.setTitle(titleString.localized, for: .normal)
                }
            }
                
            else if let potentialLabel = view as? UILabel
            {
                if let titleString =  potentialLabel.text {
                    potentialLabel.text = titleString.localized
                }
            }
            else if let potentialTextField = view as? UITextField
            {
                if let titleString =  potentialTextField.placeholder {
                    potentialTextField.placeholder = titleString.localized
                }
            }
            view.localizeUI()
        }
    }
}
