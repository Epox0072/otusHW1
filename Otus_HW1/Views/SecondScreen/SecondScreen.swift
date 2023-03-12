//
//  SecondScreen.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import SwiftUI
import NavigationStack


struct SecondScreen: View {
    
    @StateObject var foodListVM: SecondScreen__VM = .init()
    @EnvironmentObject var navigationStack: NavigationStackModel
        
    var body: some View {
        /// Попытка сделать кастомный navigation view
        /// Сам navigation view получился, работает, можно посмотреть в модуле
        /// А вот встроить его по нормальному в TabView не получилось
        /// Пришлось идти через прокидывание модели с экрана TabViewScreen
        /// Хотел сделать кастомный таб вью, который сам будет контролировать переходы, но не хватило времени(и навыков пока что🙂)
//        CustomNavigationView {
            HStack(spacing: 0) {
                if navigationStack.current == nil {
                    VStack(spacing: 0) {
                        CustomNavigationBar(text: "FoodList")
                            .environmentObject(navigationStack)
                        foodList
                    }
                } else {
                    navigationStack.current!.screen
                }
            }
//        }
    }
    
    var foodList: some View {
        List() {
            Section {
                foodCells
            } header: {
                FoodFilter(isOn: $foodListVM.isFiltered)
            }
        }
        .animation(.easeIn, value: foodListVM.isFiltered)
    }
    
    private func refreshable() {
        foodListVM.isFiltered = false
        foodListVM.refreshFood()
    }
    
    var foodCells: some View {
        ForEach($foodListVM.foods.foods) { food in
            if !foodListVM.isFiltered || food.isFaforites.wrappedValue {
                FoodCell(name: food.name)
                    .environmentObject(navigationStack)
            }
        }.onDelete { index in
            foodListVM.foods.foods.remove(atOffsets: index)
        }
    }
    
}

struct FoodCell: View {
    
    @Binding var name: String
    @EnvironmentObject var navigationStack: NavigationStackModel
    
    var body: some View {
        /// Сделал кастомный navigationBar
        /// Работает, только надо увеличить зону нажатия
        /// Думаю для начала и так сойдет🙂
        NavigationWrapper(push: FoodDetailScreen(name: name)) {
            HStack {
                Text(name)
                    .font(.largeTitle)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
        }
        .environmentObject(navigationStack)
    }
    
    /*
    var body: some View {
        
//        NavigationLink(
//            destination: {
//                FoodDetailScreen(name: name)
//
//            }
//        )
//        {
            Text(name)
                .font(.largeTitle)
            /*
             Не много поигрался с TextField. Странно отрабатывает.
             Подозреваю, что проблема в биндинге. Видимо после каждого изменения значения
             name, происходит перересовка листа
             
             
            TextField("Food name", text: $name)
                .font(.largeTitle)
                .onSubmit {
                    print("\(name)")
                }
             */
//        }
        /*
         
         Тут примерно тоже самое,
         только ячейка постоянно прыгает при попытке изменить значения в TextEditor
         
         NavigationLink(destination: {
             TextEditor(text: $name)
                 .font(.system(size: 264))
                 .multilineTextAlignment(.center)
         }) {
             TextEditor(text: $name)
                 .font(.largeTitle)
                 .onSubmit {
                     print("\(name)")
                 }
         }
         */
    }
    */
}

struct FoodFilter: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text("Favorites")
        }
//        .animation(.linear(duration: 0.3), value: isOn)
    }
    
}


struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        SecondScreen()
    }
}
