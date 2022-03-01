//
//  HeaderFTDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation

struct HeaderFTDTO {
    
    var categorie : String
    var coefCoutProduction : Double
    var coefPrixDeVente : Double
    var coutForfaitaire : Double
    var coutMatiere : Double
    var coutMoyenHorraire : Double
    var dureeTotal : Double
    var isCalculCharge : Bool
    var nbrCouvert : Int
    var nomAuteur : String
    var nomPlat : String
    
    
    static func transformDTO(header : HeaderFTDTO, id : String) -> HeaderFT {
        return HeaderFT(nomPlat: header.nomPlat,
                        nomAuteur: header.nomAuteur,
                        nbrCouvert: header.nbrCouvert,
                        id: id,
                        categorie: header.categorie,
                        isCalculCharge: header.isCalculCharge,
                        coutMatiere: header.coutMatiere,
                        dureeTotal: header.dureeTotal,
                        coutMoyenHoraire: header.coutMoyenHorraire,
                        coutForfaitaire: header.coutForfaitaire,
                        coefCoutProduction: header.coefCoutProduction,
                        coefPrixDeVente: header.coefPrixDeVente)
    }
    
    static func transformToDTO(_ header : HeaderFT) -> [String : Any]{
        return [
            "nomPlat": header.nomPlat,
            "nomAuteur": header.nomAuteur,
            "nbrCouvert": header.nbrCouvert,
            "id": header.id,
            "categorie": header.categorie,
            "isCalculCharge": header.isCalculCharge,
            "coutMatiere": header.coutMatiere,
            "dureeTotal": header.dureeTotal,
            "coutMoyenHoraire": header.coutMoyenHoraire,
            "coutForfaitaire": header.coutForfaitaire,
            "coefCoutProduction": header.coefCoutProduction,
            "coefPrixDeVente": header.coefPrixDeVente
        ]
    }
    
    
}
