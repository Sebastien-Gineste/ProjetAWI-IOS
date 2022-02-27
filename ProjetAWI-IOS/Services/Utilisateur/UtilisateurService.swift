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
    func emit(to : Result<String, UtilisateurListError>)
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
    
    private var observerList : UserServiceObserver? = nil // Observeur de la liste utilisateurs et de ses résultats aux requêtes
    private var observerResult : UserServiceResultObserver? = nil // Observer des résultat des requêtes sur un utilisateur
    
    private var tabObserversCurrentUser : [CurrentUserServiceObserver] = []
    
    private var requeteEnCours = false
    
    
    @Published var currentUtilisateur : Utilisateur{ // état courant de l'utilisateur
        didSet{
            print("new value : \(currentUtilisateur.email)")
            emitCurrentUser()
        }
        willSet{
            print("old value : \(currentUtilisateur.email)")
        }
    }
    
    private var utilisateurs : [Utilisateur]{
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
        self.observerList?.emit(to: self.utilisateurs)
    }
    
    func addObserverList(obs : UserServiceObserver){
        self.observerList = obs
        self.observerList?.emit(to: utilisateurs)
    }
    
    func addObserverCurrent(obs : CurrentUserServiceObserver){
        self.tabObserversCurrentUser.append(obs)
        obs.emit(to: currentUtilisateur)
    }
    
    func addObserverResult(obs : UserServiceResultObserver){
        self.observerResult = obs
    }
    
    func removeObserverResult(){
        self.observerResult = nil
    }
    
    private func sendResult(result : Result<String, UserError>){
        self.observerResult?.emit(to: result)
    }
    
    private func sendResultList(result : Result<String, UtilisateurListError>){
        self.observerList?.emit(to: result)
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
            (error) in
            print("création go go go ")
            if let _ = error {
                self.sendResult(result: .failure(.createError))
            } else {
                self.sendResultList(result: .success("Création effectué"))
            }
        }
    }
    
    func deconnexion(){
        self.currentUtilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")
    }
    
    func deleteUtilisateur(id : String){
        firestore.collection("users").document("\(id)").delete() {
            (error) in if let _ = error {
                self.sendResultList(result: .failure(.deleteError))
            } else{
                self.sendResultList(result: .success("Suppresion effectué !"))
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
                print("send success !!! ")
                print("Observer Result : \(self.observerResult)")
                self.sendResult(result: .success("Mise à jour effectué du compte from result"))
                self.sendResultList(result: .success("Mise à jour effectué du compte from list"))
            }
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
