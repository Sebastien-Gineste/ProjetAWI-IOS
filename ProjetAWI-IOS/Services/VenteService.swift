//
//  VenteService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol VenteServiceObserver{
    //func emit( to : Store)
    //func emit(to: Result<String,StoreViewModelError>)
}

class VenteService {
    private let firestore = Firestore.firestore()

    func addVente(vente : Vente){
        firestore.collection("ventes").addDocument(data: VenteDTO.transformToDTO(vente)){
            (error) in if let _ = error {
                //self.sendResultElement(result: .failure(.createError))
            } else {
                //self.sendResultElement(result: .success("Création effectué"))
            }
        }
    }
}
