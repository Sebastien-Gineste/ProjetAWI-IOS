//
//  ContentView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State var showMenu = false
    init(){
        UINavigationBar.appearance().backgroundColor = .white
        if #available(iOS 13, *) {
                  let appearance = UINavigationBarAppearance()

                  // title color
                  appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

                  // large title color
                  appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                  // background color
                  appearance.backgroundColor = .blue

                  // bar button styling
                  let barButtonItemApperance = UIBarButtonItemAppearance()
                  barButtonItemApperance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

                  appearance.backButtonAppearance = barButtonItemApperance

                  // set the navigation bar appearance to the color we have set above
                  UINavigationBar.appearance().standardAppearance = appearance

                  // when the navigation bar has a neighbouring scroll view item (eg: scroll view, table view etc)
                  // the "scrollEdgeAppearance" will be used
                  // by default, scrollEdgeAppearance will have a transparent background
                  UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }

                // the back icon color
                UINavigationBar.appearance().tintColor = .white
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
                    MainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        MenuView()
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))

                        
                    }
                }
                .gesture(drag)

            }
            .navigationBarTitle("Side Menu", displayMode: .inline)
            .navigationBarItems(leading: (
                                Button(action: {
                                    withAnimation {
                                        self.showMenu.toggle()
                                    }
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .imageScale(.large)
                                }
                            ))
        }
       
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
