//
//  IngredientListView.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import SwiftUI


struct IngredientListView : View {
    
    @ObservedObject var ingredientListViewModel : IngredientListViewModel
    @ObservedObject var categorieIngredientViewModel : CategorieIngredientViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedIndex : Int = 0
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var intent: IngredientIntent
    var ingredientsFiltre: [Ingredient] {
        if searchText.isEmpty &&  selectedIndex <= 0 {
            return ingredientListViewModel.tabIngredient
        } else {
            if selectedIndex <= 0 {
                return ingredientListViewModel.tabIngredient.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) }
            } else if searchText.isEmpty {
                return ingredientListViewModel.tabIngredient.filter{ $0.categorie.uppercased().contains(categorieIngredientViewModel.tabCategorieIngredient[selectedIndex].uppercased()) }
            } else {
                return ingredientListViewModel.tabIngredient.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) && $0.categorie.uppercased().contains(categorieIngredientViewModel.tabCategorieIngredient[selectedIndex].uppercased()) }
            }
        }
    }
    
    init(vm : IngredientListViewModel, vmCategorie : CategorieIngredientViewModel){
        self.ingredientListViewModel = vm
        self.intent = IngredientIntent()
        self.intent.addObserver(vm)
        self.categorieIngredientViewModel = vmCategorie
    }
    
    var body : some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $selectedIndex, label: Text("Categorie")) {
                        ForEach(0 ..< categorieIngredientViewModel.tabCategorieIngredient.count) {
                            Text(self.categorieIngredientViewModel.tabCategorieIngredient[$0])
                        }
                  }
                }.frame(height: 100)
                List {
                    ForEach(Array(ingredientsFiltre.enumerated()), id: \.offset) {
                        index, ingredient in
                            HStack{
                                NavigationLink(destination: IngredientDetailView(vm: self.ingredientListViewModel, indice: index, vmCategorie: self.categorieIngredientViewModel)){
                                    VStack(alignment: .leading) {
                                        Text(ingredient.nomIngredient).bold()
                                        HStack {
                                            Text(String(format: "%.2f",ingredient.qteIngredient).replaceComa() + " " + ingredient.unite)
                                            Text("à " + String(format: "%.2f",ingredient.prixUnitaire).replaceComa())
                                            Text("€/" + ingredient.unite)
                                        }
                                    }
                                }
                            }
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            intent.intentToDeleteIngredient(id: index)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("Liste des ingrédients"),displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        NavigationLink(destination: IngredientCreateView(vm: CategorieIngredientViewModel())){
                            Text("Ajout")
                        }
                    }
                }.padding()
            }
            .onChange(of: ingredientListViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .noError :
                        return
                    case .deleteError:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    ingredientListViewModel.result = .failure(.noError)
                }
            }
        }

        
    }
    
}
