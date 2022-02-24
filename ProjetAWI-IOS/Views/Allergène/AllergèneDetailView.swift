//
//  AllergèneDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI

struct AllergèneDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var intent : AllergèneIntent
    @ObservedObject var allergène : AllergèneViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    var isAdd : Bool
    
    init(vm: AllergèneListViewModel? = nil, indice : Int? = nil){
        self.intent = AllergèneIntent()
        self.isAdd = vm == nil && indice == nil
        self.allergène = AllergèneViewModel(allergèneListViewModel: vm, indice: indice)
        self.intent.addObserver(self.allergène)
    }
    
    var body : some View {
        VStack {
            Spacer()
            HStack{
                LazyVGrid(columns: columns){
                    Text("Nom de l'allergène :").frame(maxWidth: .infinity, alignment: .leading)
                    TextField("",text: $allergène.nom)
                        .onSubmit {
                            intent.intentToChange(nom: allergène.nom)
                        }
                }
            }.padding()
                .onChange(of: allergène.result){
                    result in
                    switch result {
                    case let .success(msg):
                        self.alertMessage = msg
                        self.showingAlert = true
                    case let .failure(error):
                        switch error {
                        case .updateError :
                            self.alertMessage = "\(error)"
                            self.showingAlert = true
                        case .noError :
                            return
                        }
                    }
                }
                .alert("\(alertMessage)", isPresented: $showingAlert){
                    Button("OK", role: .cancel){
                        allergène.result = .failure(.noError)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            Spacer()
            Button(self.isAdd ? "Ajout" : "Modifier"){
               intent.intentToUpdateDatabase()
            }.padding(20)
        }
        .navigationBarTitle(Text(self.isAdd ? "Ajout d'allergène" : "Détails de l'allergène"),displayMode: .inline)
        
    }}
