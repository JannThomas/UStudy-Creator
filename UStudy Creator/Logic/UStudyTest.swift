//
//  UStudyTest.swift
//  UStudy Creator
//
//  Created by Jann Schafranek on 17.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import SchafKit
import UStudyCore

class UStudyTest: ObservableObject {
    enum Status {
        case unknown, running, success, failure(error: Error)
    }
    
    let name: String
    let handler: (UStudyTestHelper, @escaping (Result<String, Error>) -> Void) -> Void
    let blocksOtherTests: Bool
    @Published var status: Status = .unknown
    
    init(name: String, handler: @escaping (UStudyTestHelper, @escaping (Result<String, Error>) -> Void) -> Void, blocksOtherTests: Bool = false, status: Status = .unknown) {
        self.name = name
        self.handler = handler
        self.blocksOtherTests = blocksOtherTests
        self.status = status
    }
    
    static var all: [UStudyTest] {
        return [
            UStudyTest(name: "Checking main.json", handler: { (helper, completionHandler) in
                let folder = helper.folder
                do {
                    let uni = try JSONDecoder().decode(University.self, from: try Data(contentsOf: folder.appendingPathComponent(Constants.mainPayloadName)))
                    completionHandler(.success("Parsed University: \(uni)"))
                }
                catch (let error) {
                    completionHandler(.failure(error))
                }
            }),
            UStudyTest(name: "Checking main.js", handler: { (helper, completionHandler) in
                helper.error = nil
                
                _ = helper.account!.uniValue
                if let error = helper.error {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.success("main.js was executed successfully."))
                }
            }, blocksOtherTests: true),
            UStudyTest(name: "Getting Mensas", handler: { (helper, completionHandler) in
                helper.account!.getMensas(completionHandler: { (result) in
                    switch result {
                    case .success(let mensas):
                        
                        let string = "Retrieved \(mensas.count) Mensas: " + mensas.map({ (mensa) -> String in
                            return mensa.name
                        }).joined(separator: ", ")
                        helper.mensas = mensas
                        
                        completionHandler(.success(string))
                        
                        if mensas.isEmpty {
                            helper.logPossibleProblem("No mensas were found.")
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                })
            }),
            UStudyTest(name: "Getting Mensa Food", handler: { (helper, completionHandler) in
                // TODO: Test if its the same all the time
                let mensas = helper.mensas ?? []
                
                // Always test giving no option
                var tests: [[Mensa]] = [[]]
                if mensas.count > 0 { // Test a random option when one is available
                    tests.append([mensas[.random(in: 0..<mensas.count)]])
                }
                if mensas.count > 1 { // Test the first and a different random mensa
                    tests.append([mensas[0], mensas[.random(in: 1..<mensas.count)]])
                }
                
                testMensa(tests: tests, helper: helper, completionHandler: completionHandler)
            }),
            UStudyTest(name: "Getting Grades", handler: { (helper, completionHandler) in
                helper.account?.getGrades(completionHandler: { result in
                    switch result {
                    case .success(let grades):
                        completionHandler(.success("'\(grades.count)' grades were found."))
                    case .failure(let error):
                        completionHandler(.failure(GenericError("Didn't get any grades: \(error).")))
                    }
                })
            }),
            /*UStudyTest(name: "Getting Office Hours", handler: { (helper, completionHandler) in
                
            }),*/
            UStudyTest(name: "Account Name Set", handler: { (helper, completionHandler) in
                if let name = helper.account?.name, !name.isEmpty {
                    completionHandler(.success("Name '\(name)' was set."))
                } else {
                    completionHandler(.failure(GenericError("No name was set.")))
                }
            })
        ]
    }
    
    static func testMensa(index: Int = 0, numberOfMealsRetrieved: Int = 0, tests: [[Mensa]], helper: UStudyTestHelper, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let ids = tests[index].map { (mensa) -> String in
            return mensa.id
        }
        helper.log(ids.isEmpty ? "Testing retrieving meals for the next 7 days with no mensa ids." : "Testing retrieving meals for the next 7 days with mensa ids: \(ids).")
        
        getMeals(mensaIds: ids, account: helper.account!, originalCompletionHandler: completionHandler, completionHandler: { (meals) in
            helper.log("Retrieved \(meals.count) meals.")
            
            let mealsPerId = meals.reduce(into: [String: [Meal]](), { (result, meal) in
                result[meal.mensa] = (result[meal.mensa] ?? []) + [meal]
            })
            
            let retrievedMensas = Array(mealsPerId.keys)
            for id in retrievedMensas + ids {
                if !retrievedMensas.contains(id) {
                    helper.logPossibleProblem("No meals retrieved for mensa id \(id).")
                } else if !ids.contains(id) {
                    completionHandler(.failure(GenericError("Meal returned with mensa id '\(id)' while asking for meals from \(ids).")))
                    return
                }
            }
            
            if index + 1 >= tests.count {
                completionHandler(.success("Retrieved \(numberOfMealsRetrieved + meals.count) meals in \(tests.count) tests over the next 7 days."))
            } else {
                self.testMensa(index: index + 1, numberOfMealsRetrieved: numberOfMealsRetrieved + meals.count, tests: tests, helper: helper, completionHandler: completionHandler)
            }
        })
    }
    
    static func getMeals(mensaIds: [String], startDate: Date = Date(), days: Int = 7, account: Account, originalCompletionHandler: @escaping (Result<String, Error>) -> Void, completionHandler: @escaping ([Meal]) -> Void, mealsFetched: [Meal] = []) {
        account.getMensaMeals(mensaIds: mensaIds, date: startDate, completionHandler: { (result) in
            switch result {
            case .success(let meals):
                if days <= 0 {
                    completionHandler(mealsFetched + meals)
                    return
                } else {
                    self.getMeals(mensaIds: mensaIds, startDate: startDate.addingTimeInterval(86400), days: days-1, account: account, originalCompletionHandler: originalCompletionHandler, completionHandler: completionHandler, mealsFetched: mealsFetched + meals)
                }
            case .failure(let error):
                originalCompletionHandler(.failure(error))
            }
        })
    }
}
