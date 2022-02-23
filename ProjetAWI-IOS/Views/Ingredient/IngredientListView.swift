//
//  IngredientListView.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import SwiftUI


struct IngredientListView : View {
    
    @ObservedObject var ingredientListViewModel : IngredientListViewModel = IngredientListViewModel()
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    var intent: IngredientIntent
    var ingredientsFiltre: [Ingredient] {
        if searchText.isEmpty {
            return ingredientListViewModel.tabIngredient
        } else {
            return ingredientListViewModel.tabIngredient.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    init(vm : IngredientListViewModel){
        self.ingredientListViewModel = vm
        self.intent = IngredientIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(ingredientsFiltre.enumerated()), id: \.offset) {
                        index, ingredient in
                            HStack{
                                NavigationLink(destination: FicheTechniqueListView()){
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
                        ingredientListViewModel.tabIngredient.remove(atOffsets: indexSet)
                    }
                    .onMove{ indexSet, index in
                        ingredientListViewModel.tabIngredient.move(fromOffsets: indexSet, toOffset: index)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationTitle("Liste des ingrédients")
                EditButton().padding()
            }
            
        }

        
    }
    
}
