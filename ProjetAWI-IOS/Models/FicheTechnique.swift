//
//  FicheTechnique.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

/**
    Classe qui contient les étapes principales de la fiche (les plus haute)
    Elle contient soit un tableau d'une case qui contient une étape si elle correspond à une simple étape
    soit un tableau de plusieurs étape correspondant à une sous-fiche-technique
 */
class EtapeFiche {
    
    var etapes : [Etape] // [0] si étape normale | [n] si sous-fiche-technique
    
    var nomSousFicheTechnique : String? // nom de la sous-fiche technique si présente
    
    init(etapes : [Etape], nomSousFicheTechnique : String? = nil){
        self.etapes = etapes
        self.nomSousFicheTechnique = nomSousFicheTechnique
    }
    
    var getDureeTotal : Double {
        if self.nomSousFicheTechnique != nil {
            var temps : Double = 0
            for etape in self.etapes {
                temps += etape.description.tempsPreparation
            }
            return temps
        }
        else{
            return self.etapes[0].description.tempsPreparation
        }
    }
    
}

protocol FicheTechniqueObserver {
    // à compléter 
    
}

class FicheTechnique {
    
    var header : HeaderFT
    var progression : [EtapeFiche]
    var materielSpecifique : String?
    var materielDressage : String?
    
    init(header : HeaderFT, progression : [EtapeFiche], materielSpecifique : String? = nil, materielDressage : String? = nil){
        self.header = header
        self.progression = progression
        self.materielDressage = materielDressage
        self.materielSpecifique = materielSpecifique
    }
    
    /**
            Get toutes les étapes de la fiche technique
     */
    var getEtape : [Etape] {
        var etapes : [Etape] = []
        for etapeFiche in self.progression {
            for etape in etapeFiche.etapes {
                etapes.append(etape)
            }
        }
        return etapes
    }
    
    /**
            Calcul la durée total des étapes ainsi que le coût matière
     */
    func calculDenreeEtCoutMatiere(){
        self.header.dureeTotal = 0
        self.header.coutMatiere = 0
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                self.header.dureeTotal += etape.description.tempsPreparation
                for denree in etape.contenu{
                    self.header.coutMatiere += denree.ingredient.prixUnitaire * denree.nombre
                }
            }
        }
    }
    
    /**
            Renvoie vrai si la fiche contient tous les ingrédients de la liste
     */
    func contientIngrédients(tabIngrédient : [String]) -> Bool {
        var listNomsIngrédients : [String] = []
        for ingredient in tabIngrédient {
            listNomsIngrédients.append(ingredient)
        }
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if listNomsIngrédients.contains(denree.ingredient.nomIngredient){
                        if let id : Int = listNomsIngrédients.firstIndex(of: denree.ingredient.nomIngredient) {
                            listNomsIngrédients.remove(at: id)
                            if listNomsIngrédients.count == 0 {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    /**
       * Recupère toute la liste des denrées de la fiche technique
    */
    var getListDenree : [Denree] {
        var denrees : [Denree] = []
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if denrees.contains(where: {den in den.ingredient.nomIngredient == denree.ingredient.nomIngredient}) {
                        // on a déjà croisé l'ingrédient, on augmente son nombre
                        for denreeTab in denrees {
                            if denreeTab.ingredient.nomIngredient == denree.ingredient.nomIngredient {
                                denreeTab.nombre += denree.nombre
                            }
                        }
                    }
                    else{
                        // on avait pac croisé l'ingrédient encore, on l'ajoute
                        let nbr = denree.nombre
                        let ingredient : Ingredient = denree.ingredient.getCopyIngredient()
                        denrees.append(Denree(ingredient: ingredient, nombre: nbr))
                    }
                }
            }
        }
        
        return denrees
    }
    
    /**
            retourne vrai si l'ingrédient est contenue
     */
    func  isContientIngredient(ingredient : Ingredient) -> Bool {
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if ingredient.nomIngredient == denree.ingredient.nomIngredient {
                       return true
                    }
                }
            }
        }
        return false
    }
    
    
    
    
    
}
