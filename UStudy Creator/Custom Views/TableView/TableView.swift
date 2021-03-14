//
//  TableView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 20.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct TableView: View {
    
    // - MARK: Variables
    
    @Binding var columns: [String]
    @Binding var data: [[String]]
    @Binding var selectedRow: Int?
    
    let addHandler: () -> Void
    let removeHandler: () -> Void
    let changeHandler: TableViewChangeHandler?
    
    // - MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            TableViewRepresentable(columns: $columns, data: $data, selectedRow: $selectedRow, changeHandler: changeHandler)
                .border(Color(white: 0.49), width: 1)
            StepperViewRepresentable(addHandler: addHandler, removeHandler: removeHandler)
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(columns: .constant(["Test", "Toast"]), data: .constant([["1", "Hi"], ["2", "Ho"]]), selectedRow: .constant(0), addHandler: {}, removeHandler: {}, changeHandler: {_, _, _ in})
    }
}
