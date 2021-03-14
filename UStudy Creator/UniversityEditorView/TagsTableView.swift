//
//  TagsTableView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import UStudyCore

struct TagsTableView: View {
    @Binding var university: University
    
    @State var selectedRow: Int? = nil
    
    var data: [[String]] {
        return university.tags.map({ (string) -> [String] in
            return [string]
        })
    }
    
    var body: some View {
        TableView(columns: .constant(["Tag"]), data: .constant(data), selectedRow: $selectedRow, addHandler: {
            self.university.tags.insert("", at: (self.selectedRow ?? (self.university.tags.count - 1)) + 1)
        }, removeHandler: {
            if let selectedRow = self.selectedRow {
                self.university.tags.remove(at: selectedRow)
            }
        }, changeHandler: { column, row, newValue in
            self.university.tags[row] = newValue
        })
    }
}
