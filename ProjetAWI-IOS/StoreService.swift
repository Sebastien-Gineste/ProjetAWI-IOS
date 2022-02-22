//
//  StoreService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol StoreServiceObserver{
    func emit( to : Store)
}

class StoreService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [StoreServiceObserver] = []
    @Published var store : Store {
        didSet {
            for observer in tabObserver {
                observer.emit(to: store)
            }
        }
    }
    
    init(){
        self.store = Store(coefCoûtProduction: 0, coefPrixDeVente: 0, coûtForfaitaire: 0, coûtMoyen: 0)
    }
    
    func addObserver(observer : StoreServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: store)
    }
    
    func getStore(){
        firestore.collection("preferences").document("store")
            .addSnapshotListener{
                (data,error) in
                guard (data) != nil else{
                    return
                }
                self.store = StoreDTO.transformDTO(
                    StoreDTO(coefCoûtProduction: data?.data()!["coefCoûtProduction"] as? Double ?? 0 ,
                             coefPrixDeVente: data?.data()!["coefPrixDeVente"] as? Double ?? 0,
                             coûtForfaitaire: data?.data()!["coûtForfaitaire"] as? Double ?? 0,
                             coûtMoyen: data?.data()!["coûtMoyen"] as? Double ?? 0))
            }
    }
}
