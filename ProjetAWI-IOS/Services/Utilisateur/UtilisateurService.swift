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

protocol UserServiceResultObserver{
    func emit(to : Result<String, UserError>)
}

public class UtilisateurService : ObservableObject{
    public static let instance = UtilisateurService()
    
    private let firestore = Firestore.firestore()
    private var tabObservers : [UserServiceObserver] = []
    private var tabObserversCurrentUser : [CurrentUserServiceObserver] = []
    private var tabObserversResult : [UserServiceResultObserver] = []
    
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
            email: "admin@gmail.com", nom: "admin", prenom: "admin", type: .Admin, id: "")
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
        firestore.collection("users").addDocument(data: UtilisateurDTO.transformToDTO(util)){
            (error) in if let _ = error {
                self.sendResult(result: .failure(.createError))
            } else {
                self.sendResult(result: .success("Création effectué"))
            }
        }
    }
    
    func deconnexion(){
        self.currentUtilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")
    }
    
    func deleteUtilisateur(id : String){
        firestore.collection("users").document("\(id)").delete() {
            (error) in if let _ = error {
                self.sendResult(result: .failure(.deleteError))
            } else{
                self.sendResult(result: .success("Suppresion effectué !"))
                if id == self.currentUtilisateur.id {
                    self.deconnexion()
                }
            }
        }
    }
    
    func updateUtilisateur(util : Utilisateur){
        print("updat efirestore, id : \(util.id)")
        firestore.collection("users").document("\(util.id)").updateData(
            UtilisateurDTO.transformToDTO(util)
        ) {
            (error) in if let _ = error {
                self.sendResult(result: .failure(.updateError))
            } else {
                self.sendResult(result: .success("Mise à jour effectué du compte"))
            }
        }
    }
    
    private func sendResult(result : Result<String, UserError>){
        for obs in self.tabObserversResult{
            obs.emit(to: result)
        }

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
                        
                        print("\(self.tabObserversCurrentUser.count) count current")
                        print("\(self.tabObservers.count) count list")
                        
                        let email = doc["email"] as? String ?? ""
                        let estAdmin = doc["estAdmin"] as? Bool ?? false
                        
                        if email == self.currentUtilisateur.email { // met à jour l’état de l’user si il change 
                            if estAdmin != self.currentUtilisateur.estAdmin() {
                                self.currentUtilisateur.type = estAdmin ? .Admin : .User
                            }
                        }
                        
                        return UtilisateurDTO.transformDTO(
                            UtilisateurDTO( id : doc.documentID,
                                            email: email,
                                            estAdmin: estAdmin,
                                            motDePasse: "",
                                            nom: doc["nom"] as? String ?? "",
                                            prenom: doc["prenom"] as? String ?? ""))
                    }
                }
        }
        
    }
}
