//
//  FicheTechniqueIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import Combine

enum FicheTechniqueListIntentState : Equatable {
    case ready
    case deleteFicheTechnique(Int)
}

enum FicheTechniqueIntentState : Equatable {
    case ready
    case updateDatabase
    case addFicheTechnique
    // changing
}

struct FicheTechniqueIntent {
    private var stateList = PassthroughSubject<FicheTechniqueListIntentState, Never>()
    private var stateElement = PassthroughSubject<FicheTechniqueIntentState, Never>()
    
    func intentToDeleteFicheTechnique(id : Int){
        self.stateList.send(FicheTechniqueListIntentState.deleteFicheTechnique(id))
    }
    
    // intentToChange
    
    // addObserver
    
}
