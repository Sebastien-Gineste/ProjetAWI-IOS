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
        var html = ""
        if let fileURL = Bundle.main.url(forResource: "head-fiche", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                html = fileContents
            }
        }
        var etapeHTML = ""
        if let fileURL = Bundle.main.url(forResource: "etape", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                etapeHTML = fileContents
            }
        }
        // TO DO : Itérate Etape
        for i in 0...12 {
            html += etapeHTML
        }
        var materielHTML = ""
        if let fileURL = Bundle.main.url(forResource: "materiel", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                materielHTML = fileContents
            }
        }
        html += materielHTML
        if isChecked {
            if let fileURL = Bundle.main.url(forResource: "couts", withExtension: "html") {
                if let fileContents = try? String(contentsOf: fileURL) {
                    html += fileContents
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
