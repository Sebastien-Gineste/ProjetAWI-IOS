//
//  UserDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation

struct UtilisateurDTO : Identifiable{
    var id : String? = UUID().uuidString
    var email : String
    var estAdmin : Bool
    var motDePasse : String
    var nom : String
    var prenom : String
    
    static func transformDTO(_ utilisateurDTO : UtilisateurDTO) -> Utilisateur{
        return Utilisateur(email: utilisateurDTO.email,
                           nom: utilisateurDTO.nom,
                           prenom: utilisateurDTO.prenom,
                           estAdmin: utilisateurDTO.estAdmin ? TypeUtilisateur.Admin : TypeUtilisateur.User,
                           id: utilisateurDTO.id)
    }
}
