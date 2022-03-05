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
    @State var idEtiquette : String = "Sans vente"
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    let columnsFlexible : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    var intent : EtiquetteIntent

    func toggle(){isChecked = !isChecked}
    
    init(){
        self.etiquette = EtiquetteViewModel(idficheReference: "test", nomPlat: "test", listDenree: [])
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
                                intent.intentToChange(nombreEtiquete: etiquette.nombreEtiquete)
                            }
                    }
                }
            }.onChange(of: etiquette.result){
                result in
                switch result {
                case .success(_):
                    self.idEtiquette = self.etiquette.idEtiquette
                    self.isChecked = false
                    createEtiquette()
                case let .failure(error):
                    switch error {
                    case .createError, .inputError :
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }.alert(Text(alertMessage), isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    etiquette.result = .failure(.noError)
                    self.showingAlert = false
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
                    headHTML = fileContents.replacingOccurrences(of: "{{idEtiquette}}", with: self.idEtiquette)
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
            self.idEtiquette = "Sans vente"
            self.etiquette.nombreEtiquete = 1
            self.intent.intentToChange(nombreEtiquete: self.etiquette.nombreEtiquete)
            self.etiquette.result = .failure(.noError)
        }
    }
    
    func makeVente(){
        intent.intentToAddEtiquette()
    }
    
}
