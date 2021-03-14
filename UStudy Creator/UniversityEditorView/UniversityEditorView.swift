//
//  UniversityEditorView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 19.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import CoreLocation
import SchafKit
import UStudyCore

private let countrys = Locale.isoRegionCodes.map { (identifier) in
    return (code: identifier, name: Locale.current.localizedString(forRegionCode: identifier)!)
}

struct UniversityEditorView: View {
    @State var university: University
    @State var country: String = "" { didSet { print(country) } }
    @State var id: String = "" { didSet { print(country) } }
    
    @State var selectedAuthorIndex: Int? = nil
    
    var countryPicker: some View {
        Picker(selection: $country, label: Text("Country")) {
            ForEach([("", "Please select")] + countrys, id: \.code) { country in
                Text(country.name)
                    .tag(country.code)
            }
        }
    }
    
    @State var test: Int? = nil
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                VStack(spacing: 8) {
                    countryPicker
                    NamedTextField(name: "City", text: $university.city)
                    AlignedText("Tags")
                    TagsTableView(university: $university)
                    AlignedText("Authors")
                    AuthorsTableView(university: $university, selectedRow: $selectedAuthorIndex)
                }
                VStack(spacing: 8) {
                    NamedTextField(name: "Name", text: $id)
                    HStack {
                        NamedTextFieldFormatter(name: "Longitude", value: $university.location.longitude, formatter: NumberFormatter(numberStyle: .decimal))
                        NamedTextFieldFormatter(name: "Latitude", value: $university.location.latitude, formatter: NumberFormatter(numberStyle: .decimal))
                    }
                    AlignedText("User Groups")
                    UserGroupsTableView(university: $university)
                    if selectedAuthorIndex != nil {
                        AlignedText("Contact Options for \(university.authors![selectedAuthorIndex!].name)")
                        ContactOptionsTableView(author: Binding<Author>(get: {
                            return self.university.authors![self.selectedAuthorIndex!]
                        }, set: { (newValue) in
                            self.university.authors![self.selectedAuthorIndex!] = newValue
                        }))
                    } else {
                        AlignedText("User Groups")
                            .opacity(0)
                        TableView(columns: .constant([]), data: .constant([]), selectedRow: .constant(nil), addHandler: {}, removeHandler: {}, changeHandler: {_,_,_ in })
                            .opacity(0)
                    }
                }
            }
        }
        .padding()
    }
}

struct UniversityEditorView_Previews: PreviewProvider {
    static var previews: some View {
        UniversityEditorView(university: University(id: .empty, name: .empty, tags: [], city: .empty, location: CLLocationCoordinate2D(), authors: nil, userGroups: nil))
    }
}
