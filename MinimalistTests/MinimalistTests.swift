//
//  MinimalistTests.swift
//  MinimalistTests
//
//  Created by Alexey Naumov on 30.05.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import XCTest
@testable import Minimalist

class TestContainer {
    @Property var property: Int = 5
    @Property var propertyC: ValueContainer = .init(value1: 3, value2: 9)
    @Signal var signal: Accepts<Int>
    @Signal var signalC: Accepts<ValueContainer>
}

class TestObserver { }

struct ValueContainer {
    var value1: Int
    var value2: Int
}

// MARK: - Property

class PropertyTests: XCTestCase {
    
    var container: TestContainer!
    
    override func setUp() {
        container = TestContainer()
    }

    func testDirectValueAccess() {
        XCTAssertNoThrow(container.property)
        container.property = 17
        XCTAssertEqual(container.property, 17)
    }
    
    func testNotification() {
        var receivedValues: [Int] = []
        container.$property.observe(with: self, closure: { (obj, value) in
            receivedValues.append(value)
        })
        let sample = [17, 42, -7, 0, 194]
        sample.forEach { container.property = $0 }
        XCTAssertEqual(container.property, sample.last)
        XCTAssertEqual(receivedValues, [5] + sample)
    }
    
    func testObservationLifetime() {
        var observer1: TestObserver? = TestObserver()
        var observer2: TestObserver? = TestObserver()
        var receivedValues1: [Int] = []
        var receivedValues2: [Int] = []
        container.$property.observe(with: observer1, closure: { (obj, value) in
            receivedValues1.append(value)
        })
        container.$property.observe(with: observer2, closure: { (obj, value) in
            receivedValues2.append(value)
        })
        container.property = 99
        container.property = -18
        observer1 = TestObserver()
        container.property = 7
        container.property = 15
        observer2 = TestObserver()
        container.property = 12
        XCTAssertEqual(receivedValues1, [5, 99, -18])
        XCTAssertEqual(receivedValues2, [5, 99, -18, 7, 15])
    }
    
    func testValueFiltering() {
        var values1: [Int] = []
        var values2: [Int] = []
        container.$propertyC.observe(\.value1, with: self, closure: { (obj, value) in
            values1.append(value)
        })
        container.$propertyC.observe(\.value2, with: self, closure: { (obj, value) in
            values2.append(value)
        })
        let sample: [ValueContainer] = [
            .init(value1: 1, value2: 12),
            .init(value1: 1, value2: -8),
            .init(value1: 7, value2: -8),
            .init(value1: 7, value2: -8),
            .init(value1: 3, value2: 17)
        ]
        sample.forEach { container.propertyC = $0 }
        XCTAssertEqual(values1, [3, 1, 7, 3])
        XCTAssertEqual(values2, [9, 12, -8, 17])
    }
}

// MARK: - Signal

class SignalTests: XCTestCase {
    
    var container: TestContainer!
    
    override func setUp() {
        container = TestContainer()
    }

    func testNoObserversOperation() {
        XCTAssertNoThrow(container.signal)
        XCTAssertNoThrow(container.signal.send(5))
    }
    
    func testNotification() {
        var receivedValues: [Int] = []
        container.$signal.observe(with: self, closure: { (obj, value) in
            receivedValues.append(value)
        })
        let sample = [17, 42, -7, 0, 194]
        sample.forEach { container.signal.send($0) }
        XCTAssertEqual(receivedValues, sample)
    }
    
    func testObservationLifetime() {
        var observer1: TestObserver? = TestObserver()
        var observer2: TestObserver? = TestObserver()
        var receivedValues1: [Int] = []
        var receivedValues2: [Int] = []
        container.$signal.observe(with: observer1, closure: { (obj, value) in
            receivedValues1.append(value)
        })
        container.$signal.observe(with: observer2, closure: { (obj, value) in
            receivedValues2.append(value)
        })
        container.signal.send(99)
        container.signal.send(-18)
        observer1 = TestObserver()
        container.signal.send(7)
        container.signal.send(15)
        observer2 = TestObserver()
        container.signal.send(12)
        XCTAssertEqual(receivedValues1, [99, -18])
        XCTAssertEqual(receivedValues2, [99, -18, 7, 15])
    }
    
    func testValueFiltering() {
        var values1: [Int] = []
        var values2: [Int] = []
        container.$signalC.observe(\.value1, with: self, closure: { (obj, value) in
            values1.append(value)
        })
        container.$signalC.observe(\.value2, with: self, closure: { (obj, value) in
            values2.append(value)
        })
        let sample: [ValueContainer] = [
            .init(value1: 1, value2: 12),
            .init(value1: 1, value2: -8),
            .init(value1: 7, value2: -8),
            .init(value1: 7, value2: -8),
            .init(value1: 3, value2: 17)
        ]
        sample.forEach { container.signalC.send($0) }
        XCTAssertEqual(values1, [1, 7, 3])
        XCTAssertEqual(values2, [12, -8, 17])
    }
}
