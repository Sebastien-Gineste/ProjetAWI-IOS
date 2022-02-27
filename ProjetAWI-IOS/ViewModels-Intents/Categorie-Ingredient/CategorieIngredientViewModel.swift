//
//  CategorieIngredientViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import SwiftUI
import Combine

class CategorieIngredientViewModel : ObservableObject, /*Subscriber,*/ CategorieIngredientServiceObserver {

    private var categorieIngredientService : CategorieIngredientService = CategorieIngredientService()
    @Published var tabCategorieIngredient : [String]
    @Published var result : Result<String, AllergèneListViewModelError> = .failure(.noError)

    init() {
        self.tabCategorieIngredient = ["Choisir"]
        self.categorieIngredientService.addObserver(observer: self)
        self.categorieIngredientService.getAllCategorieIngredient()
    }
    
    func emit(to: [String]) {
        self.tabCategorieIngredient = ["Choisir"]
        self.tabCategorieIngredient.append(contentsOf: to)
    }
    /*
    func emit(to: Result<String, AllergèneListViewModelError>) {
        self.result = to
    }
    
    typealias Input = AllergèneListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: AllergèneListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteAllergène(let id):
            self.allergèneService.deleteAllergène(id: self.tabAllergène[id].id!)
        }
        return .none
    }
    
    */
}
