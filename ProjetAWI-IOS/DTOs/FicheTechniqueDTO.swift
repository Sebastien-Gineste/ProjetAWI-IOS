//
//  FicheTechniqueDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation

struct EtapeFicheDTO {
    
    var etapes : [EtapeDTO]
    var identification : String?
    
    static func transformDTO(_ etapeFiche : EtapeFicheDTO) -> EtapeFiche {
        return EtapeFiche(etapes : etapeFiche.etapes.map{
            (etape) -> Etape in
            return EtapeDTO.transformDTO(etape)
        },
                          nomSousFicheTechnique: etapeFiche.identification)
    }
    
    static func transformToDTO(_ etapeFiche : EtapeFiche) -> [String : Any]{
        var tab : [String : Any] = [
            "etapes" : etapeFiche.etapes.map{
                (etape) -> [String : Any] in
                return EtapeDTO.transformToDTO(etape)
            }
        ]
        
        if etapeFiche.nomSousFicheTechnique != nil {
            tab["identification"] = etapeFiche.nomSousFicheTechnique
        }
        
        return tab
    }
    
}

struct FicheTechniqueDTO {
    
    var header : HeaderFTDTO
    var id : String
    var materielSpecifique : String?
    var materielDressage : String?
    var progression : [EtapeFicheDTO]
    
    static func transformDTO(_ ficheTechnique : FicheTechniqueDTO) -> FicheTechnique {
        return FicheTechnique(header: HeaderFTDTO.transformDTO(header : ficheTechnique.header, id: ficheTechnique.id ),
                              progression: ficheTechnique.progression.map {
            (etapeFiche) -> EtapeFiche in
            return EtapeFicheDTO.transformDTO(etapeFiche)
        },
                              materielSpecifique: ficheTechnique.materielSpecifique,
                              materielDressage: ficheTechnique.materielDressage)
    }
    
    static func transformToDTO(_ ficheTechnique : FicheTechnique) -> [String : Any]{
        
        var tab : [String : Any] = [
            "header" : HeaderFTDTO.transformToDTO(ficheTechnique.header),
            "progression" : ficheTechnique.progression.map{
                (etapeFiche) -> [String : Any] in
                return EtapeFicheDTO.transformToDTO(etapeFiche)
            }
        ]
        
        if ficheTechnique.materielDressage != nil {
            tab["materielDressage"] = ficheTechnique.materielDressage
        }
        
        if ficheTechnique.materielSpecifique != nil {
            tab["materielSpecifique"] = ficheTechnique.materielSpecifique
        }
    
        
        return tab
    }
    
}
