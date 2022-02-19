//
//  UtilisateurViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum UserError : Error, Equatable, CustomStringConvertible {
    case errorName(String)
    case errorFirstName(String)
    case emailError(String)
    case mdpError(String)
    case noError
    var description: String {
        switch self {
        case .errorName(let name):
            return "Erreur avec le nom : \(name)"
        default :
            return "Erreur inconnu"
        }
    }
}

class UtilisateurViewModel : ObservableObject, UtilisateurObserver, Subscriber{
    private var model : UtilisateurListViewModel
    private var indice : Int
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    @Published var estAdmin : Bool
    @Published var motDePasse : String = ""

    @Published var error : UserError = .noError
    
    init(model : UtilisateurListViewModel, indice : Int){
        self.model = model
        self.email = model.utilisateurs[indice].email
        self.nom = model.utilisateurs[indice].nom
        self.prenom = model.utilisateurs[indice].prenom
        self.estAdmin = model.utilisateurs[indice].estAdmin
        self.indice = indice
        self.model.utilisateurs[indice].observer = self
        
    }
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(prenom: String) {
        self.prenom = prenom
    }
    
    func changed(estAdmin : Bool) {
        self.estAdmin = estAdmin
    }
    
    typealias Input = UtilisateurIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: UtilisateurIntentState) -> Subscribers.Demand {
        switch input {
            case .ready: break
            case .changingName(let nom):
                self.model.utilisateurs[self.indice].nom = nom
                if nom != self.model.utilisateurs[self.indice].nom {
                    self.error = .errorName(nom)
                    self.nom = nom
                }
            case .changingFirstName(let prenom):
                self.model.utilisateurs[self.indice].prenom = prenom
            case .changingIsAdmin(let estAdmin):
                self.model.utilisateurs[self.indice].estAdmin = estAdmin
            
        }
        return .none
    }
}
