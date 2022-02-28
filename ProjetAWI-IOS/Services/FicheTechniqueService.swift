//
//  FicheTechniqueService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation
import FirebaseFirestore

class FicheTechniqueService {
    private let firestore = Firestore.firestore()
 
    private var tabFicheTechnique : [FicheTechnique]
    
    
    init(){
        self.tabFicheTechnique = []
    }
    /* à compléter
    func getAllIngredient(){
        firestore.collection("fiche-techniques").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabFicheTechnique = documents.map{
                (doc) -> FicheTechnique in
                return FicheTechniqueDTO.transformDTO(
                    FicheTechniqueDTO(id: doc.documentID,
                                      nomIngredient: doc["nomIngredient"] as? String ?? "",
                                      prixUnitaire: doc["prixUnitaire"] as? Double ?? 0,
                                      qteIngredient: doc["qteIngredient"] as? Double ?? 0,
                                      unite: doc["unite"] as? String ?? "",
                                      categorie: doc["categorie"] as? String ?? "",
                                      listAllergene: doc["listAllergene"] as? [String] ?? []))
            }
        }

    }*/
    
    

}
