//
//  ContentView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 17.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import SchafKit
import CoreLocation
import UStudyCore

class UStudyCreatorHelper: ObservableObject {
    static let shared = UStudyCreatorHelper()
    
    @Published var selectedFolder: URL?
    @Published var unis: [University] = []
    
    init() {}
    
    func selectFolder() {
        let window = (NSApplication.shared.delegate as! AppDelegate).window!
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (result) in
            if result == .OK {
                self.selectedFolder = panel.urls[0]
                
                UStudyHandler.shared.retrieveUniversities(path: self.selectedFolder!.path)
                self.unis = UStudyHandler.shared.unis
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var helper = UStudyCreatorHelper.shared
    
    var data: [[String]] {
        return helper.unis.map({ (uni) -> [String] in
            return [uni.id]
        })
    }
    @State var selectedRow: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text((helper.selectedFolder == nil) ? "No folder selected!" : "Selected Folder: \(helper.selectedFolder!.path)")
                Spacer()
                Button(action: {
                    self.helper.selectFolder()
                }) {
                    Text("Select")
                }
            }
                .padding()
                .background(Color(white: 0.25))
            HStack(spacing: 0) {
                TableView(columns: .constant(["Universities"]),
                          data: .constant(data),
                          selectedRow: $selectedRow,
                          addHandler: {
                            let newUni = University(id: .empty, name: .empty, tags: [], city: .empty, location: CLLocationCoordinate2D(), authors: [], userGroups: [])
                            
                            let window = NSWindow(
                                contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
                                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
                                backing: .buffered, defer: false)
                            window.contentView = NSHostingView(rootView: UniversityEditorView(university: newUni))
                            window.title = "Create New University"
                            (NSApp.delegate as? AppDelegate)?.showModally(window: window)
                            
                          }, removeHandler: {
                            
                          }, changeHandler: nil)
                .frame(width: 250)
                if helper.selectedFolder != nil && selectedRow != nil {
                    TestsView(helper: UStudyTestHelper(folder: helper.selectedFolder!.appendingPathComponent(helper.unis[selectedRow!].id)))
                        .padding([.top, .leading])
                } else {
                    Spacer()
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



struct TestTableView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
