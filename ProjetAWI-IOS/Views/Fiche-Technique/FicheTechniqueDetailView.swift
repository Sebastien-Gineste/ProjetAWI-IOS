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
    @State var isEditMode : Bool = false
    
    var intent : FicheTechniqueIntent
    var ficheListVM : FicheTechniqueListViewModel
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
        
    init(vm : FicheTechniqueListViewModel, indice : Int? = nil, vmCategorie : CategorieRecetteViewModel, ficheService : FicheTechniqueService){
        
        self.ficheListVM = vm
        
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
                    Section(header :Text("Informations générales") ){
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
                                    editMode?.wrappedValue.toggle()
                                } label : {
                                    editMode?.wrappedValue.isActive() ?? false ?  Label("Terminer", systemImage: "pencil.slash") : Label("Modifier", systemImage: "pencil")
                                }.padding(.trailing, 8)
                                
                                NavigationLink(destination:ChoixAjoutEtapeView(vm: ficheListVM, intent: intent)){
                                    Label("Ajouter", systemImage: "plus.circle.fill")
                                }.padding(.trailing, 8)
                                
                            }
                        }
                    ){
                        List {
                            ForEach(Array(self.ficheTechniqueVM.progression.enumerated()), id: \.offset) { index, etapeFiche in
                                HStack {
                                    if etapeFiche.estSousFicheTechnique {
                                        NavigationLink(destination : EtapeFicheView(vm: ficheTechniqueVM, intent: intent, indice: index)){
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName:"\(index+1).circle")
                                                    Image(systemName:"f.circle")
                                                }
                                                Text("\(etapeFiche.nomSousFicheTechnique!)")
                                            }
                                        }
                                    }
                                    else {
                                        NavigationLink(destination : EtapeDetailView(vm: ficheTechniqueVM, indice: index, intent: intent)){
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName:"\(index+1).circle")
                                                    Image(systemName:"e.circle")
                                                }
                                                Text("\(etapeFiche.etapes[0].description.nom)")
                                            }
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
                        }
                    }
                    
                    Section(header : Text("Gestion")){
                        NavigationLink(destination:MaterielView(vm : ficheTechniqueVM, intent : intent)){
                            Text("Gestion des matériels")
                        }
                        NavigationLink(destination:GestionCoutView(vm : ficheTechniqueVM, intent : intent)){
                            Text("Gestion des coûts")
                        }
                        NavigationLink(destination:DenreesView(vm : ficheTechniqueVM)){
                            Text("Liste des denrées")
                        }
                    }
                    
                    Section(header : Text("Options")){
                        NavigationLink(destination:PrintFicheView()){
                            Text("Imprimer Fiche")
                        }
                        NavigationLink(destination:PrintEtiquetteView()){
                            Text("Imprimer Etiquette")
                        }
                        NavigationLink(destination:VenteView()){
                            Text("Vendre")
                        }
                        
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
                    case .updateError, .createError, .inputError, .addEtapeError :
                        print("error : \(error)")
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
                    
                    Button("Enregistrer"){
                        intent.intentToUpdateFicheTechnique()
                    }.padding(20)
                    
                    Button("\(isUpdate ? "Terminer" : "Modifier")"){
                        self.isUpdate = !self.isUpdate
                        editMode?.wrappedValue.setFalse()
                    }.padding(20)
                    
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
    
    func isActive() -> Bool{
        return self == .active
    }
    
    mutating func setFalse() {
        self = .inactive
    }
}

