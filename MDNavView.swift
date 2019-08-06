//
//  MDNavView.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import UIKit

class MDNavView: UIView {

    @IBOutlet var gvBG: MDGradientView?
    @IBOutlet var statusHeight: NSLayoutConstraint?

    override func draw(_ rect: CGRect) {
        // Drawing code
         super.draw(rect)
        statusHeight?.constant = Screen.IS_IPHONE_Xs_Max() || Screen.IS_IPHONE_X()  ? 45 : 20
        self.gvBG?.topColor = App_Delegate.themColor.top_color
        self.gvBG?.bottomColor = App_Delegate.themColor.main_color
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
    
    }
}
