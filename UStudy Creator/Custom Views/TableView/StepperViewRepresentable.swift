//
//  StepperViewRepresentable.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 19.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

struct StepperViewRepresentable: NSViewRepresentable {
    
    // - MARK: Types
    typealias NSViewType = NSSegmentedControl
    
    class Coordinator: NSObject {
        
        let addHandler: () -> Void
        let removeHandler: () -> Void
        
        init(addHandler: @escaping () -> Void, removeHandler: @escaping () -> Void) {
            self.addHandler = addHandler
            self.removeHandler = removeHandler
        }
        
        @objc func segmentSwitched(for segmentedControl: NSSegmentedControl) {
            switch segmentedControl.selectedSegment {
            case 0:
                addHandler()
            case 1:
                removeHandler()
            default:
                break
            }
        }
    }
    
    // - MARK: Variables
    
    let addHandler: () -> Void
    let removeHandler: () -> Void

    // - MARK: Functions
    
    func makeNSView(context: NSViewRepresentableContext<StepperViewRepresentable>) -> NSSegmentedControl {
        let view = NSSegmentedControl(images: [], trackingMode: .momentary, target: context.coordinator, action: #selector(Coordinator.segmentSwitched))
        
        view.segmentCount = 3
        view.setImage(NSImage(named: NSImage.addTemplateName), forSegment: 0)
        view.setImage(NSImage(named: NSImage.removeTemplateName), forSegment: 1)
        view.setWidth(32, forSegment: 0)
        view.setWidth(32, forSegment: 1)
        view.setEnabled(false, forSegment: 2)
        view.segmentStyle = .smallSquare
        
        return view
    }
  
    func updateNSView(_ nsView: NSSegmentedControl, context: NSViewRepresentableContext<StepperViewRepresentable>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(addHandler: addHandler, removeHandler: removeHandler)
    }
}
