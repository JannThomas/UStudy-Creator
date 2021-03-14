//
//  UserGroupsTableView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import UStudyCore

struct UserGroupsTableView: View {
    @Binding var university: University
    
    @State var selectedRow: Int? = nil
    
    var data: [[String]] {
        return university.userGroups!.map({ (group) -> [String] in
            return [group.id, group.name]
        })
    }
    
    var body: some View {
        TableView(columns: .constant(["ID", "Name"]), data: .constant(data), selectedRow: $selectedRow, addHandler: {
            self.university.userGroups!.insert(UserGroup(id: .empty, name: .empty), at: (self.selectedRow ?? (self.university.userGroups!.count - 1)) + 1)
        }, removeHandler: {
            if let selectedRow = self.selectedRow {
                self.university.userGroups!.remove(at: selectedRow)
            }
        }, changeHandler: { column, row, newValue in
            if column == 0 {
                self.university.userGroups![row].id = newValue
            } else {
                self.university.userGroups![row].name = newValue
            }
        })
    }
}
