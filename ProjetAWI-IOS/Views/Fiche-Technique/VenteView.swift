//
//  VenteView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct VenteView : View {

    @State var nbrEtiquette : Int = 0 {
        didSet {
            if nbrEtiquette < 0 {
                nbrEtiquette = oldValue
            }
        }
    }
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
        
    init(){
        
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    
                    LazyVGrid(columns: columns, alignment: .leading){
                        Text("Nombre de vente : ")
                        TextField("Nombre", value : $nbrEtiquette, formatter: formatter)
                    }
                }
            }

            Spacer()
            Button("Vendre"){
                makeVente()
            }.padding(20)
        }.padding()
            .navigationBarTitle(Text("Vente"), displayMode: .inline)
        // TO DO : alert create
    }
    
    func makeVente(){

    }
    
}
