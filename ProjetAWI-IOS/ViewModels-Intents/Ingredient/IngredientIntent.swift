//
//  IngredientIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 23/02/2022.
//

import Foundation
import Combine

enum IngredientListIntentState : Equatable {
    case ready
}


struct IngredientIntent  {
    private var stateList = PassthroughSubject<IngredientListIntentState,Never>()
    
    func addObserver(_ ingredientListView : IngredientListViewModel){
        self.stateList.subscribe(ingredientListView)
    }
}
