//
//  FoodDetailScreen.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import SwiftUI
import NavigationStack

struct FoodDetailScreen: View {
    
    let name: String
    
    var body: some View {
        VStack {
            CustomNavigationBar(text: "Food")
            Text(name)
                .font(.system(size: 256))
            Spacer()
        }
    }
    
    @ViewBuilder
    func createNavBar() -> some View {
        Color.gray
            .ignoresSafeArea()
            .overlay(
                createnaNavBarTitleView()
            )
        .frame(height: 50)
    }
    
    @ViewBuilder
    func createnaNavBarTitleView() -> some View {
        Text("Food detail")
            .foregroundColor(.white)
    }
}

struct FoodDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailScreen(name: "🍏")
    }
}
