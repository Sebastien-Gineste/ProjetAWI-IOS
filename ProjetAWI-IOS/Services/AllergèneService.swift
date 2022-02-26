//
//  AllergèneService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AllergèneListServiceObserver {
    func emit(to: [Allergène])
    func emit(to: Result<String,AllergèneListViewModelError>)
}

protocol AllergèneServiceObserver {
    func emit(to: Result<String,AllergèneViewModelError>)
}

class AllergèneService {
    
    private let firestore = Firestore.firestore()
    private var tabListObserver : [AllergèneListServiceObserver] = []
    private var tabObserver : [AllergèneServiceObserver] = []
    private var tabAllergène : [Allergène] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabAllergène)
            }
        }
    }
    
    init(){
        self.tabAllergène = []
    }
    
    func addObserver(observer : AllergèneListServiceObserver){
        self.tabListObserver.append(observer)
        observer.emit(to: tabAllergène)
    }
    
    func addObserver(observer : AllergèneServiceObserver){
        self.tabObserver.append(observer)
    }
    
    func getAllAllergène(){
        firestore.collection("allergenes").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            
            print("\(self.tabObserver.count) count list allergène")
            
            self.tabAllergène = documents.map{
                (doc) -> Allergène in
                return AllergèneDTO.transformDTO(
                    AllergèneDTO(id: doc.documentID,
                                 nom: doc["nom"] as? String ?? "" ))
            }
        }

    }
    
    func updateAllergène(allergène : Allergène){
        let ref = firestore.collection("allergenes").document(allergène.id!)
        ref.updateData(AllergèneDTO.transformToDTO(allergène)) {
            (error) in
            if let _ = error {
                self.sendResultElement(result: .failure(.updateError))
            } else {
                self.sendResultElement(result: .success("Mise a jour effectué"))
            }
        }
    }
    
    func deleteAllergène(id : String){
        firestore.collection("allergenes").document(id).delete() {
            (error) in if let _ = error {
                self.sendResultList(result: .failure(.deleteError))
            } else{
                self.sendResultList(result: .success("Suppresion effectué !"))
            }
        }
    }
    
    func addAllergène(allergène : Allergène){
        firestore.collection("allergenes").addDocument(data: AllergèneDTO.transformToDTO(allergène)){
            (error) in if let _ = error {
                self.sendResultElement(result: .failure(.createError))
            } else {
                self.sendResultElement(result: .success("Création effectué"))
            }
        }
    }
    
    private func sendResultElement(result : Result<String,AllergèneViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
    
    private func sendResultList(result : Result<String,AllergèneListViewModelError>){
        for observer in self.tabListObserver {
            observer.emit(to: result)
        }
    }
}
