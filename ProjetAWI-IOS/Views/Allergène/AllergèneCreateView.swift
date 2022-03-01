//
//  AllergèneDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI

struct AllergèneCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    var intent : AllergèneIntent
    @ObservedObject var allergène : AllergèneViewModel
    @ObservedObject var ingredientListViewModel : IngredientListViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    
    init(vmIngredient : IngredientListViewModel){
        self.intent = AllergèneIntent()
        self.ingredientListViewModel = vmIngredient
        self.allergène = AllergèneViewModel()
        self.intent.addObserver(self.allergène)
    }
    
    var body : some View {
        VStack {
            Form {
                Section(header: Text("Informations")) {
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom de l'allergène :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("",text: $allergène.nom)
                                .onSubmit {
                                    intent.intentToChange(nom: allergène.nom)
                                }
                        }
                    }.onChange(of: allergène.result){
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
                                allergène.result = .failure(.noError)
                                self.showingAlert = false
                            }
                        }
                    HStack {
                        NavigationLink(destination: MultipleSelectionIngredient(items: self.ingredientListViewModel.tabIngredient,selections: $allergène.listIngredient)){
                            HStack {
                                Text("Liste ingrédient :")
                                Spacer()
                                Text("Modifier")
                                    .foregroundColor(Color.gray)
                            }
                        }.onChange(of: allergène.listIngredient, perform: { value in
                            self.intent.intentToChange(listIngredient: value)
                        })
                    }
                }
                Section(header: Text("Ingrédient contenant cet allergène")){
                    VStack(alignment: .leading) {
                        if $allergène.listIngredient.count == 0 {
                            Text("Cet allergène n'est dans aucun ingrédient")
                        } else {
                            List {
                                ForEach(Array(allergène.listIngredient.enumerated()), id: \.offset) {
                                    _, ingrédient in
                                    VStack(alignment: .leading) {
                                        Text(ingrédient)
                                    }.padding(2)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            Button("Ajout"){
                intent.intentToAddAllergène()
                intent.intentToUpdateIngredientFromAllergène()
                self.presentationMode.wrappedValue.dismiss()
            }.padding(20)
        }
        .navigationBarTitle(Text("Ajout d'allergène"),displayMode: .inline)
        
    }}
