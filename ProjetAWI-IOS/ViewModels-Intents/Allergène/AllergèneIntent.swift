//
//  AllergèneIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import Combine

enum AllergèneListIntentState : Equatable {
    case ready
    case deleteAllergène(Int)
    case updateIngredientFromAllergène
}

enum AllergèneIntentState : Equatable {
    case ready
    case changingNom(String)
    case changingListIngredient([String])
    case updateDatabase
    case addAllergène
}

struct AllergèneIntent  {
    private var stateList = PassthroughSubject<AllergèneListIntentState,Never>()
    private var stateElement = PassthroughSubject<AllergèneIntentState,Never>()

    func intentToChange(nom : String){
        self.stateElement.send(AllergèneIntentState.changingNom(nom))
    }
    
    func intentToChange(listIngredient : [String]){
        self.stateElement.send(AllergèneIntentState.changingListIngredient(listIngredient))
    }
    
    func intentToUpdateDatabase(){
        self.stateElement.send(AllergèneIntentState.updateDatabase)
    }
    
    func intentToDeleteAllergène(id : Int){
        self.stateList.send(AllergèneListIntentState.deleteAllergène(id))
    }
    
    func intentToAddAllergène(){
        self.stateElement.send(AllergèneIntentState.addAllergène)
    }
    
    func intentToUpdateIngredientFromAllergène(){
        self.stateList.send(AllergèneListIntentState.updateIngredientFromAllergène)
    }
    
    func addObserver(_ allergèneListView : AllergèneListViewModel){
        self.stateList.subscribe(allergèneListView)
    }
    
    func addObserver(_ allergèneView : AllergèneViewModel){
        self.stateElement.subscribe(allergèneView)
    }
}
