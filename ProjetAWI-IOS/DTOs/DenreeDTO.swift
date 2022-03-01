//
//  DenreeDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation


struct DenreeDTO {
    
    var ingredient : IngredientDTO
    var number : Double
    
    static func transformDTO(_ denree : DenreeDTO) -> Denree {
        return Denree(ingredient: IngredientDTO.transformDTO(denree.ingredient),
                      nombre: denree.number)
    }
    
    static func transformToDTO(_ denree : Denree) -> [String : Any]{
        return [
            "ingredient" : IngredientDTO.transformToDTO(denree.ingredient),
            "number" : denree.nombre,
        ]
    }
    
    
    
}
