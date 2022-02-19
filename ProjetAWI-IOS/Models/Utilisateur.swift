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
    func changed(estAdmin : Bool)
}

class Utilisateur {
    var observer : UtilisateurObserver?
    var id : String?
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
    var estAdmin : Bool{
        didSet{
            self.observer?.changed(estAdmin : self.estAdmin)
        }
    }
    
    init(email : String, nom : String, prenom : String, estAdmin : Bool, id : String?){
        self.email = email
        self.nom = nom
        self.prenom = prenom
        self.estAdmin = estAdmin
        self.id = id
    }
    
}
