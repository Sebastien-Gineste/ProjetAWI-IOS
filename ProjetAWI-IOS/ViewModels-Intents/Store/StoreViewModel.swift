//
//  StoreViewModel.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import Foundation
import SwiftUI
import Combine

class StoreViewModel : ObservableObject, StoreObserver, Subscriber {
    
    private var store : Store
    @Published var coefCoûtProduction : Double
    @Published var coefPrixDeVente : Double
    @Published var coûtForfaitaire : Double
    @Published var coûtMoyen : Double
    
    init(store : Store){
        self.store = store
        self.coefCoûtProduction = store.coefCoûtProduction
        self.coefPrixDeVente = store.coefPrixDeVente
        self.coûtForfaitaire = store.coûtForfaitaire
        self.coûtMoyen = store.coûtMoyen
        self.store.observer = self
    }
    
    func changed(coefCoûtProduction: Double) {
        self.coefCoûtProduction = coefCoûtProduction
    }
    
    func changed(coefPrixDeVente: Double) {
        self.coefPrixDeVente = coefPrixDeVente
    }
    
    func changed(coûtForfaitaire: Double) {
        self.coûtForfaitaire = coûtForfaitaire
    }
    
    func changed(coûtMoyen: Double) {
        self.coûtMoyen = coûtMoyen
    }
    
    typealias Input = StoreIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
}
