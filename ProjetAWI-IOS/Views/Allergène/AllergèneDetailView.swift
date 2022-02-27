//
//  AllergèneDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI

struct AllergèneDetailView: View {
    var intent : AllergèneIntent
    @ObservedObject var allergène : AllergèneViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    
    init(vm: AllergèneListViewModel, indice : Int){
        self.intent = AllergèneIntent()
        self.allergène = AllergèneViewModel(allergèneListViewModel: vm, indice: indice)
        self.intent.addObserver(self.allergène)
    }
    
    var body : some View {
        VStack {
            Form{
                Section {
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
                }
            }
            Spacer()
            Button("Modifier"){
                intent.intentToUpdateDatabase()
            }.padding(20)
        }
        .navigationBarTitle(Text("Détails de l'allergène"),displayMode: .inline)
        
    }}
