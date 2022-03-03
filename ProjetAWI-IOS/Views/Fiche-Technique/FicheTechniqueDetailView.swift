//
//  FicheTechniqueDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import SwiftUI

struct FicheTechniqueDetailView : View{
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.editMode) var editMode
    
    @ObservedObject var ficheTechniqueVM : FicheTechniqueViewModel
    @ObservedObject var categorieRecetteVM : CategorieRecetteViewModel
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var selectedIndex : Int
    @State var isCreate : Bool
    @State var isUpdate : Bool = false
    
    var intent : FicheTechniqueIntent
   
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    
    init(vm : FicheTechniqueListViewModel, indice : Int? = nil, vmCategorie : CategorieRecetteViewModel, ficheService : FicheTechniqueService){
        
        self.intent = FicheTechniqueIntent()
     
        self.ficheTechniqueVM = FicheTechniqueViewModel(
            ficheService: ficheService,
            ficheTechniqueListViewModel: vm,
            indice: indice)
        
        self.categorieRecetteVM = vmCategorie
        
        self._isCreate = State(initialValue: indice == nil)

        
        if let indice = indice, let index = vmCategorie.tabCategorieRecette.firstIndex(of:vm.tabFicheTechnique[indice].header.categorie) {
            self._selectedIndex = State(initialValue: index)
        } else {
            self._selectedIndex = State(initialValue: 0)
        }
        
       
        self.intent.addObserver(self.ficheTechniqueVM)
    }
    
    
    var body: some View {
        VStack {
            ScrollViewReader { p in
                Form {
                    Section(header : Text("Informations générales")){
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Nom du plat :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("Nom", text : $ficheTechniqueVM.nomPlat).onSubmit {
                                    intent.intentToChange(nomPlat: ficheTechniqueVM.nomPlat)
                                }.disabled(!isUpdate)
                            }
                        }
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Responsable :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("Nom", text : $ficheTechniqueVM.nomAuteur).onSubmit {
                                    intent.intentToChange(nomAuteur: ficheTechniqueVM.nomPlat)
                                }.disabled(!isUpdate)
                            }
                        }
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Nombre de couvert :").frame(maxWidth: .infinity, alignment: .leading)
                                
                                if isUpdate {
                                    Stepper("\(ficheTechniqueVM.couvert)",
                                            onIncrement: {intent.intentToChange(nbrCouvert: ficheTechniqueVM.couvert+1)},
                                            onDecrement: {intent.intentToChange(nbrCouvert: ficheTechniqueVM.couvert-1)})
                                }
                                else{
                                    TextField("Nom", value: $ficheTechniqueVM.couvert, formatter: formatter).disabled(!isUpdate)
                                }
                            }
                        }
                        HStack{
                            Picker(selection: $selectedIndex, label: Text("Categorie")) {
                                ForEach(Array(self.categorieRecetteVM.tabCategorieRecette.enumerated()), id: \.offset) { index,categorie in
                                    Text(categorie)
                                }
                            }.onChange(of: selectedIndex, perform: {
                                value in
                                self.intent.intentToChange(categorie: self.categorieRecetteVM.tabCategorieRecette[value])
                            }).disabled(!isUpdate)
                        }
                    }
                    
                    Section(header:
                        HStack {
                            Text("Liste des étapes")
                            Spacer()
                            if isUpdate {
                                Button {
                                    intent.intentToAddEtape()
                                } label: {
                                    Label("Ajouter", systemImage: "plus.circle.fill")
                                }.padding(.trailing, 8)
                            }
                        }
                    ){
                        List {
                            ForEach(Array(ficheTechniqueVM.progression.enumerated()), id: \.offset) { index, etapeFiche in
                                HStack {
                                    // navigationLink
                                    VStack(alignment: .leading){
                                        HStack{
                                            Image(systemName:"\(index+1).circle")
                                            if etapeFiche.estSousFicheTechnique {
                                                Image(systemName:"f.circle")
                                            }
                                            else{
                                                Image(systemName:"e.circle")
                                            }
                                        }
                                        if etapeFiche.estSousFicheTechnique {
                                            Text("\(etapeFiche.nomSousFicheTechnique!)")
                                        }
                                        else{
                                            Text("\(etapeFiche.etapes[0].description.nom)")
                                        }
                                    }
                                }
                            }
                            .onDelete{ indexSet in
                                for index in indexSet {
                                    print("\(index)")
                                    if isUpdate {
                                        intent.intentToRemoveEtape(id: index)
                                    }
                                  
                                }
                            }
                            .onMove {
                                intent.intentToMoveEtape(from: $0, to: $1)
                            }
                        }.disabled(!isUpdate)
                    }
                    
                    Section(header : Text("Materiel")){
                        // navigationLink materiel
                        Text("Materiels")
                    }
                    
                    Section(header : Text("Liste des denrées")){
                        // navigationLink materiel
                        Text("List des denrées")
                    }
                    
                    Section(header: Text("Liste des coûts")){
                        // navigationLink materiel
                        Text("Gestion des coûts")
                    }
                }
            }
            
            .onChange(of: ficheTechniqueVM.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = "\(msg)"
                    self.showingAlert.toggle()
                case let .failure(error):
                    switch error {
                    case .updateError, .createError, .inputError :
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }.alert(Text(alertMessage), isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    ficheTechniqueVM.result = .failure(.noError)
                    self.showingAlert = false
                }
            }
            
            if isCreate {
                Button("Enregistrer"){
                    intent.intentToAddFicheTechnique()
                    self.presentationMode.wrappedValue.dismiss()
                }.padding(20)
            }
            else{
                HStack{
                    Button("\(isUpdate ? "Valider" : "Modifier")"){
                        if isUpdate {
                            intent.intentToUpdateFicheTechnique()
                        }
                        self.isUpdate = !self.isUpdate
                        editMode?.wrappedValue.toggle()
                    
                    }.padding(20)
                    
                    if isUpdate {
                        Button("Annuler"){
                            self.isUpdate = !self.isUpdate
                            editMode?.wrappedValue.toggle()
                        }
                    }
                    
                    Button("Supprimer"){
                        intent.intentToDeleteFicheTechniqueFromDetail()
                        self.presentationMode.wrappedValue.dismiss()
                    }.padding(20)
                }.padding(20)
            }
            
            
        }.onAppear(){
            self.ficheTechniqueVM.setObserverService()
        }.navigationBarTitle(Text("\(isCreate ? "Création d'une fiche technique" : "Détails de la fiche technique")"),displayMode: .inline)
    }
    
    
}

extension EditMode {

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

