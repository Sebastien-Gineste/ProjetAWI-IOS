//
//  FicheTechniqueDetailViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import SwiftUI
import Combine

enum FicheTechniqueViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case updateError
    case createError
    case inputError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .updateError : return "Erreur de mise à jour"
        case .createError : return "Erreur de création"
        case .inputError : return "Input non valide"
        }
    }
}

class FicheTechniqueViewModel : ObservableObject, Subscriber, FicheTechniqueServiceObserver, HeaderFTObserver {
    private var ficheTechniqueService : FicheTechniqueService = FicheTechniqueService()
    private var ficheTechnique : FicheTechnique
    
    @Published var nomPlat : String
    @Published var categorie : String
    @Published var nomAuteur : String
    @Published var couvert : Int
    @Published var isCalculCharge : Bool
    @Published var coutMatiere : Double
    @Published var dureeTotal : Double
    @Published var coutMoyenHoraire : Double
    @Published var coutForfaitaire : Double
    @Published var coefCoutProduction : Double
    @Published var coefPrixDeVente : Double
    
    @Published var header : HeaderFT
    @Published var progression : [EtapeFiche]
    
    @Published var result : Result<String, FicheTechniqueViewModelError> = .failure(.noError)
    
    init(ficheTechniqueListViewModel : FicheTechniqueListViewModel? = nil, indice : Int? = nil) {
        if let indice = indice , let ficheTechniqueListViewModel = ficheTechniqueListViewModel{
            self.ficheTechnique = ficheTechniqueListViewModel.tabFicheTechnique[indice]
        } else {
            self.ficheTechnique = FicheTechnique(header: HeaderFT(nomPlat: "Fiche technique", nomAuteur: "", nbrCouvert: 1), progression: [])
        }
        
        self.nomPlat = self.ficheTechnique.header.nomPlat
        self.categorie = self.ficheTechnique.header.categorie
        self.nomAuteur = self.ficheTechnique.header.nomPlat
        self.couvert = self.ficheTechnique.header.nbrCouvert
        self.isCalculCharge = self.ficheTechnique.header.isCalculCharge
        self.coutMatiere = self.ficheTechnique.header.coutMatiere
        self.dureeTotal = self.ficheTechnique.header.dureeTotal
        self.coutMoyenHoraire = self.ficheTechnique.header.coutMoyenHoraire
        self.coutForfaitaire = self.ficheTechnique.header.coutForfaitaire
        self.coefCoutProduction = self.ficheTechnique.header.coefCoutProduction
        self.coefPrixDeVente = self.ficheTechnique.header.coefPrixDeVente
        
        self.header = self.ficheTechnique.header
        self.progression = self.ficheTechnique.progression
        
        self.ficheTechniqueService.setObserver(obs: self)
        self.ficheTechnique.header.observer = self
    }
    
    func emit(to: Result<String, FicheTechniqueViewModelError>) {
        self.result = to
    }
    
    typealias Input = FicheTechniqueIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: FicheTechniqueIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .addFicheTechnique:
            break
        case.updateDatabase:
            break
        }
        
        return .none
    }
    
    
    func changed(nomPlat: String) {
        self.nomPlat = nomPlat
    }
    
    func changed(nomAuteur: String) {
        self.nomAuteur = nomAuteur
    }
    
    func changed(nbrCouvert: Int) {
        self.couvert = nbrCouvert
    }
    
    func changed(isCalculCharge: Bool) {
        self.isCalculCharge = isCalculCharge
    }
    
    func changed(coutMatiere: Double) {
        self.coutMatiere = coutMatiere
    }
    
    func changed(dureeTotal: Double) {
        self.dureeTotal = dureeTotal
    }
    
    func changed(coutMoyenHoraire: Double) {
        self.coutMoyenHoraire = coutMoyenHoraire
    }
    
    func changed(coutForfaitaire: Double) {
        self.coutForfaitaire = coutForfaitaire
    }
    
    func changed(coefCoutProduction: Double) {
        self.coefCoutProduction = coefCoutProduction
    }
    
    func changed(coefPrixDeVente: Double) {
        self.coefPrixDeVente = coefPrixDeVente
    }
    
    func changed(categorie: String) {
        self.categorie = categorie
    }
    
    
    
}
