//
//  MDRoundView.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import UIKit

class MDRoundView: UIControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
    }

}
