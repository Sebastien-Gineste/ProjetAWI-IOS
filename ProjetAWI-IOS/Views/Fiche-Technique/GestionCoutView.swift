//
//  GestionCoutView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct GestionCoutView : View {

    @ObservedObject var ficheVM : FicheTechniqueViewModel
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    var intent: FicheTechniqueIntent
    
    init(vm : FicheTechniqueViewModel, intent : FicheTechniqueIntent){
        self.ficheVM = vm
        self.intent = intent
    }
    
    var body: some View {
        VStack {
            Form{
                Section(header: Text("Gestions des coûts")){
                    HStack {
                        LazyVGrid(columns: columns){
                            Text("Coefficient Coût de Production :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ficheVM.coefCoutProduction, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(coefProd: ficheVM.coefCoutProduction)
                                    // corrige bug input error view précédente
                                }
                        }
                    }
                    HStack {
                        LazyVGrid(columns: columns){
                            Text("Coefficient Prix de Vente :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ficheVM.coefPrixDeVente, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(coefVente: ficheVM.coefPrixDeVente)
                                }
                        }
                    }
                    HStack {
                        LazyVGrid(columns: columns){
                            Text("Coefficient Coût Forfaitaire :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ficheVM.coutForfaitaire, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(coutForfaitaire: ficheVM.coutForfaitaire)
                                }
                        }
                    }
                    HStack {
                        LazyVGrid(columns: columns){
                            Text("Coefficient Coût Moyen :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ficheVM.coutMoyenHoraire, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(coutMoyenHoraire: ficheVM.coutMoyenHoraire)
                                }
                        }
                    }
                }
            }
            
            // List recap coût
            
        }
        
    }
    
}
