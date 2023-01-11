//
//  GameBoardView.swift
//  Elevation
//
//  Created by jerome on 11/17/22.
//

import SwiftUI

struct GameBoardView: View {
    @StateObject private var board = GameBoard()
    
    var body: some View {
        VStack {
            ForEach(0..<board.state.count, id: \.self) { row in
                rowView(row: board.state[row])
            }
        }
        .buttonStyle(.plain)
    }
  
    func rowView(row: [Space]) -> some View {
        HStack {
            ForEach(row) { tile in
                
                SpaceView(space: tile) {
                    board.clicked(space: tile)
                }
            }
        }
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
