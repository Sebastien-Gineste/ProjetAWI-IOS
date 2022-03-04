//
//  EtapeDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct EtapeDetailView : View{
    @Environment(\.editMode) var editMode
    
    @ObservedObject var etapeVM : EtapeViewModel
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State var isUpdate : Bool = false
    
    var intent : FicheTechniqueIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let formatter : NumberFormatter = {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       formatter.decimalSeparator = ","
       return formatter
    }()
    
    init(vm : FicheTechniqueViewModel, indice : Int, intent : FicheTechniqueIntent, indiceSousFicheTechnique : Int? = nil){
        self.intent = intent
        self.etapeVM = EtapeViewModel(ficheTechViewModel: vm, indice: indice,indiceSousFiche: indiceSousFicheTechnique)
        self.intent.addObserver(self.etapeVM)
    }
    
    var body: some View{
        VStack{
            Form {
                Section(header : Text("Description")){
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom de l'étape :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom", text : $etapeVM.nomEtape).onSubmit {
                                intent.intentToChange(nomPlat: etapeVM.nomEtape)
                            }.disabled(!isUpdate)
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Temps préparation :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom",value: $etapeVM.dureeEtape,formatter:formatter).onSubmit {
                                intent.intentToChange(dureeEtape: etapeVM.dureeEtape)
                            }.disabled(!isUpdate)
                        }
                    }
                    VStack{
                        Text("Description : ")
                        TextEditor(text: $etapeVM.descriptionEtape)
                            .foregroundColor(.white)
                            .disabled(!isUpdate)
                            .frame(minHeight:100)
                    }
                }
            
                Section(header:HStack {
                        Text("Liste des denrées")
                        Spacer()
                        if isUpdate {
                            Button {
                                editMode?.wrappedValue.toggle()
                            } label : {
                                editMode?.wrappedValue.isActive() ?? false ?  Label("Terminer", systemImage: "pencil.slash") : Label("Modifier", systemImage: "pencil")
                            }.padding(.trailing, 8)
                            
                           /* NavigationLink(destination:ChoixAjoutEtapeView(vm: ficheListVM, intent: intent)){
                                Label("Ajouter", systemImage: "plus.circle.fill")
                            }.padding(.trailing, 8)*/
                            
                        }
                    }
                ){
                    List {
                        ForEach(Array(self.etapeVM.contenu.enumerated()), id: \.offset) {
                            index, denree in
                            VStack(alignment: .leading){
                                Text("\(denree.ingredient.nomIngredient)")
                                HStack{
                                    TextField("Nombre ",value: $etapeVM.contenu[index].nombre,formatter:formatter).onSubmit {
                                        intent.intentToChange(id: index, denreeNumber: etapeVM.contenu[index].nombre )
                                    }.disabled(!isUpdate)
                                    Text(" \(denree.ingredient.unite)")
                                }
                               
                            }
                        }
                        .onDelete{ indexSet in
                            for index in indexSet {
                                print("\(index)")
                                if isUpdate {
                                    intent.intentToRemoveDenree(id: index)
                                }
                              
                            }
                        }
                    }
                }
                
            }.onChange(of: etapeVM.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = "\(msg)"
                    self.showingAlert.toggle()
                case let .failure(error):
                    switch error {
                    case .inputError, .addDenreeError :
                        print("error : \(error)")
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }.alert(Text(alertMessage), isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    etapeVM.result = .failure(.noError)
                    self.showingAlert = false
                }
            }

                HStack{
                    Button("Enregistrer"){
                        intent.intentToChange(descriptionEtape: etapeVM.descriptionEtape)
                    }.padding(20)
    
                    Button("\(isUpdate ? "Terminer" : "Modifier")"){
                        self.isUpdate = !self.isUpdate
                        editMode?.wrappedValue.setFalse()
                    }.padding(20)
                    
                }.padding(20)
        }
    }
    
}
