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
    var intent: IngredientIntent
    
    init(vm : IngredientListViewModel){
        self.ingredientListViewModel = vm
        self.intent = IngredientIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(ingredientListViewModel.tabIngredient.enumerated()), id: \.offset) {
                        index, ingredient in
                            HStack{
                               
                                NavigationLink(destination: FicheTechniqueListView()){
                                    Text(ingredient.nomIngredient + " " + String(format: "%.2f",ingredient.qteIngredient) + " " + ingredient.unite)
                                    
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
            }
            .navigationTitle("Liste des ingrédients")
        }

        
    }
    
}
