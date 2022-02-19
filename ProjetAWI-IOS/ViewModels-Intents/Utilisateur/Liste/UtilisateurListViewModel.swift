//
//  UtilisateurListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UtilisateurListViewModel : ObservableObject, Subscriber{
    @Published var utilisateurs : [Utilisateur]
    private let firestore = Firestore.firestore()
    
    init(){
        self.utilisateurs = []
        self.getListUtilisateurs()
    }
    
    func getListUtilisateurs(){
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
    
    typealias Input = UtilisateurListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
           subscription.request(.unlimited)
    }
       
    func receive(completion: Subscribers.Completion<Never>) {
       return
    }
   
    func receive(_ input: UtilisateurListIntentState) -> Subscribers.Demand {
       switch input {
       case .ready:
           break
       case .updateList:
           self.objectWillChange.send()
           break
       }
       return .none
    }
}
