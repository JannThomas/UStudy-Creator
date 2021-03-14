//
//  AuthorsTableView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import UStudyCore

struct AuthorsTableView: View {
    @Binding var university: University
    
    @Binding var selectedRow: Int?
    
    var data: [[String]] {
        return university.authors!.map({ (author) -> [String] in
            return [author.name, author.imageUrl ?? ""]
        })
    }
    
    var body: some View {
        TableView(columns: .constant(["Name", "Image URL"]), data: .constant(data), selectedRow: $selectedRow, addHandler: {
            self.university.authors!.insert(Author(name: .empty, imageUrl: .empty, contactOptions: []), at: (self.selectedRow ?? (self.university.authors!.count - 1)) + 1)
        }, removeHandler: {
            if let selectedRow = self.selectedRow {
                self.selectedRow = nil
                self.university.authors!.remove(at: selectedRow)
            }
        }, changeHandler: { column, row, newValue in
            if column == 0 {
                self.university.authors![row].name = newValue
            } else {
                self.university.authors![row].imageUrl = newValue
            }
        })
    }
}
