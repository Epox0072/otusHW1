//
//  CustomNavigationTabBar.swift
//  
//
//  Created by Станислав Гапонов on 12.03.2023.
//

import SwiftUI

public struct CustomNavigationTabBar<Content>: View where Content: View {
    
    @StateObject var tabBarModel: TabBarStackModel = .init(selectTabIndex: 1)
    
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        CustomTabBar(content: content)
            .environmentObject(tabBarModel)
    }
}

private struct CustomTabBar<Content>: View where Content: View {
    
    @EnvironmentObject var tabBarModel: TabBarStackModel
    
    private let content: Content
    
    @Environment(\.colorScheme) var colorScheme
    
    public var hexColorForDark: String = "#333333"
    public var hexColorForLight: String = "#E8E8E8"
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
//        HStack {
//
//            content
//            Color(hex: colorScheme == .dark ? hexColorForDark : hexColorForLight)
//                .ignoresSafeArea(edges: .bottom)
//                .frame(height: 50)
//                .overlay(
//                    tabsView
//                )
//        }
        GeometryReader { geometry in
            return ZStack {
                self.pagesInHStack(screenGeometry: geometry)
                Color(hex: colorScheme == .dark ? hexColorForDark : hexColorForLight)
                    .ignoresSafeArea(edges: .bottom)
                    .frame(height: 50)
                    .overlay(
                        tabsView
                    )
            }
        }
            
    }
    
    private var tabsView: some View {
        HStack {
            let tabCount = tabBarModel.getTabsCount()
            ForEach(Tabs.allCases, id: \.id) { tab in
                Spacer()
                prepareTab(tab: tab)
                Spacer()
            }
        }
    }
    
    private func prepareTab(tab: Tabs) -> some View {
        Label(tab.rawValue, systemImage: tab.imageName)
            .frame(width: 30, height: 30)
            .onTapGesture {
                tabBarModel.setSelectTab(for: tab.id)
            }
    }
    
    func getTabBarHeight(screenGeometry: GeometryProxy) -> CGFloat {
        // https://medium.com/@hacknicity/ipad-navigation-bar-and-toolbar-height-changes-in-ios-12-91c5766809f4
        // ipad 50
        // iphone && portrait 49
        // iphone && portrait && bottom safety 83
        // iphone && landscape 32
        // iphone && landscape && bottom safety 53
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return 50 + screenGeometry.safeAreaInsets.bottom
//        } else if UIDevice.current.userInterfaceIdiom == .phone {
//            if !model.landscape {
//                return 49 + screenGeometry.safeAreaInsets.bottom
//            } else {
//                return 32 + screenGeometry.safeAreaInsets.bottom
//            }
//        }
        return 50
    }
    
    func pagesInHStack(screenGeometry: GeometryProxy) -> some View {
        
        let tabBarHeight = getTabBarHeight(screenGeometry: screenGeometry)
        let heightCut = tabBarHeight - screenGeometry.safeAreaInsets.bottom
        let spacing: CGFloat = 100 // so pages don't overlap (in case of leading and trailing safetyInset), arbitrary
        
        return HStack(spacing: spacing) {
            self.content
            // reduced height, so items don't appear under tha tab bar
                .frame(width: screenGeometry.size.width, height: screenGeometry.size.height - heightCut)
            // move up to cover the reduced height
            // 0.1 for iPhone X's nav bar color to extend to status bar
                .offset(y: -heightCut/2 - 0.1)
        }
        .frame(width: screenGeometry.size.width, height: screenGeometry.size.height, alignment: .leading)
        .offset(x: -CGFloat(tabBarModel.selectTabIndex) * screenGeometry.size.width + -CGFloat(tabBarModel.selectTabIndex) * spacing)
    }
}

/// Tab enum

enum Tabs: String, CaseIterable, Identifiable {
    case First = "First"
    case Second = "Second"
    case Thrid = "Thrid"
    
    var imageName: String {
        switch self {
        case .First:
            return "figure.walk.motion"
        case .Second:
            return "contextualmenu.and.cursorarrow"
        case .Thrid:
            return "square.and.arrow.up"
        }
    }
    
    var id: Int {
        switch self {
        case .First:
            return 0
        case .Second:
            return 1
        case .Thrid:
            return 2
        }
    }
}
