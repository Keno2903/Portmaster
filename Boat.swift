//
//  Boat.swift
//  Port Master
//
//  Created by Keno Göllner  on 12.04.20.
//  Copyright © 2020 Keno Göllner . All rights reserved.
//

import Foundation
import SceneKit

var ship = SCNScene(named: "art.scnassets/ships/ship1.scn")?.rootNode.childNode(withName: "ship1", recursively: true)!
var ship2 = SCNScene(named: "art.scnassets/ships/ship2.scn")?.rootNode.childNode(withName: "ship2", recursively: true)!
var ship3 = SCNScene(named: "art.scnassets/ships/ship3.scn")?.rootNode.childNode(withName: "ship3", recursively: true)!
var ship4 = SCNScene(named: "art.scnassets/ships/ship4.scn")?.rootNode.childNode(withName: "ship4", recursively: true)!
var ship5 = SCNScene(named: "art.scnassets/ships/ship5.scn")?.rootNode.childNode(withName: "ship5", recursively: true)!
var ship6 = SCNScene(named: "art.scnassets/ships/ship6.scn")?.rootNode.childNode(withName: "ship6", recursively: true)!
var ship7 = SCNScene(named: "art.scnassets/ships/ship7.scn")?.rootNode.childNode(withName: "ship7", recursively: true)!
var ship8 = SCNScene(named: "art.scnassets/ships/ship8.scn")?.rootNode.childNode(withName: "ship8", recursively: true)!
var ship9 = SCNScene(named: "art.scnassets/ships/ship9.scn")?.rootNode.childNode(withName: "ship9", recursively: true)!
let gongSound = SCNAudioSource(named: "art.scnassets/sounds/Gong.aif")
let woodSound = SCNAudioSource(fileNamed: "art.scnassets/sounds/woodenShip2.wav")
let woodSound2 = SCNAudioSource(fileNamed: "art.scnassets/sounds/woodenShip.wav")
let engine = SCNAudioSource(fileNamed: "art.scnassets/sounds/engine_01.wav")
let pirateSound = SCNAudioSource(fileNamed: "art.scnassets/sounds/Argh.wav")
let horn = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn.caf")
let horn2 = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn2.caf")
let horn3 = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn3.caf")
let degreesPerRadians = Float(Double.pi/180)
let radiansPerDegrees = Float(180/Double.pi)
let moveAction = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(x: 0,y:0,z: -10), duration: 2))
let moveActionRight = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(x: 10,y:0,z: 0), duration: 2))


struct physicsBodies {
    static let boat1 = 1
    static let boat2 = 4
    static let box = 8
    static let box2 = 16

}

func toRadians(angle: Float) -> Float {
          return angle * degreesPerRadians
      }

   func toRadians(angle: CGFloat) -> CGFloat {
          return angle * CGFloat(degreesPerRadians)
      }

    func adjustBoat(row: Int, shipToPlace: String) -> SCNNode {
        moveAction.timingMode = .easeInEaseOut
        moveActionRight.timingMode = .easeInEaseOut
        var node : SCNNode!
        var sound : SCNAudioPlayer!
        switch difficulty {
            case 0:
            moveActionRight.speed = 1
            moveAction.speed = 1
            case 1:
            moveActionRight.speed = 2
            moveAction.speed = 2
            case 2:
            moveActionRight.speed = 3
            moveAction.speed = 3
            default:
            break
        }
        
        switch shipToPlace {
            case "ship1":
            node = ship
            sound = SCNAudioPlayer(source: horn2!)
            case "ship2":
            node = ship2
            sound = SCNAudioPlayer(source: engine!)
            case "ship3":
            node = ship3
            sound = SCNAudioPlayer(source: horn2!)
            case "ship4":
            node = ship4
            sound = SCNAudioPlayer(source: horn3!)
            case "ship5":
            node = ship5
            sound = SCNAudioPlayer(source: pirateSound!)
            case "ship6":
            node = ship6
            sound = SCNAudioPlayer(source: gongSound!)
            case "ship7":
            node = ship7
            sound = SCNAudioPlayer(source: woodSound!)
            case "ship8":
            node = ship8
            sound = SCNAudioPlayer(source: woodSound2!)
            case "ship9":
            node = ship9
            sound = SCNAudioPlayer(source: woodSound!)
            default:
            break
            
        }
        node.removeAllActions()
        node.physicsBody = SCNPhysicsBody()
        switch row {
        case 1:
            node.eulerAngles =  SCNVector3(0, -toRadians(angle: 90),0)
            node.position =  SCNVector3(x: 0.5, y: 0, z: 4)
            node.physicsBody?.categoryBitMask = physicsBodies.boat1
            node.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
            node.runAction(moveAction)
        case 2:
            node.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
            node.position = SCNVector3(x: -17, y: 0, z: -11)
            node.physicsBody?.categoryBitMask = physicsBodies.boat2
            node.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
            node.runAction(moveActionRight)
        case 3:
            node.eulerAngles = SCNVector3(0, -toRadians(angle: 90), 0)
            node.position = SCNVector3(-3.8, 0, 6)
            node.physicsBody?.categoryBitMask = physicsBodies.boat1
            node.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
            node.runAction(moveAction)
        case 4:
            node.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
            node.position = SCNVector3(-22, 0, -14.0)
            node.physicsBody?.categoryBitMask = physicsBodies.boat2
            node.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
            node.runAction(moveActionRight)
        default:
            break
        }
        if themeOnly {
            switch mapToShow {
                case "containerPort":
                node = ship
                case "pirateMap":
                node = ship5
                case "middleAgeMap":
                node = ship8
                case "chinaMap":
                node = ship6
                case "egypt":
                node = ship9
                default:
                break
            }
        }
        if node == ship9 {
            if mapToShow != "egypt" {
                node.position.y = 0.5
            }
            
        }
        node.addAudioPlayer(sound)
        return node
    }
    
    
    
