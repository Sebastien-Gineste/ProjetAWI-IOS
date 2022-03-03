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
    private var ficheTechniqueService : FicheTechniqueService
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
    
    init(ficheService : FicheTechniqueService, ficheTechniqueListViewModel : FicheTechniqueListViewModel? = nil, indice : Int? = nil) {
        if let indice = indice , let ficheTechniqueListViewModel = ficheTechniqueListViewModel{
            self.ficheTechnique = ficheTechniqueListViewModel.tabFicheTechnique[indice]
        } else {
            self.ficheTechnique = FicheTechnique(header: HeaderFT(nomPlat: "Fiche technique", nomAuteur: "", nbrCouvert: 1), progression: [])
        }
        
        self.ficheTechniqueService = ficheService
        
        self.nomPlat = self.ficheTechnique.header.nomPlat
        self.categorie = self.ficheTechnique.header.categorie
        self.nomAuteur = self.ficheTechnique.header.nomAuteur
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
        
        self.ficheTechnique.header.observer = self
    }
    
    func setObserverService(){
        self.ficheTechniqueService.setObserver(obs: self)
    }
    
    func removeObserverService(){
        self.ficheTechniqueService.removeObserver(obs: self)
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
            // if is valid
            self.ficheTechniqueService.addFicheTechnique(fiche: self.ficheTechnique)
        
            break
        case .deleteFicheTechnique:
            //
            self.ficheTechniqueService.removeFicheTechnique(id: self.ficheTechnique.header.id)
            
            break
        case .updateFicheTechnique:
            // if is valid
            self.ficheTechniqueService.updateFicheTechnique(fiche: self.ficheTechnique)
            
            break
        case .changingNomAuteur(let nom):
            self.ficheTechnique.header.nomAuteur = nom
            if self.ficheTechnique.header.nomAuteur != nom {
                self.nomAuteur = self.ficheTechnique.header.nomAuteur
                self.result = .failure(.inputError)
            }
        case .changingNomPlat(let nom):
                self.ficheTechnique.header.nomPlat = nom
                if self.ficheTechnique.header.nomPlat != nom {
                    self.nomPlat = self.ficheTechnique.header.nomPlat
                    self.result = .failure(.inputError)
                }
        case .changingCategorie(let nomCate):
            self.ficheTechnique.header.categorie = nomCate
            if self.ficheTechnique.header.categorie != nomCate {
                self.categorie = self.ficheTechnique.header.categorie
                self.result = .failure(.inputError)
            }
        case .changingNbrCouvert(let nbr):
            self.ficheTechnique.header.nbrCouvert = nbr
            if self.ficheTechnique.header.nbrCouvert != nbr {
                self.couvert = self.ficheTechnique.header.nbrCouvert
                self.result = .failure(.inputError)
            }
            
        // gestion etape
        case .addEtape:
            let count = self.ficheTechnique.progression.count
            self.ficheTechnique.progression.append(EtapeFiche(etapes: [Etape()]))
            if count < self.ficheTechnique.progression.count {
                self.progression.append(self.ficheTechnique.progression[count])
            }
            else{
                self.result = .failure(.inputError)
            }
        
        
        case .addSousFicheTechnique(let idFiche):
            if let fiche : FicheTechnique = self.ficheTechniqueService.getFicheTechnique(id: idFiche){
                let count = self.ficheTechnique.progression.count
                self.ficheTechnique.progression.append(EtapeFiche(etapes: fiche.progression.map{(etapeFiche : EtapeFiche) -> Etape in
                    return etapeFiche.etapes[0] // que la première case car elle ne contient pas de sous fiche technique
                }, nomSousFicheTechnique: fiche.header.nomPlat))
                if count < self.ficheTechnique.progression.count {
                    self.progression.append(self.ficheTechnique.progression[count])
                    self.ficheTechnique.calculDenreeEtCoutMatiere()
                }
                else{
                    self.result = .failure(.inputError)
                }
            }
            else{
                self.result = .failure(.inputError)
            }
            
        case .deleteEtape(let id):
            let count = self.ficheTechnique.progression.count
            self.ficheTechnique.progression.remove(at: id)
            if count > self.ficheTechnique.progression.count {
                self.progression.remove(at: id)
                self.ficheTechnique.calculDenreeEtCoutMatiere()
            }
            else{
                self.result = .failure(.inputError)
            }
        
        case .moveEtape(let from, let to):
            self.ficheTechnique.progression.move(fromOffsets: from, toOffset: to)
            self.progression.move(fromOffsets: from, toOffset: to)
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
