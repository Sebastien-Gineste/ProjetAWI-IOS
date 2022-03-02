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
    func emit(to: Result<String,VenteViewModelError>)
}

class VenteService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [VenteServiceObserver] = []

    func addVente(vente : Vente){
        firestore.collection("ventes").addDocument(data: VenteDTO.transformToDTO(vente)){
            (error) in if let _ = error {
                self.sendResult(result: .failure(.createError))
            } else {
                self.sendResult(result: .success("Création effectué"))
            }
        }
    }
    
    func addObserver(observer : VenteServiceObserver){
        self.tabObserver.append(observer)
    }
    
    private func sendResult(result : Result<String,VenteViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
}
