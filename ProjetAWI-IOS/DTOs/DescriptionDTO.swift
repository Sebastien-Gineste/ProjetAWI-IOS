//
//  DescriptionDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation

struct DescriptionDTO {
    
    var description : String
    var nom : String
    var tempsPreparation : Double
    
    static func transformDTO(_ description : DescriptionDTO) -> Description {
        return Description(nom: description.nom,
                           description: description.description,
                           tempsPreparation: description.tempsPreparation)
    }
    
    static func transformToDTO(_ description : Description) -> [String : Any]{
        return [
            "description" : description.description,
            "nom" : description.nom,
            "tempsPreparation" : description.tempsPreparation
        ]
    }
    
}
