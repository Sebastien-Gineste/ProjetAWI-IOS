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

public class UtilisateurService : ObservableObject{
    public static let instance = UtilisateurService()
    
    private let firestore = Firestore.firestore()
    private var tabObservers : [UserServiceObserver] = []
    private var tabObserversCurrentUser : [CurrentUserServiceObserver] = []
    
    @Published var currentUtilisateur : Utilisateur{ // regarde si déconnexion ou connexion
        didSet{
            print("new value : \(currentUtilisateur.email)")
            emitCurrentUser()
        }
        willSet{
            print("old value : \(currentUtilisateur.email)")
        }
    }
    
    @Published var utilisateurs : [Utilisateur]{
        didSet{
            emitListUser()
            print("new value : \(utilisateurs.count)")
        }
        willSet{
            print("old value : \(utilisateurs.count)")
        }
    }
    
    func emitCurrentUser(){
        for obs in self.tabObserversCurrentUser{
            obs.emit(to: self.currentUtilisateur)
        }
    }
    
    func emitListUser(){
        for obs in self.tabObservers{
            obs.emit(to: self.utilisateurs)
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
            email: "", nom: "", prenom: "", type: .User, id: "")
    }
    
    func connexion(email : String, mdp : String){
        firestore.collection("users").whereField("email", isEqualTo: email)
            .getDocuments(){
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting document : \(err)")
                }
                else{
                    print("gogogo")
                    if querySnapshot!.documents.count == 1 {
                        print("good")
                        let user = querySnapshot!.documents[0].data()
                        if user["email"]  as? String ?? "" == email && user["motdepasse"] as? String ?? "" == mdp {
                            // good credential
                            self.currentUtilisateur = UtilisateurDTO.transformDTO(UtilisateurDTO(
                               id : querySnapshot!.documents[0].documentID,
                               email: user["email"] as? String ?? "",
                               estAdmin: user["estAdmin"] as? Bool ?? false,
                               motDePasse: "",
                               nom: user["nom"] as? String ?? "",
                               prenom: user["prenom"] as? String ?? ""))
                            self.emitCurrentUser()
                        }
                        else{
                            print("bad password")
                        }
                       
                    }
                    else{
                        print("no response")
                    }
                }
            }
    }
    
    func createUtilisateur(util : Utilisateur){
        self.utilisateurs.append(util)
        emitListUser()
        
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
