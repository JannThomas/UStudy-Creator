//
//  TableViewRepresentable.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 19.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit
import SchafKit

struct TableViewData {
    let columns: [String]
    let data: [[String]]
}

typealias TableViewChangeHandler = (Int, Int, String) -> Void

struct TableViewRepresentable: NSViewRepresentable {
    
    // - MARK: Types
    typealias NSViewType = NSTableViewContainerView
    
    class Coordinator: NSObject, NSTableViewDataSource, NSTableViewDelegate {
        
        var data: [[String]] = []
        @Binding var selectedRow: Int?
        
        var columns: [String] = []
        
        let changeHandler: TableViewChangeHandler?
        
        var isChanging: Bool = false
        
        init(selectedRow: Binding<Int?>, changeHandler: TableViewChangeHandler?) {
            self._selectedRow = selectedRow
            self.changeHandler = changeHandler
            
            super.init()
        }
        
        func numberOfRows(in tableView: NSTableView) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
            return data[ifExists: row]?[Int(tableColumn!.identifier.rawValue)!]
        }
        
        func tableViewSelectionDidChange(_ notification: Notification) {
            let selected = (notification.object as! NSTableView).selectedRow
            Timer.scheduledTimer(withTimeInterval: 0.01) {
                self.selectedRow = (selected >= 0) ? selected : nil
            }
        }
        
        func controlTextDidEndEditing(_ notification: Notification) {
            let tableView = (notification.object as! NSTableView)
            
            guard
                !isChanging,
                let textMovementInt = notification.userInfo?["NSTextMovement"] as? Int,
                let textMovement = NSTextMovement(rawValue: textMovementInt) else { return }

            var columnIndex = tableView.editedColumn
            var rowIndex = tableView.editedRow
            
            Timer.scheduledTimer(withTimeInterval: 0.05) {
                
                switch textMovement {
                case .tab:
                    columnIndex += 1
                    if columnIndex >= self.columns.count {
                        columnIndex = 0
                        rowIndex += 1
                        if rowIndex >= self.data.count {
                            tableView.nextResponder?.becomeFirstResponder()
                            return
                        }
                    }
                default: return
                }
                
                tableView.selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: false)
                tableView.editColumn(columnIndex, row: rowIndex, with: nil, select: true)
            }
        }
        
        func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
            if let string = object as? String, row < data.count {
                changeHandler?(Int(tableColumn!.identifier.rawValue)!, row, string)
            }
        }
    }
    
    // - MARK: Variables
    
    @Binding var columns: [String]
    @Binding var data: [[String]]
    @Binding var selectedRow: Int?
    
    let changeHandler: TableViewChangeHandler?

    // - MARK: Functions
    
    func makeNSView(context: NSViewRepresentableContext<TableViewRepresentable>) -> NSViewType {
        var array: NSArray?
        _ = NSNib(nibNamed: "NSTableViewContainerView", bundle: nil)?.instantiate(withOwner: nil, topLevelObjects: &array)
        
        let view = array?.filter({ (object) -> Bool in
            return object is NSTableViewContainerView
        })[0] as! NSTableViewContainerView
        
        view.tableView.dataSource = context.coordinator
        view.tableView.delegate = context.coordinator
        
        return view
    }
  
    func updateNSView(_ nsView: NSViewType, context: NSViewRepresentableContext<TableViewRepresentable>) {
        
        let tableView = nsView.tableView!
        
        if context.coordinator.columns != columns {
            
            // Remove all columns
            for column in tableView.tableColumns {
                tableView.removeTableColumn(column)
            }
            
            // Add all columns
            for columnIndex in 0..<columns.count {
                let columnName = columns[columnIndex]
                let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: String(columnIndex)))
                column.title = columnName
                column.headerCell.stringValue = columnName
                tableView.addTableColumn(column)
            }
            
            context.coordinator.columns = columns
        }
        
        if context.coordinator.data != data {
            
            // Select a newly added row automatically
            var automaticallSelectedRow: Int?
            if context.coordinator.data.count == data.count - 1 {
                for i in 0..<data.count where data[i] != context.coordinator.data[ifExists: i] && data[i][0] == .empty {
                    automaticallSelectedRow = i
                    break
                }
            }

            Timer.scheduledTimer(withTimeInterval: 0.01) {
                // Update the data and table view
                context.coordinator.data = self.data
                tableView.reloadData()
                
                // Select row if automatic row is set
                if let row = automaticallSelectedRow {
                    tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
                    tableView.editColumn(0, row: row, with: nil, select: true)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedRow: $selectedRow, changeHandler: changeHandler)
    }
}

class NSTableViewContainerView: NSScrollView {
    @IBOutlet weak var tableView: NSTableView!
    
}
