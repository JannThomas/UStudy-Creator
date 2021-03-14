//
//  ContactOptionsTableView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import UStudyCore

struct ContactOptionsTableView: View {
    @Binding var author: Author
    
    @State var selectedRow: Int? = nil
    
    var data: [[String]] {
        return self.author.contactOptions.map({ (option) -> [String] in
            return [option.serviceName, option.serviceImageUrl, option.url]
        })
    }
    
    var body: some View {
        TableView(columns: .constant(["Service Name", "Image URL", "URL"]), data: .constant(data), selectedRow: $selectedRow, addHandler: {
            self.author.contactOptions.insert(Author.ContactOption(serviceName: .empty, serviceImageUrl: .empty, url: .empty), at: (self.selectedRow ?? (self.author.contactOptions.count - 1)) + 1)
        }, removeHandler: {
            if let selectedRow = self.selectedRow {
                self.author.contactOptions.remove(at: selectedRow)
            }
        }, changeHandler: { column, row, newValue in
            if column == 0 {
                self.author.contactOptions[row].serviceName = newValue
            } else if column == 1 {
                self.author.contactOptions[row].serviceImageUrl = newValue
            } else {
                self.author.contactOptions[row].url = newValue
            }
        })
    }
}
