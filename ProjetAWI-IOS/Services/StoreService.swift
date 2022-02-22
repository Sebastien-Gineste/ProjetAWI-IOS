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

class StoreService {
    private let firestore = Firestore.firestore()
    @Published var store : Store
    init(){
        self.store = Store(coefCoûtProduction: 0, coefPrixDeVente: 0, coûtForfaitaire: 0, coûtMoyen: 0)
    }
    func getStore(){
        firestore.collection("preferences")
            .addSnapshotListener{
                (data,error) in
                guard (data?.documents) != nil else{
                    return
                }
                let storeTemp : [Store] = data!.documents.map{
                    (doc) -> Store in
                    return StoreDTO.transformDTO(
                        StoreDTO(coefCoûtProduction: doc["coefCoûtProduction"] as? Double ?? 0 ,
                                 coefPrixDeVente: doc["coefPrixDeVente"] as? Double ?? 0,
                                 coûtForfaitaire: doc["coûtForfaitaire"] as? Double ?? 0,
                                 coûtMoyen: doc["coûtMoyen"] as? Double ?? 0))
                }
                self.store = storeTemp[0]
            }
    }
}
