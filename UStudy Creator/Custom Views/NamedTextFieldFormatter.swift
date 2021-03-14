//
//  NamedTextFieldFormatter.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct NamedTextFieldFormatter<T>: View {
    let name: String
    let isRequired: Bool = true
    
    @Binding var value: T
    let formatter: Formatter
    
    var body: some View {
        HStack {
            Text(name)
            TextField(isRequired ? "Required" : "Optional", value: $value, formatter: formatter)
        }
    }
}
