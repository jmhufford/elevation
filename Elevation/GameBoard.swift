//
//  GameBoard.swift
//  Elevation
//
//  Created by jerome on 12/29/22.
//

/*
+ 0 1 2 3 4 5 6
0 - - - * * * *
1 - - * * * * *
2 - * * * * * *
3 * * * * * * *
4 * * * * * * -
5 * * * * * - -
6 * * * * - - -
*/

import Foundation

class GameBoard: ObservableObject {
    let boardSize = 7
    
    enum Player {
        case one, two
        var toggle: Player {
            if self == .one {
                return .two
            } else {
                return .one
            }
        }
        var elevation: Space.Elevation {
            if self == .one {
                return .low
            } else {
                return .high
            }
        }
    }
    
    enum Stage {
        case elevation, player
    }
    
    @Published private (set) var selectedSpace: Space?

    @Published var state = [[Space]]()
    
    @Published var turn: Player = .one
    @Published var stage: Stage = .elevation
    
    /// Collection of all spaces that are in bounds
    var allSpaces: [Space] = []

    init() {
        reset()
    }
    
    func reset() {
        state.removeAll()
        
        // create tiles
        for row in 0..<boardSize {
            var newRow = [Space]()
            
            for col in 0..<boardSize {
                let xPlusY = row + col
                let lowBound: Int = boardSize / 2 // Use integer math to divide by two and round down
                let highBound: Int = boardSize + lowBound - 1
                var inBounds = true
                if (xPlusY > highBound || xPlusY < lowBound) {
                   inBounds = false
                }
                let space = Space(X: row, Y: col, inBounds: inBounds)
                newRow.append(space)
            }
            
            state.append(newRow)
        }
        
        // set row 0 to player one
        for space in state[0] {
            space.down()
            space.isOccupied = true
        }
        
        // set last row to player two
        for space in state[boardSize - 1] {
            space.up()
            space.isOccupied = true
        }
        
        let flattened = state.reduce([], +)
        allSpaces = flattened.filter { $0.inBounds }
    }
    
    func clicked(space: Space) {
        // if a space is already selected
        if let sel = selectedSpace {
            if stage == .elevation && canMoveElevation(from: sel, to: space) {
                moveElevation(from: sel, to: space)
                stage = .player
            } else if stage == .player && canMovePiece(from: sel, to: space) {
                movePiece(from: sel, to: space)
                // check if moved piece gets captured. otherwise check if it captures anything
                if !capture(space: space) {
                    for adj in getAdjacent(space: space) {
                        _ = capture(space: adj)
                    }
                }
                
                stage = .elevation
                turn = turn.toggle
            }
            deselect()
        } else {
            // no space is currently selected
            if stage == .elevation && !space.isOccupied {
                select(space: space)
            } else if stage == .player && space.isOccupied {
                if turn.elevation == space.elevation {
                    select(space: space)
                }
            }
        }
    }
    
    func capture(space: Space) -> Bool {
        guard space.isOccupied else { return false }
        let seladj = getAdjacent(space: space)
        var adjOpponents: [Space] = []
        for adj in seladj {
            if adj.isOccupied && space.elevation != adj.elevation {
                adjOpponents.append(adj)
            }
        }
        if adjOpponents.count >= 2 {
            objectWillChange.send()
            space.isOccupied = false
            return true
        }
        return false
    }
    
    func select(space: Space) {
        objectWillChange.send()
        // deselect old space
        selectedSpace?.selected = false
        
        // select new space
        selectedSpace = space
        selectedSpace?.selected = true
    }
    
    func deselect() {
        objectWillChange.send()
        selectedSpace?.selected = false
        selectedSpace = nil
    }
    
    func getSpace(x: Int, y: Int) -> Space? {
        guard x >= 0 else { return nil }
        guard x < boardSize else { return nil }
        guard y >= 0 else { return nil }
        guard y < boardSize else { return nil }
        guard state[x][y].inBounds else { return nil }
        
        return state[x][y]
    }
    
    func canMovePiece(from: Space, to: Space) -> Bool {
        // not the same space
        guard from !== to else { return false }

        // is in bounds
        guard from.inBounds, to.inBounds else { return false }
        
        // spaces are same elevation
        guard from.elevation == to.elevation else { return false }
            
        // can move
        guard from.isOccupied, !to.isOccupied else { return false }

        return true
    }
    
    func movePiece(from: Space, to: Space) {
        guard canMovePiece(from: from, to: to) else { return }
        
        objectWillChange.send()
        from.isOccupied = false
        to.isOccupied = true
    }
    
    func canMoveElevation(from: Space, to: Space) -> Bool {
        // not the same space
        guard from !== to else { return false }
     
        // is unoccupied
        guard !from.isOccupied, !to.isOccupied else { return false }
        
        // is in bounds
        guard from.inBounds, to.inBounds else { return false }
   
        // can move elevation
        guard from.elevation == .mid || from.elevation == .high else { return false }
        guard to.elevation == .mid || to.elevation == .low else { return false }
        
        return true
    }
    
    func moveElevation(from: Space, to: Space) {
        guard canMoveElevation(from: from, to: to) else { return }
        
        objectWillChange.send()
        from.down()
        to.up()
    }
    
    func getAdjacent(space: Space) -> [Space] {
        let adjacent = allSpaces.filter { space.isAdjacent(space: $0) }

/*        var adjacent: [Space] = []
        let x = space.x
        let y = space.y
        
        if let opt1 = getSpace(x: x + 1, y: y) {
            adjacent.append(opt1)
        }
        if let opt2 = getSpace(x: x - 1, y: y) {
            adjacent.append(opt2)
        }
        if let opt3 = getSpace(x: x, y: y + 1) {
            adjacent.append(opt3)
        }
        if let opt4 = getSpace(x: x, y: y - 1) {
            adjacent.append(opt4)
        }
        if let opt5 = getSpace(x: x + 1, y: y - 1) {
            adjacent.append(opt5)
        }
        if let opt6 = getSpace(x: x - 1, y: y + 1) {
            adjacent.append(opt6)
        } */
        
        return adjacent
    }
}
