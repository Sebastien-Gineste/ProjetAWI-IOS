//
//  Allergène.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

protocol AllergèneObserver {
    func changed(nom : String)
    func changed(listIngredient : [String])
}

class Allergène {
    var observer: AllergèneObserver?
    var id : String?
    var nom : String {
        didSet {
            if self.nom != oldValue {
                if self.nom.count >= 1 {
                    self.observer?.changed(nom: self.nom)
                } else {
                    self.nom = oldValue
                }
            }
        }
    }
    var listIngredient : [String] {
        didSet {
            if self.listIngredient != oldValue {
                self.observer?.changed(listIngredient: self.listIngredient)
            }
        }
    }
    
    init(nom : String, listIngredient : [String], id : String? = nil){
        self.nom = nom
        self.listIngredient = listIngredient
        self.id = id
    }
}
