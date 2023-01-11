//
//  ElevationTests.swift
//  ElevationTests
//
//  Created by jerome on 11/17/22.
//

import XCTest

final class ElevationTests: XCTestCase {
    
    var board: GameBoard!
    
    override func setUpWithError() throws {
        board = GameBoard()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /* func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    } */

    func testGetSpaceBounds() {
        var sp = board.getSpace(x: 0, y: 0)
        XCTAssertNil(sp)
        sp = board.getSpace(x: 0, y: board.boardSize - 1)
        XCTAssertNotNil(sp)
        sp = board.getSpace(x: board.boardSize - 1, y: 0)
        XCTAssertNotNil(sp)
        sp = board.getSpace(x: 200, y: 10)
        XCTAssertNil(sp)
    }
    
    func testGetSpace() {
        let sp = board.getSpace(x: 3, y: 0)
        XCTAssertEqual(sp?.x, 3)
        XCTAssertEqual(sp?.y, 0)
    }
    
    func testReset() {
        let sp1 = board.getSpace(x: 3, y: 3)!
        let sp2 = board.getSpace(x: 2, y: 2)!
        board.moveElevation(from: sp1, to: sp2)
        XCTAssertEqual(sp1.elevation, Space.Elevation.low)
        board.reset()
        let sp3 = board.getSpace(x: 3, y: 3)!
        XCTAssertEqual(sp3.elevation, Space.Elevation.mid)
    }
    
    func testGetAdjacent() {
    
        XCTAssertEqual(board.allSpaces.count, 37)
        
        let sp = board.getSpace(x: 3, y: 3)!
        let adj = board.getAdjacent(space: sp)
        XCTAssertEqual(adj.count, 6)
        
        let sp2 = board.getSpace(x: 0, y: 6)!
        let adj2 = board.getAdjacent(space: sp2)
        XCTAssertEqual(adj2.count, 3)
        print(adj2.debugDescription)
    }
    
    func testClicked() {
        let sp = board.getSpace(x: 3, y: 3)!
        board.clicked(space: sp)
    }
    
    func testCapture() {
        let sp1 = board.getSpace(x: 3, y: 3)!
        XCTAssertFalse(board.capture(space: sp1))
        let sp2 = board.getSpace(x: 3, y: 4)!
        let sp3 = board.getSpace(x: 3, y: 2)!
        sp1.up()
        sp1.isOccupied = true
        XCTAssertFalse(board.capture(space: sp1))
        sp2.down()
        sp2.isOccupied = true
        XCTAssertFalse(board.capture(space: sp1))
        sp3.down()
        sp3.isOccupied = true
        XCTAssertTrue(board.capture(space: sp1))
        XCTAssertFalse(board.capture(space: sp1))
        sp1.isOccupied = true
        let sp4 = board.getSpace(x: 2, y: 3)!
        sp4.up()
        sp4.isOccupied = true
        XCTAssertTrue(board.capture(space: sp3))

    }
}
