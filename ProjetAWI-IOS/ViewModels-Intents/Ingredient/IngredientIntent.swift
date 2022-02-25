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
    case deleteIngredient(Int)
}

enum IngredientIntentState : Equatable {
    case ready
    case changingNom(String)
    case changingPrix(Double)
    case changingQuantité(Double)
    case changingUnite(String)
    case changingCategorie(String)
    case updateDatabase
    case addIngredient
}

struct IngredientIntent  {
    private var stateList = PassthroughSubject<IngredientListIntentState,Never>()
    private var stateElement = PassthroughSubject<IngredientIntentState,Never>()

    func intentToChange(nomIngrédient : String){
        self.stateElement.send(IngredientIntentState.changingNom(nomIngrédient))
    }
   
    func intentToChange(prixUnitaire : Double){
        self.stateElement.send(IngredientIntentState.changingPrix(prixUnitaire))
    }
    
    func intentToChange(quantité : Double){
        self.stateElement.send(IngredientIntentState.changingQuantité(quantité))
    }
    
    func intentToChange(unite : String){
        self.stateElement.send(IngredientIntentState.changingUnite(unite))
    }
    
    func intentToChange(categorie : String){
        self.stateElement.send(IngredientIntentState.changingCategorie(categorie))
    }
   
    func addObserver(_ ingredientListView : IngredientListViewModel){
        self.stateList.subscribe(ingredientListView)
    }
    
    func addObserver(_ ingredientView : IngredientViewModel){
        self.stateElement.subscribe(ingredientView)
    }
}
