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
                    PDF.createPDF(){ link in
                        print("j'open")
                        print(link)
                        //openURL(URL(string: link)!)
                    }
                }.padding(20)
                Link("Learn SwiftUI", destination: URL(string: "file:///Users/m1/Library/Developer/CoreSimulator/Devices/F27F5C9C-CB88-4BFD-9478-EEFD393559EE/data/Containers/Data/Application/FFB56E36-A781-4B66-937A-AE5DB39FEFAE/Downloads/")!)
            }
            .navigationBarTitle(Text("Préférences de calculs"),displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle()) // résoud erreur de contrainte
    }
}
