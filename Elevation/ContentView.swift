//
//  ContentView.swift
//  Elevation
//
//  Created by jerome on 11/17/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("Blue")
                Spacer()
                Text("Elevation Game")
                Spacer()
                Text("Red")
            }
            .font(.system(size: 36).weight(.black))
            HStack {
                GameBoardView()
            }
        }
        .padding()
        .fixedSize()
        .preferredColorScheme(.dark)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MainMenuView: View {
    var body: some View {

            VStack {
                Text("New Game")
                Text("Options")
            }
            .padding()
        
    }
}
