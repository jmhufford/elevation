//
//  TileView.swift
//  Elevation
//
//  Created by jerome on 12/29/22.
//

import SwiftUI

struct SpaceView: View {
    var space: Space
    var selectAction: () -> Void
    var image: String {
        switch space.selected {
        case true: return "hexagon.fill"
        case false: return "hexagon"
        }
    }
    var piece = "figure.stand"
    var color: Color {
        switch space.elevation {
        case .low: return .blue
        case .mid: return .gray
        case .high: return .red
        }
    }
    
    var body: some View {
        Group {
            if !space.inBounds {
                EmptyView()
            } else {
                ZStack {
                    
                    if space.isOccupied {
                        Image(systemName: piece)
                            .foregroundColor(color)
                    }

                    Button(action: selectAction) {
                        Image(systemName: image)
                            .resizable()
                            .foregroundColor(color)
                    }
//                    .buttonStyle(.plain)
                }
            }
        }
        .frame(width: 32, height: 32)
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            SpaceView(space: Space(X: 0, Y: 0)) {}
            SpaceView(space: Space(X: 3, Y: 3, inBounds: true)) {}
//            var testSpace = Space(X: 4, Y: 4)
//            testSpace.selected = true
//            SpaceView(space: testSpace) {}
        }
    }
}
