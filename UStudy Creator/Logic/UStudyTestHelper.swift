//
//  UStudyTestHelper.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 21.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import AppKit
import UStudyCore

class UStudyTestHelper: ObservableObject {
    let folder: URL
    @Published var tests: [UStudyTest] = UStudyTest.all
    @Published var testLog: [LogEntry] = []
    
    var account: Account?
    var error: Error?
    var curResultHandler: ((Result<String, Error>) -> Void)?
    
    var mensas: [Mensa]?
    
    init(folder: URL) {
        self.folder = folder
        
        RetrieveCredentialsHandler.shared.errorHandler = { error in
            self.logPossibleProblem("Retrieve Credentials Error: \(error)")
        }
        
        let account = Account(name: "", type: "Test")
        account.overrideFolderURL = self.folder
        account.errorHandler = { err in
            self.error = err
            self.testLog.append(LogEntry(text: "JavaScript Error: '\(err)'", color: .orange))
            self.curResultHandler?(.failure(err))
        }
        self.account = account
    }
    
    func startTests(index: Int = 0) {
        if index == 0 {
            for test in tests {
                test.status = .unknown
                testLog = []
            }
        }
        if tests.count <= index {
            return
        }
        
        let test = tests[index]
        
        test.status = .running
        self.testLog.append(LogEntry(text: "Running test '\(test.name)'", color: .white))
        
        let timeoutTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
            self.curResultHandler?(.failure(GenericError("Completion handler was not called after 60 seconds.")))
        })
        
        var wasCalled: Bool = false
        let resultHandler: ((Result<String, Error>) -> Void) = ({ result in
            timeoutTimer.invalidate()
            self.curResultHandler = nil
            if wasCalled == true {
                self.testLog.append(LogEntry(text: "Attention: some handler was called multiple times, this should never happen and can cause undefined behavior in this and the actual apps.", color: .red))
                return
            }
            wasCalled = true
            
            switch result {
            case .success(let string):
                test.status = .success
                self.testLog.append(LogEntry(text: "Successfully passed test '\(test.name)': \(string)", color: .green))
            case .failure(let error):
                test.status = .failure(error: error)
                self.testLog.append(LogEntry(text: "Did not pass test '\(test.name)': \(error)", color: .red))
                
                if test.blocksOtherTests {
                    self.testLog.append(LogEntry(text: "Aborting since the failure of this test blocks other tests.", color: .red))
                    return
                }
            }
            
            self.startTests(index: index+1)
        })
        
        self.curResultHandler = resultHandler
        test.handler(self, resultHandler)
    }
    
    func log(_ string: String) {
        testLog.append(LogEntry(text: string, color: .white))
    }
    
    func logPossibleProblem(_ string: String) {
        testLog.append(LogEntry(text: string, color: .yellow))
    }
}
