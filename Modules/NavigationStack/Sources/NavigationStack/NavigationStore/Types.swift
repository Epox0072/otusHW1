//
//  Types.swift
//  
//
//  Created by Станислав Гапонов on 11.03.2023.
//

import SwiftUI


extension NavigationStack {
    
   public enum NavigationType {
        case Push
        case Pop
    }
    
    public enum NavigationTransition {
        case None
        case Default
        case Custom(AnyTransition)
    }
    
}
