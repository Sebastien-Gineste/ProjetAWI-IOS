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
    @ObservedObject var vmIngredient : IngredientListViewModel
    
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
        
    init(vm : FicheTechniqueListViewModel, id : String? = nil, vmCategorie : CategorieRecetteViewModel, vmIngredient : IngredientListViewModel, ficheService : FicheTechniqueService){
        
        
        self.ficheListVM = vm
        let index : Int?
        
        if id != nil {
            index = self.ficheListVM.tabFicheTechnique.firstIndex{$0.header.id == id}
        }
        else{
            index = nil
        }
        
        self.vmIngredient = vmIngredient
        
        self.intent = FicheTechniqueIntent()
     
        self.ficheTechniqueVM = FicheTechniqueViewModel(
            ficheService: ficheService,
            ficheTechniqueListViewModel: vm,
            indice: index)
        
        self.categorieRecetteVM = vmCategorie
        
        self._isCreate = State(initialValue: id == nil)

        
        if let id = id, let indexCate = vmCategorie.tabCategorieRecette.firstIndex(of:vm.tabFicheTechnique[index!].header.categorie) {
            self._selectedIndex = State(initialValue: indexCate)
        } else {
            self._selectedIndex = State(initialValue: 0)
        }
        
       
        self.intent.addObserver(self.ficheTechniqueVM)
    }
    
    func changeColor(isValid : Bool) -> Color{
        if isValid {
            return Color.green
        }
        else {
            return Color.red
        }
    }
    
    
    var body: some View {
        VStack {
            ScrollViewReader { p in
                Form {
                    Section(header :Text("Informations générales").underline(isUpdate || isCreate, color: changeColor(isValid: ficheTechniqueVM.headerValid)) ){
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Nom du plat :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("Nom", text : $ficheTechniqueVM.nomPlat).onSubmit {
                                    intent.intentToChange(nomPlat: ficheTechniqueVM.nomPlat)
                                }.textFieldStyle(.roundedBorder)
                                .disabled(!isUpdate && !isCreate)
                            }
                        }
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Responsable :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("Nom", text : $ficheTechniqueVM.nomAuteur).onSubmit {
                                    intent.intentToChange(nomAuteur: ficheTechniqueVM.nomAuteur)
                                }.disabled(!isUpdate && !isCreate).textFieldStyle(.roundedBorder)
                            }
                        }
                        HStack{
                            LazyVGrid(columns: columns){
                                Text("Nombre de couvert :").frame(maxWidth: .infinity, alignment: .leading)
                                
                                if isUpdate || isCreate {
                                    Stepper("\(ficheTechniqueVM.couvert)",
                                            onIncrement: {intent.intentToChange(nbrCouvert: ficheTechniqueVM.couvert+1)},
                                            onDecrement: {intent.intentToChange(nbrCouvert: ficheTechniqueVM.couvert-1)}).textFieldStyle(.roundedBorder)
                                }
                                else{
                                    TextField("Nom", value: $ficheTechniqueVM.couvert, formatter: formatter).disabled(!isUpdate && !isCreate).textFieldStyle(.roundedBorder)
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
                            }).disabled(!isUpdate && !isCreate).textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    Section(header:
                        HStack {
                            Text("Liste des étapes").underline(isUpdate || isCreate, color: changeColor(isValid: ficheTechniqueVM.progressionValid))
                            Spacer()
                            if isUpdate || isCreate {
                                Button {
                                    editMode?.wrappedValue.toggle()
                                } label : {
                                    editMode?.wrappedValue.isActive() ?? false ?  Label("Terminer", systemImage: "pencil.slash") : Label("Modifier", systemImage: "pencil")
                                }.padding(.trailing, 8)
                                
                                NavigationLink(destination:ChoixAjoutEtapeView(intent: intent, lvmFiche: ficheListVM)){
                                    Label("Ajouter", systemImage: "plus.circle.fill")
                                }.padding(.trailing, 8)
                                
                            }
                        }
                    ){
                        List {
                            ForEach(Array(self.ficheTechniqueVM.progression.enumerated()), id: \.offset) { index, etapeFiche in
                                HStack {
                                    if etapeFiche.estSousFicheTechnique {
                                        NavigationLink(destination : EtapeFicheView(vm: ficheTechniqueVM, vmIngredient: vmIngredient, intent: intent, indice: index)){
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
                                        NavigationLink(destination : EtapeDetailView(vm: ficheTechniqueVM,indice: index, vmIngredient: vmIngredient, isCreate: isCreate)){
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName:"\(index+1).circle")
                                                    Image(systemName:"e.circle")
                                                }
                                                Text("\(etapeFiche.etapes[0].description.nom)").underline(isUpdate || isCreate, color: changeColor(isValid: ficheTechniqueVM.isValidEtape(id: index)))
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
                    if self.isUpdate {
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
            }
            
            .onChange(of: ficheTechniqueVM.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = "\(msg)"
                    self.showingAlert.toggle()
                case let .failure(error):
                    switch error {
                    case .updateError, .createError, .inputError, .addEtapeError, .noValid, .deleteError :
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

