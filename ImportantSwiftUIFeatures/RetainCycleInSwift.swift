//
//  RetainCycleInSwift.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/16/24.
//

import Foundation

protocol GameDelegate: AnyObject { // Strong reference to the player
    func playerDidFinishGame(player: Player)
}

class Player {
    var delegate: GameDelegate? // Strong reference to the delegate

    init(delegate: GameDelegate) {
        self.delegate = delegate
    }
}



class GameManager: GameDelegate { // Strong reference to the player
    private var player: Player?

    func startGame(withPlayer player: Player) {
        self.player = player
        player.delegate = self
    }

    func playerDidFinishGame(player: Player) {
        // Do something when the player finishes the game
    }
}

// Create a GameManager and a Player
let gameManager = GameManager()
let player = Player(delegate: gameManager)

// Start the game, creating a retain cycle
// gameManager.startGame(withPlayer: player)

// Both objects now hold strong references to each other, preventing deinitialization.

//// To break the cycle, you could:
//// 1. Use weak references:
//class Player {
//    weak var delegate: GameDelegate?
//}
//
//protocol GameDelegate: AnyObject {
//    func playerDidFinishGame(player: Player)
//}
//
//// 2. Break the cycle manually:
//gameManager.player = nil
//player.delegate = nil
