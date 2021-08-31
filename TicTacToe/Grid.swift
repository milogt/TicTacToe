//
//  Grid.swift
//  TicTacToe
//
//  Created by Guo Tian on 2/4/21.
//

import Foundation

class Grid {
    var grid: [Int]
    var gameOn: Bool
    let winning = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    var patternX: [Int]
    var patternO: [Int]
    
    init() {
        grid = [0,0,0,0,0,0,0,0,0]
        gameOn = true
        patternX = []
        patternO = []
    }
    
    func checkWin(_ pattern:[Int])->Bool {
        for win in winning {
            if pattern.sorted() == win || Set(win).isSubset(of:pattern) {
                gameOn = false
                return true
            }
        }
        return false
    }
    
    func checkEmpty(_ pos:Int) -> Bool {
        if grid[pos] == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func checkTie() -> Bool {
        if grid == [1,1,1,1,1,1,1,1,1] {
            gameOn = false
            return true
        }
        else {
            return false
        }
    }
    
    func occupyGrid(_ index:Int) {
        grid[index] = 1
    }
    
    func reset() {
        grid = [0,0,0,0,0,0,0,0,0]
        gameOn = true
        patternX = []
        patternO = []
    }
}
