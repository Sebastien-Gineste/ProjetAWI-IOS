//
//  IngredientListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import SwiftUI
import Combine

class IngredientListViewModel : ObservableObject, Subscriber, IngredientListServiceObserver {

    private var ingredientService : IngredientService = IngredientService()
    @Published var tabIngredient : [Ingredient]
    
    init() {
        self.tabIngredient = []
        self.ingredientService.addObserver(observer: self)
        self.ingredientService.getAllIngredient()
    }
    
    func emit(to: [Ingredient]) {
        self.tabIngredient = to
    }
    
    typealias Input = IngredientListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: IngredientListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteIngredient(_):
            break
        }
        return .none
    }
    
    
}
