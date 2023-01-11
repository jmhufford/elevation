//
//  Tile.swift
//  Elevation
//
//  Created by jerome on 12/29/22.
//

import Foundation

class Space: Equatable, Identifiable {
    static func == (lhs: Space, rhs: Space) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    enum Elevation {
        case low, mid, high
    }

    let x: Int
    let y: Int
    let inBounds: Bool
    
    var isOccupied: Bool = false
    var selected: Bool = false
    private (set) var elevation: Elevation = .mid
    
    init(X: Int, Y: Int, inBounds: Bool) {
        self.x = X
        self.y = Y
        self.inBounds = inBounds
    }
    
    func up() {
        if elevation == .low {
            elevation = .mid
        } else if elevation == .mid {
            elevation = .high
        }
    }
    
    func down() {
        if elevation == .high {
            elevation = .mid
        } else if elevation == .mid {
            elevation = .low
        }
    }
    
    func isAdjacent(space: Space) -> Bool {
        guard space.inBounds else { return false }
        
        // six possible options of avaliblity.
        if self.x == space.x, self.y + 1 == space.y { return true }
        if self.x == space.x, self.y - 1 == space.y { return true }
        if self.x + 1 == space.x, self.y == space.y { return true }
        if self.x - 1 == space.x, self.y == space.y { return true }
        if self.x + 1 == space.x, self.y - 1 == space.y { return true }
        if self.x - 1 == space.x, self.y + 1 == space.y { return true }
        return false
    }
}

