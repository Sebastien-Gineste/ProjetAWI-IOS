//
//  Store.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

protocol StoreObserver {
    func changed(coefCoûtProduction : Double)
    func changed(coefPrixDeVente : Double)
    func changed(coûtForfaitaire : Double)
    func changed(coûtMoyen : Double)
}

struct Store {
    var id : String = "store"
    var coefCoûtProduction : Double
    var coefPrixDeVente : Double
    var coûtForfaitaire : Double
    var coûtMoyen : Double
    var observer : StoreObserver?
    init(coefCoûtProduction : Double, coefPrixDeVente: Double, coûtForfaitaire : Double, coûtMoyen: Double){
        self.coefCoûtProduction = coefCoûtProduction
        self.coefPrixDeVente = coefPrixDeVente
        self.coûtForfaitaire = coûtForfaitaire
        self.coûtMoyen = coûtMoyen
    }
}
