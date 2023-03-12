//
//  CustomNavigationBar.swift
//  
//
//  Created by Станислав Гапонов on 12.03.2023.
//

import SwiftUI

public struct CustomNavigationBar<LeftContent: View, RightContent: View>: View
{
    
    public typealias LeftContentBuilder = () -> LeftContent
    public typealias RightContentBuilder = () -> RightContent
    
    var title: String
    var leftContent: LeftContent
    var rightContent: RightContent
    
    public init(title: String,
         @ViewBuilder leftContent: @escaping LeftContentBuilder,
         @ViewBuilder rightContent: @escaping RightContentBuilder) {
        self.title = title
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }

    public init(text: String) where LeftContent == EmptyView, RightContent == EmptyView {
        self.init(title: text) {
            EmptyView()
        } rightContent: {
            EmptyView()
        }

    }
    
    @EnvironmentObject var navigationModel: NavigationStackModel
    
    private let navigationType: NavigationStack.NavigationType = .Pop
    
    @Environment(\.colorScheme) var colorScheme
    
    public var hexColorForDark: String = "#333333"
    public var hexColorForLight: String = "#E8E8E8"
    
    public var body: some View {
        Color(hex: colorScheme == .dark ? hexColorForDark : hexColorForLight)
            .ignoresSafeArea()
            .overlay(
                HStack {
                    leftView
                    Spacer()
                    rightContent
                        .padding()
                }
            )
            .frame(height: 50)
            .overlay(
                Text(title)
                    .font(.title)
                    .frame(alignment: .center)
            )
    }
    
    private var leftView: some View {
        Group {
            if ((leftContent as? EmptyView) != nil) {
                if navigationModel.current != nil {
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            navigationModel.pop()
                        }
                        .padding()
                }
            } else {
                leftContent
            }
        }
    }
    
}

/// Extensions

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}
