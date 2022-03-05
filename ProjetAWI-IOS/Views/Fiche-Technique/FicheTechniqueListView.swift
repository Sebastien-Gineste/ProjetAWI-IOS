//
//  MainView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct FicheTechniqueListView: View {
    @ObservedObject var ficheTechniqueListViewModel : FicheTechniqueListViewModel
    @ObservedObject var categorieRecetteViewModel : CategorieRecetteViewModel
    @ObservedObject var ingredientLVM : IngredientListViewModel
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedIndex : Int = 0
    @State var listIngredient : [String] = []
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var intent: FicheTechniqueIntent
    
    var ficheTechniqueFiltre : [FicheTechnique] {
        var tabFiche : [FicheTechnique] = self.ficheTechniqueListViewModel.tabFicheTechnique
        
        if !searchText.isEmpty {
                tabFiche = tabFiche.filter{ $0.header.nomPlat.uppercased().contains(searchText.uppercased())
            }
        }
        
        if selectedIndex > 0{ // erreur selection categorie : une categorie avant 
            tabFiche = tabFiche.filter{ $0.header.categorie.uppercased().contains(categorieRecetteViewModel.tabCategorieRecette[(selectedIndex - 1)].uppercased())
            }
        }
        
        if !listIngredient.isEmpty {
            tabFiche = tabFiche.filter{
                $0.contientIngrédients(tabIngrédient: listIngredient)
            }
        }
        
        return tabFiche
    }
    
    init(vm : FicheTechniqueListViewModel, vmIngredient : IngredientListViewModel, vmCategorie : CategorieRecetteViewModel){
        self.ficheTechniqueListViewModel = vm
        self.categorieRecetteViewModel = vmCategorie
        self.intent = FicheTechniqueIntent()
        self.intent.addObserver(vm)
        self.ingredientLVM = vmIngredient
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $selectedIndex, label: Text("Categorie")) {
                        ForEach(Array(self.categorieRecetteViewModel.tabCategorieRecette.enumerated()), id: \.offset) { index,categorie in
                            Text(categorie)
                        }
                    }
                    HStack {
                        NavigationLink(destination: MultipleSelectionIngredient(items: self.ingredientLVM.tabIngredient, selections: $listIngredient)){
                            HStack {
                                Text("Liste ingrédient :")
                                Spacer()
                                Text("Sélectionner")
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                }.frame(height:150)
                
                List {
                    ForEach(Array(ficheTechniqueFiltre.enumerated()), id : \.offset) {
                        index, fiche in
                        HStack {
                            NavigationLink(destination: FicheTechniqueDetailView(
                                vm: self.ficheTechniqueListViewModel,
                                id: fiche.header.id,
                                vmCategorie: self.categorieRecetteViewModel,
                                vmIngredient: ingredientLVM,
                                ficheService: self.ficheTechniqueListViewModel.ficheTechniqueService)){
                                VStack(alignment: .leading){
                                    Text(fiche.header.nomPlat).bold()
                                    HStack {
                                        Text(fiche.header.nomAuteur).italic()
                                        Text(" (\(fiche.header.nbrCouvert) couverts - ")
                                        Text("\(String(format: "%.2f",fiche.header.coutProduction).replaceComa())€ )")
                                    }
                                }
                            }
                        }
                    }.onDelete{
                        IndexSet in
                        for index in IndexSet {
                            intent.intentToDeleteFicheTechniqueFromList(id: index)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("Liste des fiche techniques"), displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        NavigationLink(destination: FicheTechniqueDetailView(
                            vm: self.ficheTechniqueListViewModel,
                            vmCategorie: self.categorieRecetteViewModel,
                            vmIngredient: ingredientLVM,
                            ficheService: self.ficheTechniqueListViewModel.ficheTechniqueService)){
                            Text("Créer une fiche")
                        }
                        
                    }
                }.padding()
            }
            .onChange(of: ficheTechniqueListViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .noError :
                        return
                    case .deleteError, .updateError, .addError:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    ficheTechniqueListViewModel.result = .failure(.noError)
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle()) // résoud erreur de contrainte
    }
}
