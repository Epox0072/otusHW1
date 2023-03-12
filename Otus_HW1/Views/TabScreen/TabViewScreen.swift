//
//  TabViewScreen.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import SwiftUI
import NavigationStack

struct TabScreen: View {
    
    
    @State var tabSelection: Int = 1
    @StateObject var navigationModel: NavigationStackModel = .init(stack: NavigationStack.ViewsStack(id: UUID()))
    
    var body: some View {
       
        TabView(selection: $tabSelection) {
            FirstScreen(tabSelection: $tabSelection)
                .tag(0)
                .tabItem {
                    Label("First", systemImage: "figure.walk.motion")
                }
                .environmentObject(navigationModel)
            CustomNavigationView {
                SecondScreen()
                    .environmentObject(navigationModel)
            }
            .tag(1)
            .tabItem {
                Label("Second", systemImage: "contextualmenu.and.cursorarrow")
            }
            ThridScreen()
                .tag(2)
                .tabItem {
                    Label("Thrid", systemImage: "square.and.arrow.up")
                }
        }
        
        /*
         Попытки сделать кастомный таб бар
         
        CustomNavigationTabBar {
            CustomNavigationView {
                FirstScreen(tabSelection: $tabSelection)
            }
            CustomNavigationView {
                SecondScreen()
            }
            CustomNavigationView {
                ThridScreen()
            }
        }
         */
        
    }
    
}

struct TabScreen_Preiew: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}
