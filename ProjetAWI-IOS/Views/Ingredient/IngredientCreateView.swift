//
//  IngredientCreateView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import SwiftUI

struct IngredientCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    var intent : IngredientIntent
    @ObservedObject var ingredient : IngredientViewModel
    @ObservedObject var categorieIngredientViewModel : CategorieIngredientViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var selectedIndex : Int = 0
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    init(vm: CategorieIngredientViewModel){
        self.intent = IngredientIntent()
        self.categorieIngredientViewModel = vm
        self.ingredient = IngredientViewModel()
        self.intent.addObserver(self.ingredient)
    }
    
    var body : some View {
        VStack {
            Form{
                Section {
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",text: $ingredient.nomIngredient)
                                .onSubmit {
                                    intent.intentToChange(nomIngrédient: ingredient.nomIngredient)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Prix unitaire :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ingredient.prixUnitaire, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(prixUnitaire: ingredient.prixUnitaire)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Quantité :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",value: $ingredient.qteIngredient, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(quantité: ingredient.qteIngredient)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Unité :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",text: $ingredient.unite)
                                .onSubmit {
                                    intent.intentToChange(unite: ingredient.unite)
                                }
                        }
                    }
                    HStack {
                        Picker(selection: $selectedIndex, label: Text("Categorie :")) {
                            ForEach(0 ..< categorieIngredientViewModel.tabCategorieIngredient.count) {
                                if categorieIngredientViewModel.tabCategorieIngredient.indices.contains($0) {
                                   Text(categorieIngredientViewModel.tabCategorieIngredient[$0])
                                } else {
                                    Text("")
                                }
                            }
                        }.onChange(of: selectedIndex, perform: {
                            value in
                            self.intent.intentToChange(categorie: self.categorieIngredientViewModel.tabCategorieIngredient[value])
                        })
                    }
                }
            }.padding()
                .onChange(of: ingredient.result){
                    result in
                    switch result {
                    case let .success(msg):
                       self.alertMessage = msg
                       self.showingAlert = true
                        break
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
                }
            Spacer()
            Button("Ajout"){
                intent.intentToAddIngredient()
                self.presentationMode.wrappedValue.dismiss()
            }.padding(20)
        }
        .navigationBarTitle(Text("Ajout d'ingredient"),displayMode: .inline)
        
    }}

