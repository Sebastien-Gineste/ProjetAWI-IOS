//
//  ContentView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct MainView: View {
    @State var showMenu = false
    init(){
        Theme.loadNavigationBarTitleStyle()
    }
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                       if $0.translation.width < -100 {
                           withAnimation {
                               self.showMenu = false
                           }
                       }
                    }
        NavigationView {
            GeometryReader {
                geometry in
                ZStack(alignment: .leading){
                    FicheTechniqueListView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? 2*geometry.size.width/3 : 0)
                        .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        MenuView()
                            .frame(width: 2*geometry.size.width/3)
                            .transition(.move(edge: .leading))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle("Site Recettes", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
            ))
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
