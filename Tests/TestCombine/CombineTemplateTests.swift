//
//  CombineTemplateTests.swift
//  MockoloTests
//
//  Created by Peter Tolsma on 9/14/20.
//

@testable import MockoloFramework
import XCTest
import Combine

class CombineTemplateTests: XCTestCase {
    var model: VariableModel!
    var notPublisherModel: VariableModel!
    
    static let defaultEncloser = ""
    static let defaultShouldOverride = false
    
    override func setUp() {
        super.setUp()
        model = VariableModel(name: "", typeName: "AnyPublisher<Int, Error>",
                               acl: nil, encloserType: .protocolType,
                               isStatic: false, canBeInitParam: false, offset: 0,
                               length: 0, overrideTypes: nil,
                               modelDescription: nil, processed: false)
        notPublisherModel = VariableModel(name: "", typeName: "Int",
                                          acl: nil, encloserType: .protocolType,
                                          isStatic: false, canBeInitParam: false,
                                          offset: 0, length: 0, overrideTypes: nil,
                                          modelDescription: nil, processed: false)
    }
    
    override func tearDown() {
        model = nil
        notPublisherModel = nil
        super.tearDown()
    }
    
    static func applyCombineVariableTemplateHelper(model: VariableModel,
                                                   encloser: String,
                                                   shouldOverride: Bool) -> String? {
        
        return model.applyCombineVariableTemplate(name: model.name, type: model.type,
                                                  encloser: encloser, isStatic: model.isStatic,
                                                  shouldOverride: shouldOverride,
                                                  accessLevel: model.accessLevel,
                                                  overrideTypes: model.overrideTypes)
    }

    func testApplyCombineVariableTemplateExists() {
        _ = Self.applyCombineVariableTemplateHelper(model: model, encloser: Self.defaultEncloser,
                                                    shouldOverride: Self.defaultShouldOverride)
    }
    
    func testApplyCombineVariableTemplateReturnsNilIfModelNotAnyPublisher() {
        let result = Self.applyCombineVariableTemplateHelper(model: notPublisherModel,
                                                             encloser: Self.defaultEncloser,
                                                             shouldOverride: Self.defaultShouldOverride)

        XCTAssertNil(result)
    }
    
    func testApplyCombineVariableTemplateReturnsNilIfBracesUnmatched() {
        model.type = Type("AnyPublisher<Double, Error")
        let result = Self.applyCombineVariableTemplateHelper(model: model, encloser: "",
                                                             shouldOverride: false)
        
        XCTAssertNil(result)
    }
    /*
     var publisher: AnyPublisher<Double, Error>

     --->
     private var publisherSubjectKind = 0
     
     public var publisherSubjectSetCallCount = 0
     
     public var publisherPassthroughSubject: PassthroughSubject<Double, Error> {
        didSet { publisherSubjectSetCallCount += 1 }
     }
     public var publisherCurrentValueSubject: CurrentValueSubject<Double, Error> {
        didSet { publisherSubjectSetCallCount += 1 }
     }
     // Does this need to be public?
     public var _publisher: AnyPublisher<Double, Error>
     
     public var publisher: AnyPublisher<Double, Error> {
         get {
             if publisherSubjectKind == 0 {
                 return publisherPassthroughSubject
             } else if publisherSubjectKind == 1{
                 return publisherCurrentValueSubject
             } else {
                 return _publisher
             }
         }
         set {
             if let val = newValue as? PassthroughSubject<Double, Error> {
                 publisherPassthroughSubject = newValue
                 publisherSubjectKind = 0
             } else if let val = newValue as? CurrentValueSubject<Double, Error> {
                 publisherCurrentValueSubject = newValue
                 publisherSubjectKind = 1
             } else {
                 _publisher = newValue
                 publisherSubjectKind = 2
             }
         }
     }
     
        
     
     
     */
}
