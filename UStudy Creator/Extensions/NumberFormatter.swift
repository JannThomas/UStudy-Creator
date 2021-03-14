//
//  NumberFormatter.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 19.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        
        self.numberStyle = numberStyle
    }
}
