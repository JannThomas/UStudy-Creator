//
//  NamedTextField.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct NamedTextField: View {
    let name: String
    let isRequired: Bool = true
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(name)
            TextField(isRequired ? "Required" : "Optional", text: $text)
        }
    }
}
