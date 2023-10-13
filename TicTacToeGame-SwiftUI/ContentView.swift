//
//  ContentView.swift
//  TicTacToeGame-SwiftUI
//
//  Created by param  on 2023-06-03.
//

import SwiftUI


struct ContentView: View {
    
    // State variables
    @State private var moves: [PlayerMoves?] = Array(repeating: nil, count: 9)
    @State private var isPadDisabled: Bool = false
    @State private var alertData: AlertData = AlertData(title: "", buttonText: "")
    @State private var showAlert: Bool = false
    //    @State private var playerTurnHuman: Bool = true
    
    //    let totalPads: Int = 9
    
    var body: some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        GeometryReader{ geometry in
            VStack{
                Spacer()
                // GridStack(rows: 4, column: 4)
                LazyVGrid(columns: columns, spacing: 4)
                {
                    ForEach (0..<9) { padPosition in
                        ZStack{
                            //                            GeometryReader{ zStackGeometry in
                            
                            Rectangle()
                                .frame(width: geometry.size.width/3-12, height: geometry.size.width/3-12)
                                .foregroundColor(.cyan)
                                .cornerRadius(10)
                            
                            if let _ = moves[padPosition] {
                                
                                Image(systemName: moves[padPosition]?.playerType == Player.human ? "xmark" : "circle" )
                                    .resizable()
                                    .padding()
                            }
                            //                                .frame(width: zStackGeometry.size.width)
                            //                            }
                        }
                        .onTapGesture {
                            // human moves
                            if (moves[padPosition] != nil){
                                return
                            }
                            moves[padPosition] = PlayerMoves(playerType: .human, movePosition: padPosition)
                            //                            playerTurnHuman.toggle()
                            //                            print(moves)
                            isPadDisabled = true
                            
                            if (checkResult(moves: moves, playerType: .human)){
                                alertData = AlertData(title: "You Won", buttonText: "Continue")
                                showAlert = true
                                return
                            }
                            //                            checkResult(moves: moves, playerType: .human) ? print("Human Won") : nil
                            
                            // computer moves
                            
                            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                            // Alternate method for delay
                            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false)
                            { _ in
                                let computerMovePosition = getComputerMove(moves: moves)
                                if computerMovePosition == -1 {
                                    return
                                }
                                moves[computerMovePosition] = PlayerMoves(playerType: .computer, movePosition: computerMovePosition)
                                if checkResult(moves: moves, playerType: .computer){
                                    alertData = AlertData(title: "You Lost!", buttonText: "Retry")
                                    showAlert = true
                                    return
                                }
                                isPadDisabled = false
                            }
                            
                            let totalMoves = moves.compactMap { $0 }
                            if totalMoves.count == 9{
                                alertData = AlertData(title: "It's a Draw!", buttonText: "Rematch")
                                showAlert = true
                                return
                            }
                            
                        }
                        .disabled(isPadDisabled)
                        
                    }
                }
                Spacer()
                
            }
            .padding()
            .alert(alertData.title, isPresented: $showAlert, presenting: alertData) { alertItem in
                Button(alertItem.buttonText, role: .none) {
                    resetGame(moves: &moves)
                    isPadDisabled = false
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Struct to get data for Alert messages
struct AlertData{
    var title: String
    //    var message: String
    var buttonText: String
}


// Enum for player types
enum Player{
    case human
    case computer
}

// Struct to capture player moves
struct PlayerMoves{
    
    var playerType: Player
    var movePosition: Int
}

// Function to check whether the pad is filled or not
func isPadFilled(moves: [PlayerMoves?], position: Int) -> Bool {
    if moves[position] != nil {
        return true
    }
    else {
        return false
    }
}

// AI - Computer moves decider
func getComputerMove(moves: [PlayerMoves?]) -> Int{
    // Initializing computer
    var compMovePosition = Int.random(in: 0..<9)
    
    // To check if there is no more moves available. (Game Over)
    if moves.compactMap({ $0 }).count == 9{
        return -1
    }
    
    // Getting wining move for computer
    if let compWiningMovePosition = getWiningMovePosition(moves: moves, playerType: .computer){
        return compWiningMovePosition
    }
    
    // Blocking user's wining move
    if let compBlockingMovePosition = getWiningMovePosition(moves: moves, playerType: .human){
        return compBlockingMovePosition
    }
    
    while isPadFilled(moves: moves, position: compMovePosition){
        compMovePosition = Int.random(in: 0..<9)
    }
    
    return compMovePosition
}


// To get the wining move for each player
func getWiningMovePosition(moves: [PlayerMoves?], playerType: Player) -> Int?{
    
    let winPossibilities: Set<Set<Int>> = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6] ]
    
    
    let playerMoves = moves.filter({ $0?.playerType == playerType }).compactMap { $0?.movePosition }
    // Alternate method same result
    // let playerMoves = moves.compactMap { $0?.playerType == playerType ? $0?.movePosition : nil }
    
    if playerMoves.count > 0{
        
        for winPossibility in winPossibilities {
            let movesLeftToWin = winPossibility.subtracting(playerMoves)
            if movesLeftToWin.count == 1{
                if let playerTargetPosition = movesLeftToWin.first{
                    if !isPadFilled(moves: moves, position: playerTargetPosition){
                        return playerTargetPosition
                    }
                }
            }
        }
    }
    return nil
}

// Win/Loss/Draw Checker
func checkResult(moves: [PlayerMoves?], playerType: Player) -> Bool{
    
    let winPossibilities: Set<Set<Int>> = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6] ]
    
    let playerMovePositions = moves.compactMap { move in
        if move?.playerType == playerType{
            return move?.movePosition
        }
        else{
            return nil
        }
        
    }
    
    for winPossibility in winPossibilities{
        if winPossibility.isSubset(of: playerMovePositions)
        {
            return true
        }
    }
    return false
}

// reset game function
func resetGame(moves: inout [PlayerMoves?]){
    moves = Array.init(repeating: nil, count: 9)
//    print("Game Reset")
}
