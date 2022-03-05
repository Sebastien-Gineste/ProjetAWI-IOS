//
//  EtiquetteService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol EtiquetteServiceObserver{
    func emit(to: Result<String,EtiquetteViewModelError>)
}

class EtiquetteService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [EtiquetteServiceObserver] = []

    func addEtiquette(etiquette : Etiquette) -> String{
        let ref = firestore.collection("etiquettes").addDocument(data: EtiquetteDTO.transformToDTO(etiquette)){
            (error) in if let _ = error {
                self.sendResult(result: .failure(.createError))
            } else {
                // TO DO : Create Vente
                self.sendResult(result: .success("Création effectué"))
            }
        }
        return ref.documentID
    }
    
    func addObserver(observer : EtiquetteServiceObserver){
        self.tabObserver.append(observer)
    }
    
    private func sendResult(result : Result<String,EtiquetteViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
}
