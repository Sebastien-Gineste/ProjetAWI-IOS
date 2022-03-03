//
//  FicheTechniqueIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import Combine
import SwiftUI

enum FicheTechniqueListIntentState : Equatable {
    case ready
    case deleteFicheTechnique(Int)
}

enum FicheTechniqueIntentState : Equatable {
    case ready
    case updateFicheTechnique
    case addFicheTechnique
    case deleteFicheTechnique
    
    case changingNomPlat(String)
    case changingNomAuteur(String)
    case changingCategorie(String)
    case changingNbrCouvert(Int)
    
    case moveEtape(IndexSet,Int)
    case deleteEtape(Int)
    case addEtape
    case addSousFicheTechnique(String)
    // changing
}

struct FicheTechniqueIntent {
    private var stateList = PassthroughSubject<FicheTechniqueListIntentState, Never>()
    private var stateElement = PassthroughSubject<FicheTechniqueIntentState, Never>()
    
    /* Function for update the database */
    
    func intentToDeleteFicheTechniqueFromList(id : Int){
        self.stateList.send(FicheTechniqueListIntentState.deleteFicheTechnique(id))
    }
    
    func intentToDeleteFicheTechniqueFromDetail(){
        self.stateElement.send(FicheTechniqueIntentState.deleteFicheTechnique)
    }
    
    func intentToAddFicheTechnique(){
        self.stateElement.send(FicheTechniqueIntentState.addFicheTechnique)
    }
    
    func intentToUpdateFicheTechnique(){
        self.stateElement.send(FicheTechniqueIntentState.updateFicheTechnique)
    }
    
    /* Function for update the model */
    
    func intentToChange(nomPlat : String){
        self.stateElement.send(FicheTechniqueIntentState.changingNomPlat(nomPlat))
    }
    
    func intentToChange(nomAuteur : String){
        self.stateElement.send(FicheTechniqueIntentState.changingNomAuteur(nomAuteur))
    }
    
    func intentToChange(categorie : String){
        self.stateElement.send(FicheTechniqueIntentState.changingCategorie(categorie))
    }
    
    func intentToChange(nbrCouvert : Int){
        self.stateElement.send(FicheTechniqueIntentState.changingNbrCouvert(nbrCouvert))
    }

    func intentToMoveEtape(from : IndexSet, to : Int){
        self.stateElement.send(FicheTechniqueIntentState.moveEtape(from, to))
    }
    
    func intentToAddEtape(){
        self.stateElement.send(FicheTechniqueIntentState.addEtape)
    }
    
    func intentToAddSousFicheTechnique(id : String){
        self.stateElement.send(FicheTechniqueIntentState.addSousFicheTechnique(id))
    }
    
    func intentToRemoveEtape(id : Int){
        self.stateElement.send(FicheTechniqueIntentState.deleteEtape(id))
    }
    
    
    
    // addObserver
    func addObserver (_ fiche : FicheTechniqueViewModel) {
        self.stateElement.subscribe(fiche)
    }
    
    func addObserver (_ ficheList : FicheTechniqueListViewModel){
        self.stateList.subscribe(ficheList)
    }
    
}
