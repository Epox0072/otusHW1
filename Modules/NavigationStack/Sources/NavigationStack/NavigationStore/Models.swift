//
//  Models.swift
//  
//
//  Created by Станислав Гапонов on 11.03.2023.
//

import SwiftUI

public final class NavigationStackModel: ObservableObject {
    
    var natigationType: NavigationStack.NavigationType = .Push
    
    @Published public var current: NavigationStack.SomeView?
    
    private var stack: NavigationStack.ViewsStack {
        didSet {
            current = stack.topView
        }
    }
    
    public init(stack: NavigationStack.ViewsStack) {
        self.stack = stack
    }
    
    
    public func push<S: View>(_ screen: S, transition: NavigationStack.NavigationTransition = .Default, with path: String? = nil) {
        let view = AnyView(screen)
        stack.push(screen: view, with: path)
    }
    
    public func pop() {
        stack.pop()
    }
    
}


final class TabBarStackModel: ObservableObject {
    
    var navigationType: NavigationStack.NavigationType = .Push
    
    @Published var currentScreen: NavigationStack.SomeView?
    @Published var selectTabIndex: Int
    
    private var tabStack: NavigationStack.ViewTabStack?
    
    init(selectTabIndex: Int, tabStack: NavigationStack.ViewTabStack? = nil) {
        self.selectTabIndex = selectTabIndex
        self.tabStack = tabStack
        
        setCurrentScreen()
    }
    
    private func setCurrentScreen() {
        currentScreen = tabStack?.getSelectNavigationStack(for: selectTabIndex)?.topView
    }
    
    func getTabsCount() -> Int {
        tabStack?.stack.count ?? -1
    }
    
    func setSelectTab(for tabIndex: Int) {
        selectTabIndex = tabIndex
    }
    
    func pushScreen<S: View>(screen: S, with screenPath: String) {
        let anyScreen = AnyView(screen)
        tabStack?.setSelectScreen(screen: anyScreen, with: screenPath) { selectTab in
            self.setSelectTab(for: selectTab)
        }
        
    }
    
    
}
 
