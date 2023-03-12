//
//  FirstScreen.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import SwiftUI
import NavigationStack

struct FirstScreen: View {
    
    @Binding var tabSelection: Int
    @EnvironmentObject var navigationStack: NavigationStackModel
    
    var body: some View {
        /*
        CustomNavigationView {        
            NavigationWrapper(push: FoodDetailScreen(name: "🍌")) {
                Button("Open food") {
                    openRandomFood()
                }.buttonStyle(.borderless)
//                Text("Open food")
//                    .font(.largeTitle)
//                    .onTapGesture {
//                        tabSelection = 1
//                    }
            }
        }
        */
        Button("Open food") {
            openRandomFood()
        }.buttonStyle(.borderless)
    }
    
    private func openRandomFood() {
        tabSelection = 1
        navigationStack.push(FoodDetailScreen(name: "🍌"))
        
    }
}

struct FirstScreen_Preview: View {
    
    @State private var tB: Int = 0
    @State private var oF: Bool = false
    
    var body: some View {
        FirstScreen(tabSelection: $tB)
    }
    
}

struct FirstScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        FirstScreen_Preview()
    }
}
