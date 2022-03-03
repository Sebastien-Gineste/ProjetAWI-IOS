//
//  PreferenceView.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import SwiftUI


struct PreferenceView : View {
    @Environment(\.openURL) var openURL

    @ObservedObject var storeModel : StoreViewModel = StoreViewModel()
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    var intent: StoreIntent

    init(vm : StoreViewModel){
        self.storeModel = vm
        self.intent = StoreIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView {
            VStack {
                Form{
                    Section {
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût de Production :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $storeModel.coefCoûtProduction, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coefCoûtProduction: storeModel.coefCoûtProduction)
                                    }
                            }
                        }
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Prix de Vente :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $storeModel.coefPrixDeVente, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coefPrixDeVente: storeModel.coefPrixDeVente)
                                    }
                            }
                        }
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût Forfaitaire :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $storeModel.coûtForfaitaire, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coûtForfaitaire: storeModel.coûtForfaitaire)
                                    }
                            }
                        }
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût Moyen :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $storeModel.coûtMoyen, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coûtMoyen: storeModel.coûtMoyen)
                                    }
                            }
                        }
                    }
                }
                    .onChange(of: storeModel.result){
                        result in
                        switch result {
                        case let .success(msg):
                            self.alertMessage = msg
                            self.showingAlert = true
                        case let .failure(error):
                            switch error {
                            case .updateError :
                                self.alertMessage = "\(error)"
                                self.showingAlert = true
                            case .noError :
                                return
                            }
                        }
                    }
                    .alert("\(alertMessage)", isPresented: $showingAlert){
                        Button("OK", role: .cancel){
                            storeModel.result = .failure(.noError)
                        }
                    }
                Spacer()
                Button("Modifier"){
                    //intent.intentToUpdateDatabase()
                    createEtiquette()
                }.padding(20)
            }
            .navigationBarTitle(Text("Préférences de calculs"),displayMode: .inline)
        }
    }
    
    func createFichePDF(){
        var html = ""
        if let fileURL = Bundle.main.url(forResource: "head-fiche", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                html = fileContents
            }
        }
        
        var etapeHTML = ""
        if let fileURL = Bundle.main.url(forResource: "etape", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                etapeHTML = fileContents
            }
        }
        
        for i in 0...12 {
            html += etapeHTML
        }
        
        
        var materielHTML = ""
        if let fileURL = Bundle.main.url(forResource: "materiel", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                materielHTML = fileContents
            }
        }
        
        html += materielHTML
        PDF.createPDF(html: html){ link in
            let url = URL(string: link)
                    let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        }
    }
    
    func createEtiquette(){
        var html = ""
        if let fileURL = Bundle.main.url(forResource: "head-etiquette", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                html = fileContents
            }
        }
        
        var denreeHTML = ""
        if let fileURL = Bundle.main.url(forResource: "denree", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                denreeHTML = fileContents
            }
        }
        
        for i in 0...12 {
            html += denreeHTML
        }
        
        
        var footerHTML = ""
        if let fileURL = Bundle.main.url(forResource: "footer-etiquette", withExtension: "html") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                footerHTML = fileContents
            }
        }
        
        html += footerHTML
        PDF.createPDF(html: html){ link in
            let url = URL(string: link)
                    let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        }
    }
}
