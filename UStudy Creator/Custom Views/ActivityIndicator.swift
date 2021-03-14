//
//  ActivityIndicator.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 17.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI

struct ActivityIndicator: NSViewRepresentable {

    typealias TheNSView = NSProgressIndicator
    var configuration = { (view: TheNSView) in }

    func makeNSView(context: NSViewRepresentableContext<ActivityIndicator>) -> NSProgressIndicator {
        let view = TheNSView()
        view.style = .spinning
        view.controlSize = .small
        view.startAnimation(nil)
        return view
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ActivityIndicator>) {
        configuration(nsView)
    }
}
