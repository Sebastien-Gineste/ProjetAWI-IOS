//
//  PrintFicheView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct PrintFicheView : View {

    @State var isChecked:Bool = false
    var fiche : FicheTechniqueViewModel
    func toggle(){isChecked = !isChecked}
    
    init(fiche : FicheTechniqueViewModel){
        self.fiche = fiche
    }
    
    var body: some View {
        VStack {
            Form {
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.square": "square")
                        Spacer()
                        Text("Imprimer avec les coûts ?")
                    }
                }
            }

            Spacer()
            Button("Imprimer"){
                createFichePDF()
            }.padding(20)
        }.padding()
            .navigationBarTitle(Text("Impression Fiche"), displayMode: .inline)
    }
    
    func createFichePDF(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
            
        var html = ""
        if let fileURL = Bundle.main.url(forResource: "head-fiche", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let dateHTML = fileContents.replacingOccurrences(of: "{{date}}", with: dateFormatter.string(from: date))
                let nomPlatHTML = dateHTML.replacingOccurrences(of: "{{nomPlat}}", with: self.fiche.nomPlat)
                let nomAuteurHTML = nomPlatHTML.replacingOccurrences(of: "{{nomAuteur}}", with: self.fiche.nomAuteur)
                html = nomAuteurHTML.replacingOccurrences(of: "{{nbrCouvert}}", with: "\(self.fiche.couvert)")
            }
        }
        var etapeHTML = ""
        if let fileURL = Bundle.main.url(forResource: "etape", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                etapeHTML = fileContents
            }
        }
        // TO DO : Itérate Etape
        for _ in 0...2 {
            html += etapeHTML
        }
        var materielHTML = ""
        if let fileURL = Bundle.main.url(forResource: "materiel", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let dressageHTML = fileContents.replacingOccurrences(of: "{{dressage}}", with: self.fiche.materielDressage.count == 0 ? "Aucun" :  self.fiche.materielDressage)
                materielHTML = dressageHTML.replacingOccurrences(of: "{{spécifiques}}", with: self.fiche.materielSpecifique.count == 0 ? "Aucun" : self.fiche.materielSpecifique)
            }
        }
        html += materielHTML
        if isChecked {
            if let fileURL = Bundle.main.url(forResource: "couts", withExtension: "html") {
                if let fileContents = try? String(contentsOf: fileURL) {
                    let beneficeParPortionHTML = fileContents.replacingOccurrences(of: "{{beneficeParPortion)}", with: self.fiche.beneficePortion.formatComa())
                    let beneficeTotalHTML = beneficeParPortionHTML.replacingOccurrences(of: "{{beneficeTotal}}", with: "fdd")
                    let coefCoutProductionHTML = beneficeTotalHTML.replacingOccurrences(of: "{{coefCoutProduction}}", with: self.fiche.coefCoutProduction.formatComa())
                    let coefPrixDeVenteHTML = coefCoutProductionHTML.replacingOccurrences(of: "{{coefPrixDeVente}}", with: self.fiche.coefPrixDeVente.formatComa())
                    let coutFluideHTML = coefPrixDeVenteHTML.replacingOccurrences(of: "{{coutFluide}}", with: self.fiche.coutFluide.formatComa())
                    let coutMatiereHTML = coutFluideHTML.replacingOccurrences(of: "{{coutMatiere}}", with: self.fiche.coutMatiere.formatComa())
                    let coutMatiereTotalHTML = coutMatiereHTML.replacingOccurrences(of: "{{coutMatiereTotal}}", with: self.fiche.coutMatiereTotal.formatComa())
                    let coutMoyenHorraireHTML = coutMatiereTotalHTML.replacingOccurrences(of: "{{coutMoyenHorraire}}", with: self.fiche.coutMoyenHoraire.formatComa())
                    let coutPersonnelHTML = coutMoyenHorraireHTML.replacingOccurrences(of: "{{coutPersonnel}}", with: self.fiche.coutPersonnel.formatComa())
                    let coutProductionHTML = coutPersonnelHTML.replacingOccurrences(of: "{{coutProduction}}", with: self.fiche.coutProductionTotal.formatComa())
                    let coutProductionPortionHTML = coutProductionHTML.replacingOccurrences(of: "{{coutProductionPortion}}", with: self.fiche.coutProductionPortion.formatComa())
                    let prixDeVentePortionHTHTML = coutProductionPortionHTML.replacingOccurrences(of: "{{prixDeVentePortionHT}}", with: self.fiche.prixDeVentePortion.formatComa())
                    let prixDeVenteTotalHTHTML = prixDeVentePortionHTHTML.replacingOccurrences(of: "{{prixDeVenteTotalHT}}", with: self.fiche.prixDeVente.formatComa())
                    let prixDeVentePortionTTCHTML = prixDeVenteTotalHTHTML.replacingOccurrences(of: "{{prixDeVentePortionTTC}}", with: (self.fiche.prixDeVentePortion * 0.2).formatComa())
                    let prixDeVenteTotalTTCHTML = prixDeVentePortionTTCHTML.replacingOccurrences(of: "{{prixDeVenteTotalTTC}}", with: (self.fiche.prixDeVente * 0.2).formatComa())
                    let seuilRentabiliteHTML = prixDeVenteTotalTTCHTML.replacingOccurrences(of: "{{seuilRentabilite}}", with: "\(self.fiche.seuilRentabilité)")
                    let dureeTotalHTML = seuilRentabiliteHTML.replacingOccurrences(of: "{{dureeTotal}}", with: self.fiche.dureeTotal.formatComa())
                    html += dureeTotalHTML
                    
                }
            }
        }
        PDF.createPDF(nom: "Fiche_technique", html: html){ link in
            let url = URL(string: link)
                    let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        }
    }
    
}
