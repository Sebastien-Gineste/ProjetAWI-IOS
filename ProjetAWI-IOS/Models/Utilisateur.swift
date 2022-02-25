//
//  User.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation

protocol UtilisateurObserver {
    func changed(nom : String)
    func changed(prenom : String)
    func changed(type : TypeUtilisateur)
    func changed(email : String)
    func changed(motDePasse : String)
}

enum TypeUtilisateur : String, CaseIterable, Identifiable{
    case User, Admin
    var id: Self {self}
}

class Utilisateur : ObservableObject{
    var observer : UtilisateurObserver?
    var id : String = UUID().uuidString
    var email : String
    var nom : String {
        didSet {
            self.observer?.changed(nom: self.nom)
        }
    }
    var prenom : String{
        didSet{
            self.observer?.changed(prenom: self.prenom)
        }
    }
    var type : TypeUtilisateur{
        didSet{
            self.observer?.changed(type : self.type)
        }
    }
    
    var motDePasse : String = ""
    
    func estConnecte() -> Bool{
        return self.email.count > 3 
    }
    
    func estAdmin() -> Bool{
        return self.type == .Admin && self.estConnecte()
    }
    
    init(email : String, nom : String, prenom : String, type : TypeUtilisateur, id : String, mdp : String = ""){
        self.email = email
        self.nom = nom
        self.prenom = prenom
        self.type = type
        self.id = id
        self.motDePasse = mdp
    }
    
}
