//
//  TestsView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct TestsView: View {
    @ObservedObject var helper: UStudyTestHelper
    @State var selectedTest: UStudyTest?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.helper.startTests()
                }) {
                    Text("Run All Tests")
                }
                Spacer()
            }
            HStack {
                List(helper.tests, id: \.name) { test in
                    TestView(test: test)
                    .background(self.selectedTest === test ? Color.accentColor : nil)
                    .onTapGesture {
                        self.selectedTest = test
                    }
                }
                .frame(width: 200)
                
                List(helper.testLog, id: \.id) { entry in
                    VStack {
                        Text(entry.text)
                            .foregroundColor(entry.color)
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
            }
        }
    }
}
