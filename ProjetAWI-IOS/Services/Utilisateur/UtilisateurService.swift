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

protocol CurrentUserServiceObserver{
    func emit(to : Utilisateur)
}

public class UtilisateurService{
    public static let instance = UtilisateurService()
    
    private let firestore = Firestore.firestore()
    private var tabObservers : [UserServiceObserver] = []
    private var tabObserversCurrentUser : [CurrentUserServiceObserver] = []
    
    @Published var currentUtilisateur : Utilisateur{ // regarde si déconnexion ou connexion
        didSet{
            for obs in self.tabObserversCurrentUser{
                obs.emit(to: currentUtilisateur)
            }
        }
    }
    
    @Published var utilisateurs : [Utilisateur]{
        didSet{
            for obs in self.tabObservers{
                obs.emit(to: utilisateurs)
            }
        }
    }
    
    func setObserverList(obs : UserServiceObserver){
        self.tabObservers.append(obs)
        obs.emit(to: utilisateurs)
    }
    
    func setObserverCurrent(obs : CurrentUserServiceObserver){
        self.tabObserversCurrentUser.append(obs)
        obs.emit(to: currentUtilisateur)
    }
    
    private init(){
        self.utilisateurs = []
        self.currentUtilisateur = Utilisateur(
            email: "", nom: "", prenom: "", estAdmin: .User, id: "")
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
