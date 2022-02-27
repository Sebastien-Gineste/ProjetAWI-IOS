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
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    
    init(){
        self.intent = AllergèneIntent()
        self.allergène = AllergèneViewModel()
        self.intent.addObserver(self.allergène)
    }
    
    var body : some View {
        VStack {
            Form {
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
                }
            }
            Spacer()
            Button("Ajout"){
                intent.intentToAddAllergène()
                self.presentationMode.wrappedValue.dismiss()
            }.padding(20)
        }
        .navigationBarTitle(Text("Ajout d'allergène"),displayMode: .inline)
        
    }}
