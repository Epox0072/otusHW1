//
//  File.swift
//  
//
//  Created by Станислав Гапонов on 11.03.2023.
//

import Foundation
import SwiftUI

extension NavigationStack {
    
    
    public struct SomeView: Identifiable, Equatable {//: NavigationStack_Store_View_Protocol {
        
        private (set) public var id: UUID
        private (set) var path: String?
        private (set) public var screen: AnyView
        
        init(id: UUID, screen: AnyView) {
            self.id = id
            self.screen = screen
        }
        
        init(path: String?, screen: AnyView) {
            self.id = UUID()
            self.path = path
            self.screen = screen
        }
        
        private var parentViewStackPath: String?
        private var parentViewsTapStackPath: String?
        
        public static func == (lhs: SomeView, rhs: SomeView) -> Bool {
            if lhs.path != rhs.path {
                return lhs.id == rhs.id
            }
            return true
        }
        
        mutating func preparePath(stackPath: String) {
            if let path {
                self.path = stackPath + path
            }
            
        }
        
    }
    
    public struct ViewsStack: Identifiable, Equatable {
        
        private (set) public var id: UUID
        private (set) var path: String = ""
        private (set) var stack: [SomeView] = []
        
        var topView: SomeView? {
            return stack.last
        }
        
        var firstView: SomeView? {
            return stack.first
        }
        
        public init(id: UUID) {
            self.id = id
        }
        
        init(path: String) {
            self.id = UUID()
            self.path = path
        }
        
        public static func == (lhs: ViewsStack, rhs: ViewsStack) -> Bool {
            return lhs.id == rhs.id
        }
        
        
        mutating func push(screen: AnyView, with viewPath: String? = nil) {
            var someView: SomeView
            if let viewPath {
                someView = SomeView(path: viewPath, screen: screen)
                someView.preparePath(stackPath: path)
            } else {
                someView = SomeView(id: UUID(), screen: screen)
            }
            stack.append(someView)
        }
        
        mutating func pop() {
            _ = stack.popLast()
        }
        
        mutating func popToRoot() {
            stack.removeAll()
        }
        
        mutating func pop(to path: String) {
            if stack.isEmpty { return }
            let removeIndexes = findIndexForRemove(for: path)
            if removeIndexes.isEmpty { return }
            let newStack = stack
                .enumerated()
                .filter({ !removeIndexes.contains($0.offset) })
                .map({ $0.element })
            self.stack = newStack
        }
        
        private func findIndexForRemove(for viewPath: String) -> [Int] {
            var index = stack.count-1
            var findView = false
            var removeIndexes: [Int] = []
            while index >= 0 || findView == false {
                let someView = stack[index]
                if let fullViewPath = someView.path {
                    let viewPath = fullViewPath.replacingOccurrences(of: "\(path)/", with: "")
                    if viewPath == path {
                        findView = true
                    } else {
                        removeIndexes.append(index)
                        index -= 1
                    }
                } else {
                    index -= 1
                }
                
            }
            return removeIndexes
        }
    }
    
    struct ViewTabStack: Identifiable, Equatable {
        
        private let tabPattern: String = "tab_"
        
        private (set) var id: UUID
        private (set) var stack: [ViewsStack] = []
        
        init(id: UUID, tabCount: Int) {
            self.id = id
            prepareStack(for: tabCount)
        }
        
        private mutating func prepareStack(for count: Int) {
            for i in 0..<count {
                let viewStack = ViewsStack(path: "\(tabPattern)\(i)")
                stack.append(viewStack)
            }
        }
        
        static func == (lhs: ViewTabStack, rhs: ViewTabStack) -> Bool {
            let leftStack = lhs.stack
            let rightStack = rhs.stack
            let isEqualStacks: Bool = isEqualStacks(leftStack, rightStack)
            
            if !isEqualStacks {
                return lhs.id == rhs.id
            }
            
            return isEqualStacks
        }
        
        private static func isEqualStacks(_ lhs: [ViewsStack], _ rhs: [ViewsStack]) -> Bool {
            if lhs.count != rhs.count {
                return false
            }
            var i = 0
            while i < lhs.count {
                let letView = lhs[i]
                let rightView = rhs[i]
                if letView == rightView {
                    i += 1
                } else {
                    i += lhs.count
                }
            }
                
            return i == (lhs.count - 1)
        }
        
        func getSelectNavigationStack(for tapIndex: Int) -> ViewsStack? {
            if tapIndex < stack.count {
                return stack[tapIndex]
            }
            return nil
        }
        
        mutating func setSelectScreen(screen: AnyView, with path: String, setSelectTabCompletion: (Int) -> Void) {
            if path.isEmpty { return }
            var selectTabIndex: Int?
            for i in 0..<stack.count {
                let viewsStack = stack[i]
                let navigationStackPath = viewsStack.path
                if path.hasPrefix(navigationStackPath) {
                    selectTabIndex = i
                    break
                }
            }
            guard let selectTabIndex else { return }
            setSelectTabCompletion(selectTabIndex)
            stack[selectTabIndex].push(screen: screen, with: path)
        }
    }
    
}
