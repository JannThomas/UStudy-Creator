//
//  AlignedText.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 20.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct AlignedText: View {
    let string: String
    let alignment: TextAlignment
    
    internal init(_ string: String, alignment: TextAlignment = .leading) {
        self.string = string
        self.alignment = alignment
    }
    
    var body: some View {
        HStack {
            if alignment == .trailing {
                Spacer()
            }
            Text(string)
            if alignment == .leading {
                Spacer()
            }
        }
    }
}

struct AlignedText_Previews: PreviewProvider {
    static var previews: some View {
        AlignedText("Test")
    }
}
