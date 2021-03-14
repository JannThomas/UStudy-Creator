//
//  TooltipOverlay.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 18.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import SwiftUI
import AppKit

struct TooltipOverlay: NSViewRepresentable {
    typealias NSViewType = NSView
    
    let toolTip: String?
  
    init(_ toolTip: String?) {
        self.toolTip = toolTip
    }
  
    func makeNSView(context: NSViewRepresentableContext<TooltipOverlay>) -> NSView {
        let view = NSView()
        view.toolTip = self.toolTip
        return view
    }
  
    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipOverlay>) {}
}
