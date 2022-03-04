//
//  PrintEtiquetteView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct PrintEtiquetteView : View {

    @ObservedObject var etiquette : EtiquetteViewModel
    @State var isChecked:Bool = false
    @State var idEtiquette : String = ""
    let columnsFlexible : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    var intent : EtiquetteIntent

    func toggle(){isChecked = !isChecked}
    
    init(){
        self.etiquette = EtiquetteViewModel()
        self.intent = EtiquetteIntent()
        self.intent.addObserver(etiquette)
    }
    
    var body: some View {
        VStack {
            Form {
                Button(action: toggle){
                    HStack{
                        LazyVGrid(columns: columnsFlexible, alignment: .leading){
                            Image(systemName: isChecked ? "checkmark.square": "square")
                            Text("Est-ce une vente ?")
                        }
                    }
                }
                HStack {
                    
                    LazyVGrid(columns: columns, alignment: .leading){
                        Text("Nombre d'étiquette : ")
                        TextField("Nombre", value : $etiquette.nombreEtiquete, formatter: formatter)
                            .onSubmit {
                                print("je passe")
                                intent.intentToChange(nombreEtiquete: etiquette.nombreEtiquete)
                            }
                    }
                }
            }
            Spacer()
            Button("Imprimer"){
                createEtiquette()
            }.padding(20)
        }.padding()
            .navigationBarTitle(Text("Impression Etiquette"), displayMode: .inline)
    }
    
    func createEtiquette(){
        if isChecked {
            makeVente()
        } else {
            var html = ""
            var headHTML = ""
            if let fileURL = Bundle.main.url(forResource: "head-etiquette", withExtension: "html") {
                if let fileContents = try? String(contentsOf: fileURL) {
                    headHTML = fileContents
                }
            }
            var denreeHTML = ""
            if let fileURL = Bundle.main.url(forResource: "denree", withExtension: "html") {
                if let fileContents = try? String(contentsOf: fileURL) {
                    denreeHTML = fileContents
                }
            }
            var footerHTML = ""
            if let fileURL = Bundle.main.url(forResource: "footer-etiquette", withExtension: "html") {
                if let fileContents = try? String(contentsOf: fileURL) {
                    footerHTML = fileContents
                }
            }
            for _ in 0..<self.etiquette.nombreEtiquete{
                html += headHTML
                // TO DO : Iterate étape
                for _ in 0...12 {
                    html += denreeHTML
                }
                html += footerHTML
            }
            PDF.createPDF(nom : "etiquette", html: html){ link in
                let url = URL(string: link)
                        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
            }
        }
    }
    
    func makeVente(){
        // TO DO : Vente
        print("c'est une vente")
    }
    
}
