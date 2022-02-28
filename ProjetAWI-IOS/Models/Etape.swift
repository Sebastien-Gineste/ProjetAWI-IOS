//
//  Etape.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

protocol EtapeObserver{
    func changed(contenu : [Denree])
    func changed(description : Description)
}


class Etape {
    var observer : EtapeObserver?
    
    var contenu : [Denree]
    var description : Description
    
    init(contenu : [Denree] = [], description : Description = Description(nom: "etape", description: "description", tempsPreparation: 10)){
        self.contenu = contenu
        self.description = description
    }
    
    // fonction à voir
    func getCopyEtape() -> Etape{
        var dNew : [Denree] = []
        for denree in self.contenu {
            dNew.append(Denree(ingredient :denree.ingredient,nombre: denree.nombre))
        }
        return Etape(contenu: dNew, description: self.description)
    }
    
}
