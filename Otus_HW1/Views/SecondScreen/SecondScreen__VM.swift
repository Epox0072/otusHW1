//
//  SecondScreen__VM.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import Foundation

final class SecondScreen__VM: ObservableObject {
    
    @Published var isFiltered: Bool = false
    
    @Published var foods: FoodList = .init()
    
    public func refreshFood() {
        foods.foods = foods.foods.filter({ !$0.name.isEmpty })
    }
}

struct FoodList {
    
    var foods: [Food] = [
        Food(name: "🍏", isFaforites: false),
        Food(name: "🍇", isFaforites: false),
        Food(name: "🍟", isFaforites: false),
        Food(name: "🍔", isFaforites: true),
        Food(name: "🥑", isFaforites: false),
        Food(name: "🫓", isFaforites: false),
        Food(name: "🍖", isFaforites: true),
        Food(name: "🍓", isFaforites: false),
        Food(name: "🌶️", isFaforites: true),
        Food(name: "🍌", isFaforites: false)
    ]
    
}


struct Food: Identifiable, Hashable {
    
    let id: UUID = UUID()
    var name: String
    var isFaforites: Bool
    
}
