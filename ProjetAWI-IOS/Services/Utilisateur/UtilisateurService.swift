//
//  UtilisateurService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import Combine

protocol UserServiceObserver{
    func emit(to : [Utilisateur])
}

class UtilisateurService{
    
    private let firestore = Firestore.firestore()
    private var tabObservers : [UserServiceObserver] = []
    
    
    @Published var utilisateurs : [Utilisateur]{
        didSet{
            for obs in self.tabObservers{
                obs.emit(to: utilisateurs)
            }
        }
    }
    
    func setObserver(obs : UserServiceObserver){
        self.tabObservers.append(obs)
        obs.emit(to: utilisateurs)
    }
    
    init(){
        self.utilisateurs = []
        self.getListUtilisateurs()
    }
    
    func getListUtilisateurs(){
        if self.utilisateurs.isEmpty {
            firestore.collection("users")
                .addSnapshotListener{
                    (data,error) in
                    guard (data?.documents) != nil else{
                        return
                    }
                    self.utilisateurs = data!.documents.map{
                        (doc) -> Utilisateur in
                        return UtilisateurDTO.transformDTO(
                            UtilisateurDTO( id : doc.documentID,
                                            email: doc["email"] as? String ?? "",
                                            estAdmin: doc["estAdmin"] as? Bool ?? false,
                                            motDePasse: "",
                                            nom: doc["nom"] as? String ?? "",
                                            prenom: doc["prenom"] as? String ?? ""))
                    }
                }
        }
        
    }
}
