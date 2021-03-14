//
//  TestView.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI

struct TestStatusIndicator: View {
    let status: UStudyTest.Status
    
    var body: some View {
        switch status {
        case .unknown:
            return AnyView(
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(Color(white: 0.2))
            )
        case .success:
            return AnyView(
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            )
        case .failure(let error):
            return AnyView(
                Image(systemName: "xmark.octagon.fill")
                    .foregroundColor(.red)
                    .overlay(TooltipOverlay("\(error)"))
            )
        case .running:
            return AnyView(
                ActivityIndicator()
            )
        }
    }
}

struct TestView: View {
    @ObservedObject var test: UStudyTest
    
    var body: some View {
        HStack {
            TestStatusIndicator(status: test.status)
                .font(.system(size: 18))
                .frame(width: 22, height: 22)
            Text(test.name)
        }
    }
}
