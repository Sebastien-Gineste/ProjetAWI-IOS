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
    
    
    /**
            Function from https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
     */
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValid() -> Bool{
        return email.count > 1 && motDePasse.count > 1 && nom.count > 1 && prenom.count > 1
    }
    
    var email : String {
        didSet {
            if email != oldValue {
                if isValidEmail(email){
                    self.observer?.changed(email : self.email)
                } else{
                    self.email = oldValue
                }
            }
        }
    }
    
    
    var nom : String {
        didSet {
            if nom != oldValue {
                if nom.count >= 1{
                    self.observer?.changed(nom: self.nom)
                }
                else{
                    self.nom = oldValue
                }
            }
        }
    }
    var prenom : String{
        didSet{
            if prenom != oldValue {
                if prenom.count >= 1{
                    self.observer?.changed(prenom: self.prenom)
                }
                else{
                    self.nom = oldValue
                }
            }
        }
    }
    
    var type : TypeUtilisateur{
        didSet{
            if type != oldValue {
                self.observer?.changed(type : self.type)
            }
        }
    }
    
    var motDePasse : String {
        didSet {
            if motDePasse != oldValue {
                let regex = "^[0-9a-zA-Z]{6,}$"
                print("mdp : |\(motDePasse)| => valid ? : \(NSPredicate(format: "SELF MATCHES %@",regex).evaluate(with: motDePasse))")
                if NSPredicate(format: "SELF MATCHES %@",regex).evaluate(with: motDePasse) {
                    self.observer?.changed(motDePasse: motDePasse)
                }
                else{
                    self.motDePasse = oldValue
                }
            }
        }
    }
    
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
