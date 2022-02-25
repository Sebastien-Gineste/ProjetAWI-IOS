//
//  IngredientDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 25/02/2022.
//

import Foundation
import SwiftUI

struct IngredientDetailView: View {
    var intent : IngredientIntent
    @ObservedObject var ingredient : IngredientViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    init(vm: IngredientListViewModel, indice : Int){
        self.intent = IngredientIntent()
        self.ingredient = IngredientViewModel(ingrédientListViewModel: vm, indice: indice)
        self.intent.addObserver(self.ingredient)
    }
    
    var body : some View {
        VStack {
            Spacer()
            HStack{
                LazyVGrid(columns: columns){
                    Text("Nom :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",text: $ingredient.nomIngredient)
                        .onSubmit {
                            intent.intentToChange(nomIngrédient: ingredient.nomIngredient)
                        }
                    Text("Prix unitaire :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",value: $ingredient.prixUnitaire, formatter: formatter)
                        .onSubmit {
                            intent.intentToChange(prixUnitaire: ingredient.prixUnitaire)
                        }
                    Text("Quantité :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",value: $ingredient.qteIngredient, formatter: formatter)
                        .onSubmit {
                            intent.intentToChange(quantité: ingredient.qteIngredient)
                        }
                    Text("Unité :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",text: $ingredient.unite)
                        .onSubmit {
                            intent.intentToChange(unite: ingredient.unite)
                        }
                    Text("Catégorie :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",text: $ingredient.categorie)
                        .onSubmit {
                            intent.intentToChange(categorie: ingredient.categorie)
                        }
                }
            }.padding()
                /*.onChange(of: ingredient.result){
                    result in
                    switch result {
                    case let .success(msg):
                        self.alertMessage = msg
                        self.showingAlert = true
                    case let .failure(error):
                        switch error {
                        case .updateError, .createError :
                            self.alertMessage = "\(error)"
                            self.showingAlert = true
                        case .noError :
                            return
                        }
                    }
                }
                .alert(Text(alertMessage), isPresented: $showingAlert){
                    Button("OK", role: .cancel){
                        ingredient.result = .failure(.noError)
                        self.showingAlert = false
                    }
                }*/
            Spacer()
            Button("Modifier"){
                //intent.intentToUpdateDatabase()
            }.padding(20)
        }
        .navigationBarTitle(Text("Détails de l'ingrédient"),displayMode: .inline)
        
    }}

