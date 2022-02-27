//
//  IngredientDTO.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022
//

struct IngredientDTO {
    var id : String
    var nomIngredient : String
    var prixUnitaire : Double
    var qteIngredient : Double
    var unite : String
    var categorie : String
    var listAllergene : [String]
    
    static func transformDTO(_ ingredient : IngredientDTO) -> Ingredient {
        return Ingredient(nomIngredient: ingredient.nomIngredient,
                          prixUnitaire: ingredient.prixUnitaire,
                          qteIngredient: ingredient.qteIngredient,
                          unite: ingredient.unite,
                          categorie: ingredient.categorie,
                          id: ingredient.id)
    }
    
    static func transformToDTO(_ ingredient : Ingredient) -> [String : Any]{
        return [
            "nomIngredient" : ingredient.nomIngredient,
            "prixUnitaire" : ingredient.prixUnitaire,
            "qteIngredient" : ingredient.qteIngredient,
            "unite" : ingredient.unite,
            "categorie" : ingredient.categorie,
            "listAllergene" : [],
        ]
    }
}
