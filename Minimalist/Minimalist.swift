//  Minimalist.swift
//  Copyright © 2020 Alexey Naumov. All rights reserved.

import Foundation

/**
 Observable value container. Use `$` prefix to access the subscription point
 */
@propertyWrapper
public struct Property<Value> {
    public let projectedValue: SubscriptionPoint<Value>
    public var wrappedValue: Value {
        didSet { projectedValue.broadcast(wrappedValue) }
    }
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        self.projectedValue = .init(notifyUponSubscription: true, initial: wrappedValue)
    }
}

/**
 Observable event broadcaster. Use `$` prefix to access the subscription point
*/
@propertyWrapper
public struct Signal<Value> {
    public var wrappedValue = Accepts<Value>()
    public var projectedValue: SubscriptionPoint<Value> {
        return wrappedValue.projectedValue
    }
    public init() { }
}

/**
 Defines the type that `Signal` accepts for broadcasting
*/
public struct Accepts<Value> {
    fileprivate let projectedValue = SubscriptionPoint<Value>()
    public mutating func send(_ value: Value) {
        projectedValue.broadcast(value)
    }
}

/**
 The place where you attach an observer using one of the `observe` functions
*/
public class SubscriptionPoint<Value> {
    
    private var increment: UInt32 = 0
    private var subscriptions: [UInt32: (Value) -> Void] = [:]
    private var last: Value?
    private let notifyUponSubscription: Bool
    
    fileprivate init(notifyUponSubscription: Bool = false, initial: Value? = nil) {
        self.notifyUponSubscription = notifyUponSubscription
        self.last = initial
    }
    
    /**
     Triggers the callback every time the source produces a value
     - Parameter object: An arbitrary object that limits the subscription' lifetime
     - Parameter closure: The subscription callback
    */
    public func observe<Object>(with object: Object?,
                                closure: @escaping (Object, Value) -> Void
    ) where Object: AnyObject {
        observe(with: object, filter: { $0 }, closure: closure)
    }
    
    /**
     Observes the specified `Equatable` sub-value and triggers the callback when it changes
     - Parameter keyPath: A key path inside `Value` to a contained value type
     - Parameter object: An arbitrary object that limits the subscription' lifetime
     - Parameter closure: The subscription callback
    */
    public func observe<Object, T>(_ keyPath: KeyPath<Value, T>,
                                   with object: Object?,
                                   closure: @escaping (Object, T) -> Void
    ) where Object: AnyObject, T: Equatable {
        var prevValue: T?
        observe(with: object, filter: {
            let value = $0[keyPath: keyPath]
            defer { prevValue = value }
            return value == prevValue ? nil : value
        }, closure: closure)
    }
    
    private func observe<Object, T>(with object: Object?,
                                    filter: @escaping (Value) -> T?,
                                    closure: @escaping (Object, T) -> Void
    ) where Object: AnyObject {
        let index = increment
        increment += 1
        subscriptions[index] = { [weak object, weak self] value in
            if let object = object {
                if let filtered = filter(value) {
                    closure(object, filtered)
                }
            } else {
                self?.subscriptions.removeValue(forKey: index)
            }
        }
        if notifyUponSubscription, let value = last {
            subscriptions[index]?(value)
        }
    }
    
    fileprivate func broadcast(_ value: Value) {
        subscriptions.values.forEach { $0(value) }
        if notifyUponSubscription {
            last = value
        }
    }
}
