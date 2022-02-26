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
    case updateError
    case createError
    case deleteError
    var description: String {
        switch self {
        case .updateError:
            return "Erreur de modification"
            
        case .deleteError:
            return "Erreur lors de la suppresion"
            
        case .createError:
            return "Erreir durant la création du compte"

        case .errorName(let name):
            return "Erreur avec le nom : \(name)"
        default :
            return "Erreur inconnu"
        }
    }
}

class UtilisateurViewModel : ObservableObject, UtilisateurObserver,UserServiceResultObserver, Subscriber{
    private var model : Utilisateur
    private var userService : UtilisateurService = UtilisateurService.instance
    
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    @Published var type : TypeUtilisateur
    @Published var motDePasse : String = ""

    @Published var result : Result<String, UserError> = .success("")
    
    
    
    init(from model : Utilisateur){
        self.model = model
        self.email = model.email
        self.nom = model.nom
        self.prenom = model.prenom
        self.type = model.type
        self.model.observer = self
    }
    
    func addObserverResult(){
        userService.addObserverResult(obs: self)
    }
    
    func removeObserverResult(){
        userService.removeObserverResult()
    }
    
    func emit(to: Result<String, UserError>) {
        result = to
        print("to receive : \(to)")
    }
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(prenom: String) {
        self.prenom = prenom
    }
    
    func changed(type : TypeUtilisateur) {
        self.type = type
    }
    
    func changed(email: String) {
        self.email = email
    }
    
    func changed(motDePasse: String) {
        self.motDePasse = motDePasse
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
           
            self.model.nom = nom
            if nom != self.model.nom {
                self.result = .failure(.errorName(nom))
                self.nom = nom
            }
            
        case .changingPassword(let motDePasse):
            self.model.motDePasse = motDePasse
            
            case .changingEmail(let email):
            self.model.email = email
               
            case .changingFirstName(let prenom):
            self.model.prenom = prenom
                
            case .changingType(let type):
            self.model.type = type
            
            case .updateDatabase:
            print("update database receive")
            self.userService.updateUtilisateur(util: self.model)
            
            case .deleteUser:
            self.userService.deleteUtilisateur(id: self.model.id)
            
            case .createUser:
            print("create user database receive")
            self.userService.createUtilisateur(util: self.model)
            
        }
        return .none
    }
}
