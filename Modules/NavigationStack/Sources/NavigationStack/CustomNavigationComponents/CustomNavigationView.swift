//
//  CustomNavigationView.swift
//  
//
//  Created by Станислав Гапонов on 11.03.2023.
//

import SwiftUI


public struct CustomNavigationView<Content>: View where Content: View {
    
    @StateObject var stackModel: NavigationStackModel = .init(stack: NavigationStack.ViewsStack(id: UUID()))
    
    private let content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            if stackModel.current == nil {
                content
                    .environmentObject(stackModel)
            } else {
                stackModel.current!.screen
                    .environmentObject(stackModel)
            }
            
        }
    }
    
}

public struct NavigationWrapper<Content, Destination>: View where Content: View, Destination: View {
    
    @EnvironmentObject var navigationModel: NavigationStackModel
    
    private var navigationType: NavigationStack.NavigationType
    
    private let content: Content
    private let desctination: Destination?
    
    public init(push desctination: Destination, @ViewBuilder content: @escaping () -> Content) {
        self.navigationType = .Push
        self.desctination = desctination
        self.content = content()
    }
    
    public var body: some View {
        content.onTapGesture {
            didSelect()
        }
    }
    
    private func didSelect() {
        switch navigationType {
        case .Push:
            push()
            break
        case .Pop:
            pop()
            break
        }
    }
    
    private func push() {
        guard let desctination else { return }
        navigationModel.push(desctination)
    }
    
    private func pop() {
        navigationModel.pop()
    }
}

 
