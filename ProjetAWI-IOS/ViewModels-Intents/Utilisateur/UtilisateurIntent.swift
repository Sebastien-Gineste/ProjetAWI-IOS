//
//  UtilisateurIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum UtilisateurIntentState : CustomStringConvertible, Equatable {
    case ready
    case changingName(String)
    case changingFirstName(String)
    case changingType(TypeUtilisateur)
    var description: String {
        switch self {
        case .ready : return "ready"
        case .changingFirstName(let prenom) : return "Va changer son prénom : \(prenom)"
        case .changingType(let typeUtilisateur) : return "Va changer son statue : \(typeUtilisateur)"
        case .changingName(let nom) : return "Va changer son nom : \(nom)"
        }
    }
}

enum UtilisateurListIntentState : Equatable{
    case ready
    case updateList
}

struct UtilisateurIntent  {
    private var stateElement = PassthroughSubject<UtilisateurIntentState,Never>()
    private var stateList = PassthroughSubject<UtilisateurListIntentState,Never>()
    
    func intentToChange(name : String){
        self.stateElement.send(UtilisateurIntentState.changingName(name))
        self.updateList()
    }
    
    func intentToChange(firstName : String) {
        self.stateElement.send(UtilisateurIntentState.changingFirstName(firstName))
        self.updateList()
    }
    
    func intentToChange(type : TypeUtilisateur){
        self.stateElement.send(UtilisateurIntentState.changingType(type))
        self.updateList()
    }
    
    func addObserver(utilisateurViewModel : UtilisateurViewModel, utilisateurListViewModel : UtilisateurListViewModel ){
        self.stateElement.subscribe(utilisateurViewModel)
        self.stateList.subscribe(utilisateurListViewModel)
    }
    
    func updateList(){
        self.stateList.send(.updateList)
    }
}
