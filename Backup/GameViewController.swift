//
//  GameViewController.swift
//  Backup
//
//  Created by Keno Göllner  on 27.01.20.
//  Copyright © 2020 Keno Göllner . All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
//import GoogleMobileAds
import StoreKit

enum GameState {
    case menu, playing, gameOver, reset, settings, shopShips,shopMaps, shopMenu, loading
}

struct physicsBodies {
    static let boat1 = 1
    static let boat2 = 4
    static let box = 8
    static let box2 = 16
    static let ghost = 32

}

class GameViewController: UIViewController {
    


    

    func toRadians(angle: Float) -> Float {
              return angle * degreesPerRadians
          }

       func toRadians(angle: CGFloat) -> CGFloat {
              return angle * CGFloat(degreesPerRadians)
          }
    let floor = SCNFloor()
    var sceneView: SCNView!
    var cameraNode: SCNNode!
    var lightNode = SCNNode()
    var score = 0
    var coinsInGame = 0
    var scene: SCNScene!
    let degreesPerRadians = Float(Double.pi/180)
    let radiansPerDegrees = Float(180/Double.pi)
    
    var trafficLightLeftRed = SCNScene(named: "art.scnassets/decorations/trafficLightLeftRed.scn")?.rootNode.childNode(withName: "redLeft", recursively: true)
    var trafficLightLeftGreen = SCNScene(named: "art.scnassets/decorations/trafficLightLeftGreen.scn")?.rootNode.childNode(withName: "greenLeft", recursively: true)
    var trafficLightRightGreen = SCNScene(named: "art.scnassets/decorations/trafficLightRightGreen.scn")?.rootNode.childNode(withName: "greenRight", recursively: true)
    var trafficLightRightRed = SCNScene(named: "art.scnassets/decorations/trafficLightRightRed.scn")?.rootNode.childNode(withName: "redRight", recursively: true)
    
    var mapNode = SCNNode()
    var mapNode2 = SCNNode()
    var mapNode3 = SCNNode()
    var mapNode4 = SCNNode()
    var mapNode5 = SCNNode()
    
    var touchActive = false
    var touchActive2 = false

    var gameHUD: GameHUD!
    var gameState = GameState.menu
    var timer1 : Timer!
    var timer2: Timer!
    var timer3 : Timer!
    var timer4 : Timer!
    
    let gongSound = SCNAudioSource(named: "art.scnassets/sounds/Gong.aif")
    let woodSound = SCNAudioSource(fileNamed: "art.scnassets/sounds/woodenShip2.wav")
    let woodSound2 = SCNAudioSource(fileNamed: "art.scnassets/sounds/woodenShip.wav")
    let engine = SCNAudioSource(fileNamed: "art.scnassets/sounds/engine_01.wav")
    let pirateSound = SCNAudioSource(fileNamed: "art.scnassets/sounds/Argh.wav")
    let horn = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn.caf")
    let horn2 = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn2.caf")
    let horn3 = SCNAudioSource(fileNamed: "art.scnassets/sounds/horn3.caf")
    
    var ship = SCNScene(named: "art.scnassets/ships/ship1.scn")?.rootNode.childNode(withName: "ship1", recursively: true)!
    var ship2 = SCNScene(named: "art.scnassets/ships/ship2.scn")?.rootNode.childNode(withName: "ship2", recursively: true)!
    var ship3 = SCNScene(named: "art.scnassets/ships/ship3.scn")?.rootNode.childNode(withName: "ship3", recursively: true)!
    var ship4 = SCNScene(named: "art.scnassets/ships/ship4.scn")?.rootNode.childNode(withName: "ship4", recursively: true)!
    var ship5 = SCNScene(named: "art.scnassets/ships/ship5.scn")?.rootNode.childNode(withName: "ship5", recursively: true)!
    var ship6 = SCNScene(named: "art.scnassets/ships/ship6.scn")?.rootNode.childNode(withName: "ship6", recursively: true)!
    var ship7 = SCNScene(named: "art.scnassets/ships/ship7.scn")?.rootNode.childNode(withName: "ship7", recursively: true)!
    var ship8 = SCNScene(named: "art.scnassets/ships/ship8.scn")?.rootNode.childNode(withName: "ship8", recursively: true)!
    var ship9 = SCNScene(named: "art.scnassets/ships/ship9.scn")?.rootNode.childNode(withName: "ship9", recursively: true)!
    var ship10 = SCNScene(named: "art.scnassets/ships/ship10.scn")?.rootNode.childNode(withName: "ship10", recursively: true)!
    
    var moveAction : SCNAction!
    var moveActionRight : SCNAction!
    
    @objc var swipeGesture1 = UISwipeGestureRecognizer()
    @objc var swipeGesture2 = UISwipeGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    
    var crane = SCNScene(named: "art.scnassets/decorations/port crane.scn")?.rootNode.childNode(withName: "crane", recursively: true)!
    var craneArm = SCNScene(named: "art.scnassets/decorations/Port crane arm.scn")?.rootNode.childNode(withName: "arm", recursively: true)!
    var gabelStabler = SCNScene(named: "art.scnassets/decorations/Gabelstabler.scn")!.rootNode.childNode(withName: "stabler", recursively: true)!
 
    
    var deathAnimation = SCNAction.move(by: SCNVector3(0,45, 0), duration: 2)
    var stablerAction = SCNAction.move(by: SCNVector3(9.5, 0, 0), duration: 3)
    var stablerAction2 = SCNAction.rotateBy(x: 0, y: 1.55, z: 0, duration: 1)
    var stablerAction3 = SCNAction.move(by: SCNVector3(0, 0, -30), duration: 7)
    let resetAction = SCNAction.move(to: SCNVector3(-15.0, 1.5, -16), duration: 0.001)
    var stablerAction5 = SCNAction.rotateBy(x: 0, y: -1.55, z: 0, duration: 2)
    var craneArmAction1 = SCNAction.move(by: SCNVector3(-6, 0, 0), duration: 3)
    var craneArmAction2 = SCNAction.move(by: SCNVector3(6, 0, 0), duration: 3)
    var cameraAction : SCNAction!
    
    let bell = SCNAudioSource(fileNamed: "art.scnassets/sounds/bell.aif")
    let crash = SCNAudioSource(fileNamed: "art.scnassets/sounds/crash.caf")
    let click = SCNAudioSource(fileNamed: "art.scnassets/sounds/click.caf")
    let chineseMapMusic = SCNAudioSource(fileNamed: "art.scnassets/sounds/Spiel Musik chinesisch_1.wav")
    let medievalMapMusic = SCNAudioSource(fileNamed: "art.scnassets/sounds/medieval.mp3")
    let pirateMusic = SCNAudioSource(fileNamed: "art.scnassets/sounds/pirate.wav")
    let vikingSound = SCNAudioSource(fileNamed: "art.scnassets/sounds/Sword.mp3")
    let shipBell = SCNAudioSource(fileNamed: "art.scnassets/sounds/Big Ships Bell 1.mp3")
    let medievalImpact = SCNAudioSource(fileNamed: "art.scnassets/sounds/Medieval Impact.wav")
    
    var shopScene = SCNScene()
    var shopCamera = SCNNode()
    var shopLight = SCNNode()
    var shopMapsScene = SCNScene()
        
    var firstLoadingScene = SCNScene(named: "art.scnassets/ships/ship\(Int.random(in: 1...6)).scn")
    var paused = false
    let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
    var price = Int()
    var count = 0
    var mapPosition = SCNVector3(0, 0, 0)
    var shopShips : Bool!
    var NodeInShopName : String!
    
   // var rewardAd : GADRewardedAd?
    //var interstitial : GADInterstitial!
    
    let portcoinaction1 = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.1)
    let portcoinaction2 = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 0.1)
    var portCoinLabel : SKLabelNode!
    var portCoinsWhilLoadingAD : Int!
    let labelforDifficulty = SKLabelNode(fontNamed: "Retro Gaming")

    var yachtProductID = "Leon.Goellner.PortMaster.Yacht"
    var egyptProductID = "Leon.Goellner.Egypt"
    var loadingImage1 : UIImage!
    var imageView : UIImageView!
    var restoredProducts = 0
    var restoredProductsArray = [String]()
    var restoreButton : SpriteKitButton!
    var alert : UIAlertController!
    
    var canWatchRewardVideo = true
   //var rewardButton : SpriteKitButton!
    
    var showingAdInReset = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      /*  rewardAd = GADRewardedAd(adUnitID:  "ca-app-pub-1367076576699755/7097127015")
                rewardAd?.load(GADRequest()) { error in
             if let error = error {
               print(error)
               print("fuck")
            
                

            }else {
                
            }
        }
        interstitial = createAndLoadInterstitial()
 */
        initialiseGame()
        SKPaymentQueue.default().add(self)
    }
    
    func initialiseGame() {
        setUpScene()
        setupCamera()
        setupLight()
        setupPort()
        setupPortLight()
        setupActions()

    }
    
   
    
    func setUpScene() {
                              
                sceneView = view as? SCNView
                sceneView.delegate = self
                sceneView.allowsCameraControl = false
                sceneView.preferredFramesPerSecond = 60
                if sceneView.frame.height > 800 {
                    loadingImage1 = UIImage(named: "art.scnassets/buttonImages/schonBild.png")
                }else {
                    loadingImage1 = UIImage(named: "art.scnassets/buttonImages/schonBild2.png")
                }

                scene = SCNScene()
                scene.physicsWorld.contactDelegate = self
                sceneView.removeGestureRecognizer(tapGesture)
                
                if shipNumbersArray.isEmpty {
                difficulty = 1
                UserDefaults.standard.set(difficulty, forKey: "Difficulty")
                // first App launch
                shipNumbersArray.append("ship1")
                UserDefaults.standard.set(shipNumbersArray, forKey: "ShipsArray")
                volume = true
                UserDefaults.standard.set(volume, forKey: "Volume")
                mapToShow = "containerPort"
                mapNumbersArray.append("containerPort")
                UserDefaults.standard.set(mapNumbersArray, forKey: "MapsArray")
                UserDefaults.standard.set(mapToShow, forKey: "MapToShow")
                }
        
                if count == 0 {
                imageView = UIImageView(image: loadingImage1!)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: sceneView.frame.width, height: sceneView.frame.height)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                sceneView.addSubview(imageView)
                self.sceneView.present(self.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
                self.gameState = .menu
                self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
                self.sceneView.overlaySKScene = self.gameHUD
                self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
                let ships = [ship,ship2,ship3,ship4,ship5,ship6,ship7,ship8,ship9]
                for ship in ships {
                    ship?.opacity = 1
                    }
                sceneView.isUserInteractionEnabled = false
                self.scene.rootNode.addChildNode(self.mapNode)
                self.scene.rootNode.addChildNode(self.mapNode2)
                self.scene.rootNode.addChildNode(self.mapNode3)
                self.scene.rootNode.addChildNode(self.mapNode4)
                self.scene.rootNode.addChildNode(self.mapNode5)
                let notificationCenter = NotificationCenter.default
                notificationCenter.addObserver(self, selector: #selector(self.appMovedtoBackground), name: UIApplication.willResignActiveNotification, object: nil)
                notificationCenter.addObserver(self, selector: #selector(self.appCameToFront), name: UIApplication.willEnterForegroundNotification, object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.sceneView.isUserInteractionEnabled = true
        
                self.addMusic()
                            
     
                self.imageView.removeFromSuperview()
                self.count += 1
                    }
        }else if count != 0 {
            self.scene.rootNode.addChildNode(self.mapNode)
            self.scene.rootNode.addChildNode(self.mapNode2)
            self.scene.rootNode.addChildNode(self.mapNode3)
            self.scene.rootNode.addChildNode(self.mapNode4)
            self.scene.rootNode.addChildNode(self.mapNode5)
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.appMovedtoBackground), name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(self.appCameToFront), name: UIApplication.willEnterForegroundNotification, object: nil)
            self.gameState = .menu
            self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
            self.sceneView.overlaySKScene = self.gameHUD
            self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
            self.sceneView.present(self.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
            let ships = [ship,ship2,ship3,ship4,ship5,ship6,ship7,ship8,ship9]
            for ship in ships {
                ship?.opacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.showingAdInReset == false{
                self.addMusic()
                }
            }
        }
    }
    @objc func appMovedtoBackground() {
    sceneView.scene?.rootNode.removeAllAudioPlayers()
   if gameState == .playing && !paused{
   pauseGame()
    }
    
    }
    @objc func appCameToFront() {
        self.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeAllAudioPlayers()
        }
    sceneView.scene?.rootNode.removeAllAudioPlayers()
    if volume && gameState != .playing{
        addMusic()
        }
    }
    
    func resetGame() {
        
        if volume {
         let clickNoise = SCNAudioPlayer(source: self.click!)
         self.sceneView.scene?.rootNode.addAudioPlayer(clickNoise)}
         gameState = .loading
         gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
         sceneView.overlaySKScene = gameHUD
         for child in gameHUD.children {
             if child.position.x > gameHUD.frame.midX {
                 child.run(SKAction.moveTo(x: gameHUD.frame.midX, duration: 1.0))
             }
         }
        self.scene.rootNode.removeAllAudioPlayers()
        if !shipNumbersArray.contains("ship4") && !mapNumbersArray.contains("egypt") {
            if Int.random(in: 1...10) > 6{
                showingAdInReset = true
             //   self.presentInterstitial()
                
            }
        }else {
            showingAdInReset = false;
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()}
            self.cameraNode.removeAllActions()
            self.timer1.invalidate()
            self.timer2.invalidate()
            self.timer3.invalidate()
            self.timer4.invalidate()
            self.touchActive = false
            self.touchActive2 = false
            self.scene = nil
            self.sceneView = nil
            self.gameState = .menu
            self.score = 0
            self.coinsInGame = 0
            self.gabelStabler.removeAllActions()
            self.craneArm?.removeAllActions()
            self.initialiseGame()
        }
        
    }
   
    func goToRetryScene() {
        self.gameState = .reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
            self.sceneView.overlaySKScene = self.gameHUD
            self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
            self.setUpResetScene()
        }
    }
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 1, y: 28 ,z:-4.3)
        cameraNode.eulerAngles = SCNVector3(x: -toRadians(angle: 69),y: toRadians(angle: 20),z: 0)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func setupLight() {
            let ambientNode = SCNNode()
            ambientNode.light = SCNLight()
            ambientNode.light?.type = .omni
            let directionalNode = SCNNode()
            directionalNode.light = SCNLight()
            directionalNode.light?.type = .directional
            directionalNode.light?.castsShadow = true
            directionalNode.light?.shadowColor = UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1)
            directionalNode.position = SCNVector3(x: 5, y: 10, z: -40)
            directionalNode.eulerAngles = SCNVector3(x: 0, y: -toRadians(angle: 90), z: -toRadians(angle: 45))
            ambientNode.light?.intensity = 900
            directionalNode.light?.intensity = 1000
            directionalNode.light?.shadowMode = .modulated
            lightNode.addChildNode(ambientNode)

            lightNode.addChildNode(directionalNode)
            lightNode.position = cameraNode.position
            scene.rootNode.addChildNode(lightNode)
    }
 
    func setupPort() {
    if mapToShow == "containerPort"{
    let mapHall = SCNScene(named: "art.scnassets/maps/containerPortHall2.scn")
    for map in mapHall!.rootNode.childNodes {
        
        map.position = mapPosition
        map.position.z -= 12.3
        map.position.x -= 1.3
        map.flattenedClone()
        mapNode5.addChildNode(map.clone())
        }
 
     let craneArmMovement = SCNAction.repeatForever(SCNAction.sequence([craneArmAction1,craneArmAction2]))
     craneArm?.runAction(craneArmMovement)
     craneArm?.position = SCNVector3(-4.4, -1, -24.0)
     craneArm?.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
     mapNode5.addChildNode(craneArm!.clone())
     craneArm?.position = SCNVector3(-4.4, -1, -34.0)
     mapNode5.addChildNode(craneArm!.clone())
            
    }else if mapToShow == "pirateMap" {
     for map in SCNScene(named: "art.scnassets/maps/pirateMap/pirateMapHall2.scn")!.rootNode.childNodes {
        map.position = mapPosition
        mapNode5.addChildNode(map)
        map.position.z -= 15.0
        map.position.x -= 3.8
        map.flattenedClone()
        map.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
       }
    }else if mapToShow == "middleAgeMap" {
   let mapHall = SCNScene(named: "art.scnassets/maps/middleAgeMap/middleAgeMapHall2.scn")
        for map in mapHall!.rootNode.childNodes {
        map.eulerAngles = SCNVector3(0, -toRadians(angle: 90), 0)
        map.position = mapPosition
        map.position.z -= 17
        map.position.x -= 1.4
        map.flattenedClone()
        mapNode5.addChildNode(map.clone())
        }
    }else if mapToShow == "chinaMap" {
        let mapHall = SCNScene(named: "art.scnassets/maps/china map/chinaMapHall2.scn")
        for map in mapHall!.rootNode.childNodes {
            map.position = mapPosition
            map.position.z -= 17
            map.position.x -= 1.8
            map.position.y -= 0.1
            map.flattenedClone()
            mapNode5.addChildNode(map.clone())
        }
        }else if mapToShow == "egypt"{
        let mapHall = SCNScene(named: "art.scnassets/maps/egypt/egyptHall2.scn")
        for map in mapHall!.rootNode.childNodes {
        map.position = mapPosition
        map.position.z -= 15.7
        map.position.x -= 1.8
        map.flattenedClone()
        mapNode5.addChildNode(map.clone())
        }
        }
   }

    func addBox() {
        let boxGeometry = SCNBox(width: 3, height: 1, length: 5, chamferRadius: 0)
        let box = SCNNode(geometry: boxGeometry)
        box.opacity = 0
        box.physicsBody = SCNPhysicsBody()
        box.physicsBody?.categoryBitMask = physicsBodies.box
        box.position = SCNVector3(0.5, 1, -50)
        box.flattenedClone()
        scene.rootNode.addChildNode(box.clone())
        
        box.position = SCNVector3(-4, 1, -50)
        box.physicsBody = SCNPhysicsBody()
        box.physicsBody?.categoryBitMask = physicsBodies.box2
        box.flattenedClone()
        scene.rootNode.addChildNode(box.clone())
        
        box.position = SCNVector3(13, 1, -9)
        box.physicsBody = SCNPhysicsBody()
        box.physicsBody?.categoryBitMask = physicsBodies.box
        box.flattenedClone()
        scene.rootNode.addChildNode(box.clone())

        box.position = SCNVector3(13, 1, -15)
        box.physicsBody = SCNPhysicsBody()
        box.physicsBody?.categoryBitMask = physicsBodies.box2
        box.flattenedClone()
        scene.rootNode.addChildNode(box.clone())

    }

    func setupPortLight() {
        trafficLightLeftRed?.position = SCNVector3(1.3, 0, -11.5)
        trafficLightLeftRed?.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
        trafficLightLeftRed?.isHidden = true
        scene.rootNode.addChildNode(trafficLightLeftRed!)
        
        trafficLightLeftGreen?.position = SCNVector3(1.3, 0, -11.5)
        trafficLightLeftGreen?.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
        trafficLightLeftGreen?.isHidden = false
        scene.rootNode.addChildNode(trafficLightLeftGreen!)
        
        trafficLightRightRed?.position = SCNVector3(1.3, 0, -11.5)
        trafficLightRightRed?.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
        trafficLightRightRed?.isHidden = true
        scene.rootNode.addChildNode(trafficLightRightRed!)
        
        trafficLightRightGreen?.position = SCNVector3(1.3, 0, -11.5)
        trafficLightRightGreen?.eulerAngles = SCNVector3(0, -toRadians(angle: 180), 0)
        trafficLightRightGreen?.isHidden = false
        scene.rootNode.addChildNode(trafficLightRightGreen!)
    }
  
    func addMusic() {
        DispatchQueue.main.async {
            if volume {
                if mapToShow == "chinaMap" {
                    let music = SCNAudioPlayer(source: self.chineseMapMusic!)
                    self.scene.rootNode.addAudioPlayer(music)
                    self.chineseMapMusic?.loops = true
                    
                }else if mapToShow == "middleAgeMap" {
                    let music = SCNAudioPlayer(source: self.medievalMapMusic!)
                    self.scene.rootNode.addAudioPlayer(music)
                    self.medievalMapMusic!.loops = true
                }else if mapToShow == "pirateMap" {
                    let music = SCNAudioPlayer(source: self.pirateMusic!)
                    self.pirateMusic?.loops = true
                    self.scene.rootNode.addAudioPlayer(music)
                }else if mapToShow == "containerPort" {
                    let musicSource = SCNAudioSource(named: "art.scnassets/sounds/Drunken Sailor.wav")
                    musicSource?.loops = true
                    let music = SCNAudioPlayer(source: musicSource!)
                    self.scene.rootNode.addAudioPlayer(music)
                }else if mapToShow == "egypt" {
                    let musicSource = SCNAudioSource(named: "art.scnassets/sounds/Egypt.wav")
                    musicSource?.loops = true
                    let music = SCNAudioPlayer(source: musicSource!)
                    self.scene.rootNode.addAudioPlayer(music)
                }
            }
        }

    }
    func setupActions() {
        moveAction = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(x: 0,y:0,z: -10), duration: 4))
        moveActionRight = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(x: 10,y:0,z: 0), duration: 4))
        moveAction.timingMode = .easeInEaseOut
        moveActionRight.timingMode = .easeInEaseOut

        if sceneView.frame.height > 800 {
        cameraAction = SCNAction.move(to: SCNVector3(x: 1, y: 32 ,z:-4.3),duration : 2.0)
        }else {
         cameraAction = SCNAction.move(to: SCNVector3(x: 1.2, y: 29 ,z:-4.5),duration : 2.0)
        }
    }
    func boats() {
                var interval = 0.0
                 if difficulty == 0 {
                    interval = 1.5
                 }else if difficulty == 1 {
                     interval = 1.0
                 }else if difficulty == 2 {
                    interval = 0.5
                 }
                if difficulty == 0 {
                 self.moveAction.speed = 4.0
                 self.moveActionRight.speed = 3.0
                }else if difficulty == 1 {
                self.moveAction.speed = 6.0
                self.moveActionRight.speed = 5.0
                }else if difficulty == 2 {
                self.moveAction.speed = 8.0
                self.moveActionRight.speed = 7.0
                 }
                timer1 = Timer.scheduledTimer(withTimeInterval: interval * 1.1, repeats: true, block: { (timer) in
                    var sound : SCNAudioPlayer!
                    let bool = Bool.random()
                    var shiptoPlace = SCNNode()
                    if bool && self.touchActive2 == false{
                        
                        if self.gameState == .playing && self.paused == false && self.mapNode.childNodes.count < 2 {
                            var randomShip = shipNumbersArray.randomElement()
                            if themeOnly {
                                switch mapToShow {
                                    case "containerPort":
                                    randomShip = "ship1"
                                    case "pirateMap":
                                    randomShip = "ship5"
                                    case "middleAgeMap":
                                    randomShip = "ship8"
                                    case "chinaMap":
                                    randomShip = "ship6"
                                    case "egypt":
                                    randomShip = "ship9"
                                    default:
                                    break
                                    }
                                }
                                                 
                            if randomShip == "ship1" {
                                shiptoPlace = self.ship!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.horn2!)
                            }else if randomShip == "ship2" {
                                shiptoPlace = self.ship2!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.engine!)
                            }else if randomShip == "ship3"{
                                shiptoPlace = self.ship3!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.horn2!)
                            }else if randomShip == "ship4" {
                                shiptoPlace = self.ship4!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90),z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0.2, z: 4)
                                sound = SCNAudioPlayer(source: self.horn!)
                            }else if randomShip == "ship5" {
                                shiptoPlace = self.ship5!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.pirateSound!)
                            }else if randomShip == "ship6" {
                                shiptoPlace = self.ship6!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.gongSound!)
                            }else if randomShip == "ship7" {
                                shiptoPlace = self.ship7!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.woodSound2!)
                            }else if randomShip == "ship8" {
                                shiptoPlace = self.ship8!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.woodSound!)
                            }else if randomShip == "ship9" {
                                shiptoPlace = self.ship9!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: 0.5, y: 0.5, z: 4)
                                sound = SCNAudioPlayer(source: self.woodSound2!)
                                if mapToShow == "egypt" {
                                    shiptoPlace.position.y = 0.0
                                }
                            }else if randomShip == "ship10" {
                            shiptoPlace = self.ship10!
                            shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                            shiptoPlace.position = SCNVector3(x: 0.5, y: 0.5, z: 4)
                            sound = SCNAudioPlayer(source: self.woodSound2!)
                                }
                            if Int.random(in: 0...5) == 2{
                                    self.scene.rootNode.addAudioPlayer(sound)
                                        }
                            shiptoPlace.light?.color = UIColor.black
                            shiptoPlace.physicsBody = SCNPhysicsBody()
                            shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.boat1
                            if randomShip != "ship10" {
                            shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
                            }else {
                            shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.box|physicsBodies.box2
                            }
                            
                            shiptoPlace.removeAllActions()
                            shiptoPlace.runAction(self.moveAction)
                            shiptoPlace.flattenedClone()
                            self.mapNode.addChildNode(shiptoPlace.clone())
             
                        }
                    }
                })
            self.timer2 = Timer.scheduledTimer(withTimeInterval: interval * 1.1, repeats: true, block: { (timer) in
                           var shiptoPlace = SCNNode()
                           var sound : SCNAudioPlayer!
                           let bool = Bool.random()

                               if self.gameState == .playing && self.paused == false && self.mapNode2.childNodes.count < 3 && bool{
                                var randomShip = shipNumbersArray.randomElement()
                                if themeOnly {
                           switch mapToShow {
                               case "containerPort":
                               randomShip = "ship1"
                               case "pirateMap":
                               randomShip = "ship5"
                               case "middleAgeMap":
                               randomShip = "ship8"
                               case "chinaMap":
                               randomShip = "ship6"
                               case "egypt":
                               randomShip = "ship9"
                               default:
                               break
                               }
                           }
                                if randomShip == "ship1" {
                                    shiptoPlace = self.ship!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -11.0)
                                    sound = SCNAudioPlayer(source: self.horn2!)
                                }else if randomShip == "ship2" {
                                    shiptoPlace = self.ship2!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -11)
                                    sound = SCNAudioPlayer(source: self.engine!)
                                }else if randomShip == "ship3" {
                                    shiptoPlace = self.ship3!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0,y: self.toRadians(angle: 180),z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -11.5)
                                    sound = SCNAudioPlayer(source: self.horn2!)
                                }else if randomShip == "ship4" {
                                    shiptoPlace = self.ship4!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180),z: 0)
                                    shiptoPlace.position = SCNVector3(-17.5, 0.2, -11.5)
                                    sound = SCNAudioPlayer(source: self.horn!)
                                    }else if randomShip == "ship5" {
                                        shiptoPlace = self.ship5!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0, -11.5)
                                        sound = SCNAudioPlayer(source: self.pirateSound!)
                                    }else if randomShip == "ship6" {
                                        shiptoPlace = self.ship6!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0, -11.5)
                                        sound = SCNAudioPlayer(source: self.gongSound!)
                                    }else if randomShip == "ship7" {
                                        shiptoPlace = self.ship7!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0, -11.5)
                                        sound = SCNAudioPlayer(source: self.woodSound2!)
                                    }else if randomShip == "ship8" {
                                        shiptoPlace = self.ship8!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0, -11.5)
                                        sound = SCNAudioPlayer(source: self.woodSound!)
                                    }else if randomShip == "ship9" {
                                        shiptoPlace = self.ship9!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0.5, -11.5)
                                        sound = SCNAudioPlayer(source: self.woodSound2!)
                                    if mapToShow == "egypt" {
                                    shiptoPlace.position.y = 0.0
                                    }
                                    }else if randomShip == "ship10" {
                                        shiptoPlace = self.ship10!
                                        shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                        shiptoPlace.position = SCNVector3(-16, 0.5, -11.5)
                                        sound = SCNAudioPlayer(source: self.woodSound2!)
                                    }
                 
                                    if Int.random(in: 0...5) == 2{
                                            self.scene.rootNode.addAudioPlayer(sound)
                                                }
                                   shiptoPlace.light?.color = UIColor.black
                                   shiptoPlace.physicsBody = SCNPhysicsBody()
                                    if randomShip != "ship10" {
                                    shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.boat2
                                    }else {
                                    shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.ghost
                                    }
                                   shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.box
                                   shiptoPlace.removeAllActions()
                                   shiptoPlace.runAction(self.moveActionRight)
                                   shiptoPlace.flattenedClone()
                                   self.mapNode2.addChildNode(shiptoPlace.clone())
            
                               }
                       })
                   timer3 = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (timer) in
                       let bool = Bool.random()
                       var shiptoPlace = SCNNode()
                       var sound : SCNAudioPlayer!
                       if bool && self.touchActive == false{
                           
                           if self.gameState == .playing && self.paused == false && self.mapNode.childNodes.count < 2 {
                            var randomShip = shipNumbersArray.randomElement()
                    if themeOnly {
                                   switch mapToShow {
                                       case "containerPort":
                                       randomShip = "ship1"
                                       case "pirateMap":
                                       randomShip = "ship5"
                                       case "middleAgeMap":
                                       randomShip = "ship8"
                                       case "chinaMap":
                                       randomShip = "ship6"
                                       case "egypt":
                                       randomShip = "ship9"
                                       default:
                                       break
                                       }
                                   }
                               
                               if randomShip == "ship1"{
                                shiptoPlace = self.ship!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: -3.4, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.horn2!)
                               }else if randomShip == "ship2" {
                                shiptoPlace = self.ship2!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: -3.3, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.engine!)
                               }else if randomShip == "ship3"{
                                shiptoPlace = self.ship3!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(x: -4, y: 0, z: 4)
                                sound = SCNAudioPlayer(source: self.horn2!)
                               }else if randomShip == "ship4" {
                                shiptoPlace = self.ship4!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90),z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0.2, 6)
                                sound = SCNAudioPlayer(source: self.horn!)
                            }else if randomShip == "ship5" {
                                shiptoPlace = self.ship5!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0, 6)
                                sound = SCNAudioPlayer(source: self.pirateSound!)
                            }else if randomShip == "ship6" {
                                shiptoPlace = self.ship6!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0, 6)
                                sound = SCNAudioPlayer(source: self.gongSound!)
                            }else if randomShip == "ship7" {
                                shiptoPlace = self.ship7!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0, 6)
                                sound = SCNAudioPlayer(source: self.woodSound2!)
                            }else if randomShip == "ship8" {
                                shiptoPlace = self.ship8!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0, 6)
                                sound = SCNAudioPlayer(source: self.woodSound!)
                            }else if randomShip == "ship9" {
                                shiptoPlace = self.ship9!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0.5, 6)
                                sound = SCNAudioPlayer(source: self.woodSound2!)
                                if mapToShow == "egypt" {
                                shiptoPlace.position.y = 0.0
                                }
                            }else if randomShip == "ship10" {
                                shiptoPlace = self.ship10!
                                shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 90), z: 0)
                                shiptoPlace.position = SCNVector3(-4, 0.5, 6)
                                sound = SCNAudioPlayer(source: self.woodSound2!)
                            }

                                if Int.random(in: 0...5) == 2{
                                        self.scene.rootNode.addAudioPlayer(sound)
                                            }
                               shiptoPlace.light?.color = UIColor.black
                               shiptoPlace.physicsBody = SCNPhysicsBody()
                               shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.boat1
                                if randomShip != "ship10" {
                                    shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.boat2|physicsBodies.box|physicsBodies.box2
                                }else {
                                    shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.box|physicsBodies.box2
                                                    }
                               shiptoPlace.removeAllActions()
                               shiptoPlace.runAction(self.moveAction)
                               shiptoPlace.flattenedClone()
                               self.mapNode3.addChildNode(shiptoPlace.clone())
         
                           }
                       }
                   })
                   
        timer4 = Timer.scheduledTimer(withTimeInterval: interval * 1.1 , repeats: true, block: { (timer) in
                           var shiptoPlace = SCNNode()
                           var sound : SCNAudioPlayer!
                           let bool = Bool.random()
                               if self.gameState == .playing && self.paused == false && self.mapNode2.childNodes.count < 3 && bool  {
                                var randomShip = shipNumbersArray.randomElement()
                                if themeOnly {
                                switch mapToShow {
                                case "containerPort":
                                randomShip = "ship1"
                                case "pirateMap":
                                randomShip = "ship5"
                                case "middleAgeMap":
                                randomShip = "ship8"
                                case "chinaMap":
                                randomShip = "ship6"
                                case "egypt":
                                randomShip = "ship9"
                                default:
                                break
                                        }
                                    }
                                   if randomShip == "ship1" {
                                    shiptoPlace = self.ship!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -13.5)
                                    sound = SCNAudioPlayer(source: self.horn2!)
                                   }else if randomShip  == "ship2" {
                                    shiptoPlace = self.ship2!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -14)
                                    sound = SCNAudioPlayer(source: self.engine!)
                                   }else if randomShip == "ship3" {
                                    shiptoPlace = self.ship3!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0,y: self.toRadians(angle: 180),z: 0)
                                    shiptoPlace.position = SCNVector3(x: -17, y: 0, z: -14.0)
                                    sound = SCNAudioPlayer(source: self.horn!)
                                }else if randomShip == "ship4"{
                                    shiptoPlace = self.ship4!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180),z: 0)
                                    shiptoPlace.position = SCNVector3(-19, 0.2, -13.5)
                                    sound = SCNAudioPlayer(source: self.horn!)
                                }else if randomShip == "ship5" {
                                    shiptoPlace = self.ship5!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0, -14)
                                    sound = SCNAudioPlayer(source: self.pirateSound!)
                                }else if randomShip == "ship6" {
                                    shiptoPlace = self.ship6!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0, -14)
                                    sound = SCNAudioPlayer(source: self.gongSound!)
                                }else if randomShip == "ship7" {
                                    shiptoPlace = self.ship7!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0, -14)
                                    sound = SCNAudioPlayer(source: self.woodSound!)
                                }else if randomShip == "ship8" {
                                    shiptoPlace = self.ship8!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0, -14)
                                    sound = SCNAudioPlayer(source: self.woodSound2!)
                                }else if randomShip == "ship9" {
                                    shiptoPlace = self.ship9!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0.5, -14)
                                    sound = SCNAudioPlayer(source: self.woodSound!)
                                    if mapToShow == "egypt" {
                                    shiptoPlace.position.y = 0.0
                                    }
                                }
                                else if randomShip == "ship10" {
                                    shiptoPlace = self.ship10!
                                    shiptoPlace.eulerAngles = SCNVector3(x: 0, y: -self.toRadians(angle: 180), z: 0)
                                    shiptoPlace.position = SCNVector3(-22, 0.5, -14)
                                    sound = SCNAudioPlayer(source: self.woodSound!)
                                }
                                if Int.random(in: 0...5) == 2{
                                        self.scene.rootNode.addAudioPlayer(sound)
                                            }
                                   shiptoPlace.light?.color = UIColor.black
                                   shiptoPlace.physicsBody = SCNPhysicsBody()
                                   if randomShip != "ship10" {
                                   shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.boat2
                                    
                                }else {
                                    shiptoPlace.physicsBody?.categoryBitMask = physicsBodies.ghost
                                }
                                   shiptoPlace.physicsBody?.contactTestBitMask = physicsBodies.box2
                                   shiptoPlace.removeAllActions()
                                   shiptoPlace.runAction(self.moveActionRight)
                                   shiptoPlace.flattenedClone()
                                   self.mapNode2.addChildNode(shiptoPlace.clone())
                           }
                       })
               }
    
    func gameOver() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(score, forKey: "HighScore")
                }
                gameState = .gameOver
                goToRetryScene()
            }
}

extension GameViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .playing {
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = sceneView.bounds
            // if pauseButton was pressed
        for touch in touches {
            let location = touch.location(in: sceneView)
            //PortLights
            if location.x < sceneView.frame.midX && !paused{
                trafficLightLeftRed?.isHidden = false
                trafficLightLeftGreen?.isHidden = true
                touchActive = true
                for child in mapNode3.childNodes {

                    if child.position.z > trafficLightLeftRed!.position.z + 2.5{child.isPaused = true}
                }

        }else if location.x > sceneView.frame.midX && !paused{
                trafficLightRightRed?.isHidden = false
                trafficLightRightGreen?.isHidden = true
                touchActive2 = true
                for child in mapNode.childNodes {
                    if child.position.z > trafficLightLeftRed!.position.z + 2.5{child.isPaused = true}
                    }
                }
            }
        }
    }
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState == .playing {
        for touch in touches {
            let location = touch.location(in: sceneView)
               if location.x < sceneView.frame.midX && !paused{
                              trafficLightLeftRed?.isHidden = true
                              trafficLightLeftGreen?.isHidden = false
                              touchActive = false
                for child in mapNode3.childNodes {
                    child.isPaused = false
                }
                                             }else if location.x > sceneView.frame.midX && !paused{
                              trafficLightRightRed?.isHidden = true
                              trafficLightRightGreen?.isHidden = false
                              touchActive2 = false
                for child in mapNode.childNodes {child.isPaused = false
                }
               }
            }
    
        }else if gameState == .menu && !info{
            cameraNode.runAction(cameraAction)
            switch gameState {
                       case .menu:
                          gameState = .playing
                          gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
                          sceneView.overlaySKScene = gameHUD
                          sceneView.overlaySKScene?.isUserInteractionEnabled = false
                          setUpPauseButton()
                          boats()

                          addBox()
                          if volume {
                          if mapToShow == "containerPort" && volume{
                          let hornNoise = SCNAudioPlayer(source: horn3!)
                          sceneView.scene?.rootNode.addAudioPlayer(hornNoise)
                          }else if mapToShow == "chinaMap" {
                          let gong = SCNAudioPlayer(source: gongSound!)
                          scene.rootNode.addAudioPlayer(gong)
                          }else if mapToShow == "middleAgeMap"{
                            let sound = SCNAudioPlayer(source: medievalImpact!)
                            scene.rootNode.addAudioPlayer(sound)
                          }else if mapToShow == "pirateMap" {
                            let sound = SCNAudioPlayer(source: shipBell!)
                            scene.rootNode.addAudioPlayer(sound)
                          }
                        }
                       default:
                           break
            }
        }else if gameState == .menu && info {
            gameHUD.infoNode.removeFromParent()
            info = false
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
}

extension GameViewController : SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
           guard let categoryA = contact.nodeA.physicsBody?.categoryBitMask, let categoryB = contact.nodeB.physicsBody?.categoryBitMask else {
               return
                    }
        
           let mask = categoryA | categoryB
           
           switch mask {
            case physicsBodies.boat2 | physicsBodies.boat1:
            gameOver()
                if volume{
            let crashNoise = SCNAudioPlayer(source: crash!)
            sceneView.scene!.rootNode.addAudioPlayer(crashNoise)}
                    for child in self.mapNode2.childNodes {
                    child.isPaused = false
                    child.removeAllActions()
                    child.runAction(self.deathAnimation)
                               }
                    for child in self.mapNode.childNodes {
                    child.isPaused = false
                    child.removeAllActions()
                        child.runAction(self.deathAnimation)
                               }
                    for child in self.mapNode3.childNodes {
                    child.isPaused = false
                    child.removeAllActions()
                    child.runAction(self.deathAnimation)
                    }
            case physicsBodies.boat1 | physicsBodies.box:
                 let portcoinSequence = SKAction.sequence([portcoinaction1, portcoinaction2])
                self.score += 1
                 contact.nodeB.removeFromParentNode()
             let bellnoise = SCNAudioPlayer(source: bell!)
             if volume {
             scene.rootNode.addAudioPlayer(bellnoise)}
                moveAction.speed *= 1.03
                 moveActionRight.speed *= 1.03
                 if difficulty == 0{
                    if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                        self.coinsInGame += 2
                    }else {
                        self.coinsInGame += 1}
                    }else if difficulty == 1{
                if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                     self.coinsInGame += 4
                 }else {
                     self.coinsInGame += 2}
                 }else if difficulty == 2 {
                 if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                     self.coinsInGame += 6
                 }else {
                     self.coinsInGame += 3}
                 }
                let action = SKAction.scale(to: 1.2, duration: 0.2)
                let action2 = SKAction.scale(to: 1, duration: 0.2)
                self.gameHUD.portCoinImage2.run(portcoinSequence)
                self.gameHUD.pointsLabel?.run(SKAction.sequence([action,action2]))
                 self.gameHUD.coinsLabel?.text = "\(self.coinsInGame)"
                 self.gameHUD.pointsLabel?.text = "\(self.score)"
            
            
           case physicsBodies.boat1 | physicsBodies.box2:
            contact.nodeB.removeFromParentNode()
            let portcoinSequence = SKAction.sequence([portcoinaction1, portcoinaction2])
            self.score += 1
            let bellnoise = SCNAudioPlayer(source: bell!)
            if volume {
             scene.rootNode.addAudioPlayer(bellnoise)}
                moveAction.speed *= 1.03
                moveActionRight.speed *= 1.03
            if difficulty == 0{
            
                if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                    self.coinsInGame += 2
                }else {
                    self.coinsInGame += 1}
                }else if difficulty == 1{
                  if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                      self.coinsInGame += 4
                }else {
                    self.coinsInGame += 2}
                }else if difficulty == 2 {
                  if contact.nodeA.name == "ship4" || contact.nodeB.name == "ship4"{
                      self.coinsInGame += 6
                }else {
                        self.coinsInGame += 3}
                }
                let action = SKAction.scale(to: 1.2, duration: 0.2)
                let action2 = SKAction.scale(to: 1, duration: 0.2)
                self.gameHUD.pointsLabel?.run(SKAction.sequence([action,action2]))
                self.gameHUD.portCoinImage2.run(portcoinSequence)
                 self.gameHUD.coinsLabel?.text = "\(self.coinsInGame)"
                 self.gameHUD.pointsLabel?.text = "\(self.score)"
            
           case physicsBodies.boat2 | physicsBodies.box:
            contact.nodeB.removeFromParentNode()
           case physicsBodies.boat2 | physicsBodies.box2:
            contact.nodeB.removeFromParentNode()
            case physicsBodies.ghost | physicsBodies.box:
             contact.nodeB.removeFromParentNode()
             print("lul")
            case physicsBodies.ghost | physicsBodies.box2:
             contact.nodeB.removeFromParentNode()
            print("lul")
           default:
            break
        }
            }
}


extension GameViewController {
    // Skoverlay
    func setUpPauseButton() {
        let pauseButtonTexture = SKTexture(image: pauseImage!)
        let pauseButton = SpriteKitButton(defaultButtonImage: pauseButtonTexture, action: pauseGame)
        pauseButton.scale(to: CGSize(width: 50, height: 50))
        pauseButton.position = CGPoint(x: gameHUD.frame.maxX - pauseButton.frame.width, y: gameHUD.frame.maxY - pauseButton.frame.height)
        gameHUD.addChild(pauseButton)
    }
    
    func setUpResetScene() {
        
        
        
        let homeButtonTexture = SKTexture(image: homeImage!)
        let settingButtontexture = SKTexture(image: settingsImage!)
        let shopButtonTexture = SKTexture(image: shopImage!)
                
        let homeButton = SpriteKitButton(defaultButtonImage: homeButtonTexture, action: resetGame)
        let settingsButton = SpriteKitButton(defaultButtonImage: settingButtontexture, action: goToSettings)
        let shopButton = SpriteKitButton(defaultButtonImage: shopButtonTexture, action: goToShop)
        shopButton.zPosition = 3
        homeButton.setScale(0.1)
        settingsButton.setScale(0.1)
        shopButton.setScale(0.1)
        
        shopButton.position = CGPoint(x: gameHUD.frame.maxX, y: gameHUD.frame.midY - shopButton.frame.height * 2 )
        homeButton.position = CGPoint(x: gameHUD.frame.maxX, y: gameHUD.frame.midY - homeButton.frame.height * 4)
        settingsButton.position = CGPoint(x: gameHUD.frame.maxX - settingsButton.frame.width, y: gameHUD.frame.minY + settingsButton.frame.height)
        
        shopButton.run(SKAction.moveTo(x: gameHUD.frame.minX + shopButton.frame.width, duration: 0.6))
        homeButton.run(SKAction.moveTo(x: gameHUD.frame.minX + homeButton.frame.width, duration: 0.6))
        
        shopButton.run(SKAction.scale(by: 1.7, duration: 0.5))
        homeButton.run(SKAction.scale(by: 1.7, duration: 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            shopButton.run(SKAction.scale(by: 0.7, duration: 0.5))
            homeButton.run(SKAction.scale(by: 0.7, duration: 0.5))
        }
        
        let boxRect = CGRect(x: gameHUD.frame.maxX, y:shopButton.position.y - shopButton.frame.height/1.5, width: gameHUD.frame.width, height: 50)
        let box = SKShapeNode(rect: boxRect)
        box.strokeColor = UIColor.systemTeal
        box.alpha = 0.9
        box.fillColor = UIColor.systemTeal

        box.run(SKAction.moveBy(x: -gameHUD.frame.width, y: 0, duration: 0.5))
        
        let boxRect2 = CGRect(x: gameHUD.frame.maxX, y: homeButton.position.y - homeButton.frame.height/1.5, width: gameHUD.frame.width, height: 50)
        let box2 = SKShapeNode(rect: boxRect2)
        box2.strokeColor = UIColor.systemTeal
        box2.fillColor = UIColor.systemTeal
        box2.alpha = 0.9
        box2.run(SKAction.moveBy(x: -gameHUD.frame.width, y: 0, duration: 0.5))
        
        let ButtonAction = SKAction.rotate(toAngle: 0.1, duration: 1)
        let ButtonAction2 = SKAction.rotate(toAngle: -0.1, duration: 1)
        let buttonSequence = SKAction.sequence([ButtonAction, ButtonAction2])
        homeButton.run(SKAction.repeatForever(buttonSequence))
        shopButton.run(SKAction.repeatForever(buttonSequence))
        
        
        gameHUD.resetLabel.text = "Try Again \n Score: \(score)"
        gameHUD.resetLabel.numberOfLines = 0;
    /*
        let rewardButtonTexture = SKTexture(image: earnPortCoinsButtonImage!)
      //  rewardButton = SpriteKitButton(defaultButtonImage: rewardButtonTexture, action: nothing)
      //  rewardButton.setScale(0.18)
       // rewardButton.position.x = gameHUD.frame.minX + rewardButton.frame.width/1.3
        DispatchQueue.main.async {
            if self.sceneView.frame.height > 800 {
                self.rewardButton.position.y = self.gameHUD.frame.maxY - self.rewardButton.frame.height * 1.5
            }else {
                self.rewardButton.position.y = self.gameHUD.frame.maxY - self.rewardButton.frame.height
            }
        }
        
        if canWatchRewardVideo {
            rewardButton.alpha = 1
        }else {
            rewardButton.alpha = 0.75
        }
        
        
        rewardButton.run(SKAction.repeatForever(buttonSequence))
     */
            if self.score > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    portCoins += self.coinsInGame
                    UserDefaults.standard.set(portCoins, forKey: "PortCoins")
                    let money = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
                    let moneySound = SCNAudioPlayer(source: money!)
                    self.sceneView.scene?.rootNode.addAudioPlayer(moneySound)
                    self.portCoinLabel.text = "\(UserDefaults().integer(forKey: "PortCoins"))"
                    self.score = 0
                }
            }

        portCoinLabel = SKLabelNode(fontNamed: "Retro Gaming")
        portCoinLabel.fontColor = UIColor.white
        portCoinLabel.fontSize = 50.0
        addjustCoinLabel()
        gameHUD.addChild(portCoinLabel)


        portCoinLabel.zPosition = 1
   //     gameHUD.addChild(rewardButton)
        gameHUD.addChild(box)
        gameHUD.addChild(box2)
        gameHUD.addChild(homeButton)
        gameHUD.addChild(settingsButton)
        gameHUD.addChild(shopButton)
        
    }
    
    func nothing(){
        
    }
    func goToSettings() {
                if volume {
                    let clickNoise = SCNAudioPlayer(source: click!)
                    scene.rootNode.addAudioPlayer(clickNoise)
                }
               gameState = .settings
               gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
               sceneView.overlaySKScene = gameHUD
               sceneView.overlaySKScene?.isUserInteractionEnabled = false
               setUpSettingScene()
        
    }
    
    func setUpSettingScene() {
       

        let goBackTexture = SKTexture(image: goBackImage!)
        let goBackButton = SpriteKitButton(defaultButtonImage: goBackTexture, action: goBack)
        goBackButton.setScale(CGFloat(0.10))
        goBackButton.position = CGPoint(x: gameHUD.frame.minX + goBackButton.frame.width/1.1, y: gameHUD.frame.maxY - goBackButton.frame.height * 1.2)
        gameHUD.addChild(goBackButton)
        
        let volumeOnButtonTexture = SKTexture(image: volumeImageON!)
        let volumeOffButtonTexture = SKTexture(image: volumeImageOff!)
        let difficultyEasy = SKTexture(image: easy!)
        let difficultyMedium = SKTexture(image: medium!)
        let difficultyPortMaster = SKTexture(image: portMaster!)
        let aboutButtonTexture = SKTexture(image: aboutButtonImage!)
        
        
        let volumeOnButton = SpriteKitButton(defaultButtonImage: volumeOnButtonTexture, action: SwitchVolume)
        let volumeOffButton = SpriteKitButton(defaultButtonImage: volumeOffButtonTexture, action: SwitchVolume)
        let easyButton = SpriteKitButton(defaultButtonImage: difficultyEasy, action: changeDifficulty)
        let mediumButton = SpriteKitButton(defaultButtonImage: difficultyMedium, action: changeDifficulty)
        let portMasterButton = SpriteKitButton(defaultButtonImage: difficultyPortMaster, action: changeDifficulty)
        volumeOnButton.scale(to: CGSize(width: 50, height: 50))
        volumeOffButton.scale(to: CGSize(width: 35, height: 35))
        volumeOnButton.position  = CGPoint(x: gameHUD.frame.midX + sceneView.frame.width/7, y: gameHUD.frame.midY)
        volumeOffButton.position = CGPoint(x: gameHUD.frame.midX + sceneView.frame.width/7, y: gameHUD.frame.midY)
        
        if difficulty == 0 {
        gameHUD.addChild(easyButton)
        easyButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        easyButton.scale(to: CGSize(width: 150, height: 70))
        easyButton.zPosition = 10
        labelforDifficulty.text = "(1x Portcoins)"
            
        }else if difficulty == 1 {
        gameHUD.addChild(mediumButton)
        mediumButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        mediumButton.scale(to: CGSize(width: 150, height: 70))
        mediumButton.zPosition = 10
        labelforDifficulty.text = "(2x Portcoins)"
            
        }else if difficulty == 2 {
        gameHUD.addChild(portMasterButton)
        portMasterButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        portMasterButton.scale(to: CGSize(width: 150, height: 70))
        portMasterButton.zPosition = 10
        labelforDifficulty.text = "(3x Portcoins)"
        }
        labelforDifficulty.fontSize = 15.0
        labelforDifficulty.fontColor = UIColor.white
        labelforDifficulty.position.x = gameHUD.frame.midX + labelforDifficulty.frame.width/1.6
        labelforDifficulty.position.y = gameHUD.frame.midY - labelforDifficulty.frame.height * 12
        gameHUD.addChild(labelforDifficulty)
        gameHUD.addChild(volumeOnButton)
        gameHUD.addChild(volumeOffButton)
        if volume {
            volumeOffButton.isHidden = true
            volumeOnButton.isHidden = false
        }else if !volume {
            volumeOnButton.isHidden = true
            volumeOffButton.isHidden = false
        }
        
        
        let restoreTexture = SKTexture(image: restorePurchasesButtonImage!)
        restoreButton = SpriteKitButton(defaultButtonImage: restoreTexture, action: restorePurchases)
        restoreButton.setScale(0.15)
        restoreButton.position = CGPoint(x: gameHUD.frame.midX - restoreButton.frame.width * 1.2, y: gameHUD.frame.midY - restoreButton.frame.height * 4)
        gameHUD.addChild(restoreButton)
        
    }

    func goToShop() {
        gameState = .shopMenu
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        sceneView.overlaySKScene?.isUserInteractionEnabled = false
        if volume {
            let clickNoise = SCNAudioPlayer(source: click!)
            sceneView.scene!.rootNode.addAudioPlayer(clickNoise)
        }
        let shipShopButtonTexture = SKTexture(image: shopImage!)
        let shipShopButton = SpriteKitButton(defaultButtonImage: shipShopButtonTexture, action: goToShopShips)
        let mapShopButtonTexture = SKTexture(image: maps!)
        let mapShopButton = SpriteKitButton(defaultButtonImage: mapShopButtonTexture, action: goToShopMaps)
        let goBackTexture = SKTexture(image: goBackImage!)
        let goBackButton = SpriteKitButton(defaultButtonImage: goBackTexture, action: goBack)
        goBackButton.setScale(CGFloat(0.10))
        goBackButton.position = CGPoint(x: gameHUD.frame.minX + goBackButton.frame.width, y: gameHUD.frame.maxY - goBackButton.frame.height * 1.2)
        gameHUD.addChild(goBackButton)
        shipShopButton.setScale(CGFloat(0.2))
        mapShopButton.setScale(CGFloat(0.2))
        
        shipShopButton.position.x = gameHUD.frame.midX - shipShopButton.frame.width/1.5
        shipShopButton.position.y = gameHUD.frame.midY
        mapShopButton.position.x = gameHUD.frame.midX + mapShopButton.frame.width/1.5
        mapShopButton.position.y = gameHUD.frame.midY
        
        let ButtonAction = SKAction.rotate(toAngle: 0.1, duration: 1)
        let ButtonAction2 = SKAction.rotate(toAngle: -0.1, duration: 1)
        let buttonSequence = SKAction.sequence([ButtonAction, ButtonAction2])
        shipShopButton.run(SKAction.repeatForever(buttonSequence))
        mapShopButton.run(SKAction.repeatForever(buttonSequence))
        

        
        gameHUD.addChild(shipShopButton)
        gameHUD.addChild(mapShopButton)

        
    }
    func goToShopMaps() {
        
        shopShips = false
        gameState = .shopMaps
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        sceneView.overlaySKScene?.isUserInteractionEnabled = false
        sceneView.allowsCameraControl = false
        if volume {
            let clickNoise = SCNAudioPlayer(source: click!)
            sceneView.scene!.rootNode.addAudioPlayer(clickNoise)
                             }
        addGestures()
        let goBackTexture = SKTexture(image: goBackImage!)
        let goBackButton = SpriteKitButton(defaultButtonImage: goBackTexture, action: goBack)
        goBackButton.setScale(CGFloat(0.10))
        goBackButton.position = CGPoint(x: gameHUD.frame.minX + goBackButton.frame.width, y: gameHUD.frame.maxY - goBackButton.frame.height * 1.2)
        gameHUD.addChild(goBackButton)
        sceneView.present(shopMapsScene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
        shopMapsScene.background.contents = UIColor.systemTeal
        shopCamera.camera = SCNCamera()
        shopCamera.position = SCNVector3(0, 1, 18)
        shopCamera.eulerAngles = SCNVector3(-toRadians(angle: 40), 0, 0)
        
        shopMapsScene.rootNode.addChildNode(shopCamera)
        for map in SCNScene(named: "art.scnassets/maps/ContainerPortHall.scn")!.rootNode.childNodes {
            map.position = SCNVector3(0.4, 0, 0)
            shopMapsScene.rootNode.addChildNode(map)
            map.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 12)))
            map.scale = SCNVector3(0.15, 0.15, 0.15)
            map.position.z += 9.5
            map.position.y -= 7
            map.light?.castsShadow = true
            map.flattenedClone()
            if !mapNumbersArray.contains("containerPort") {
                map.opacity = 0.75
            }

        }
        for map in SCNScene(named: "art.scnassets/maps/pirateMap/pirateMapHall.scn")!.rootNode.childNodes {
            map.position = SCNVector3(15, 0, 0)
            shopMapsScene.rootNode.addChildNode(map)
            map.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 12)))
            map.scale = SCNVector3(0.15, 0.15, 0.15)
            map.position.z += 9.5
            map.position.y -= 7
            map.light?.castsShadow = true
            map.flattenedClone()
            if !mapNumbersArray.contains("pirateMap") {
                map.opacity = 0.75
            }
        }
        
        for map in SCNScene(named: "art.scnassets/maps/middleAgeMap/middleAgeMap.scn")!.rootNode.childNodes {
            map.position = SCNVector3(30, 0, 0)
            shopMapsScene.rootNode.addChildNode(map)
            map.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 12)))
            map.scale = SCNVector3(0.15, 0.15, 0.15)
            map.position.z += 9.5
            map.position.y -= 7
            map.light?.castsShadow = true
            map.flattenedClone()
            if !mapNumbersArray.contains("middleAgeMap") {
                map.opacity = 0.75
            }
        }
        for map in SCNScene(named: "art.scnassets/maps/china map/chinaMapHall.scn")!.rootNode.childNodes {
            map.position = SCNVector3(45, 0, 0)
            shopMapsScene.rootNode.addChildNode(map)
            map.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 12)))
            map.scale = SCNVector3(0.15, 0.15, 0.15)
            map.position.z += 9.5
            map.position.y -= 7
            map.light?.castsShadow = true
            if !mapNumbersArray.contains("chinaMap") {
                map.opacity = 0.75
            }
        }
        for map in SCNScene(named: "art.scnassets/maps/egypt/egyptHall.scn")!.rootNode.childNodes {
            map.position = SCNVector3(60, 0, 0)
            shopMapsScene.rootNode.addChildNode(map)
            map.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 12)))
            map.scale = SCNVector3(0.15, 0.15, 0.15)
            map.position.z += 9.5
            map.position.y -= 7
            map.light?.castsShadow = true
            map.flattenedClone()
            if !mapNumbersArray.contains("egypt") {
                map.opacity = 0.75
            }
        }
       
        }
    
    func goToShopShips() {
               
               shopShips = true
               gameState = .shopShips
               gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
               sceneView.overlaySKScene = gameHUD
               sceneView.overlaySKScene?.isUserInteractionEnabled = false
               if volume {
                          let clickNoise = SCNAudioPlayer(source: click!)
                          sceneView.scene!.rootNode.addAudioPlayer(clickNoise)

                      }
                
                
                addGestures()
                let goBackTexture = SKTexture(image: goBackImage!)
                let goBackButton = SpriteKitButton(defaultButtonImage: goBackTexture, action: goBack)
                goBackButton.setScale(CGFloat(0.10))
                goBackButton.position = CGPoint(x: gameHUD.frame.minX + goBackButton.frame.width, y: gameHUD.frame.maxY - goBackButton.frame.height * 1.2)
                gameHUD.addChild(goBackButton)
                sceneView.present(shopScene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
                shopScene.background.contents = UIColor.systemTeal
                shopCamera.camera = SCNCamera()
                shopCamera.eulerAngles = SCNVector3(0, 0, 0)
                shopCamera.position = SCNVector3(0, 5, 11)
                shopLight.light = SCNLight()
                shopLight.light?.type = .directional
                shopLight.position = shopCamera.position
                shopScene.rootNode.addChildNode(shopLight)
                shopScene.rootNode.addChildNode(shopCamera)
               
                
            let shopNodes = [ship,ship2,ship3,ship4,ship5,ship6,ship7,ship8,ship9,ship10]
            var shopPosition = SCNVector3(0, 4, 0)
            for shipInShop in shopNodes {
            shipInShop?.flattenedClone()
            shipInShop?.removeAllActions()
            shipInShop?.position = shopPosition
            shipInShop?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 3)))
            shopPosition.x += 8
            shopScene.rootNode.addChildNode(shipInShop!.clone())
            
                
                shopScene.rootNode.enumerateChildNodes { (node, _) in
                    if node.hasActions{
                if !shipNumbersArray.contains(node.name!){
                        if node.name != "ship10" {
                        node.opacity = 0.5
                            
                    }else {
                        node.opacity = 0.6
                    }
                        }
                    }
                }
        }
       
        
                
    }
    
    func addGestures(){
        swipeGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(swipe1(_:)))
        sceneView.addGestureRecognizer(swipeGesture1)
        swipeGesture1.direction = .left
        swipeGesture2 = UISwipeGestureRecognizer(target: self, action: #selector(swipe2(_:)))
        sceneView.addGestureRecognizer(swipeGesture2)
        swipeGesture2.direction = .right
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(touch))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    
     func goBack() {
        
        var needMusic : Bool!

        sceneView.removeGestureRecognizer(tapGesture)
        sceneView.removeGestureRecognizer(swipeGesture1)
        sceneView.removeGestureRecognizer(swipeGesture2)
        if volume {
        let clickNoise = SCNAudioPlayer(source: self.click!)
        self.sceneView.scene?.rootNode.addAudioPlayer(clickNoise)}
        
        if gameState == .shopMenu{
        gameState = .loading
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        gameState = .shopMenu
        needMusic = false
        }else if gameState == .shopShips{
        gameState = .loading
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        gameState = .shopShips
        needMusic = true
        }else if gameState == .shopMaps{
        gameState = .loading
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        gameState = .shopMaps
        needMusic = true
        }else if gameState == .settings{
        gameState = .loading
        gameHUD = GameHUD(with: sceneView.bounds.size, gameState: self.gameState)
        sceneView.overlaySKScene = gameHUD
        gameState = .settings
        needMusic = false
        }
        
        for child in gameHUD.children {
            if child.position.x > gameHUD.frame.midX {
                child.run(SKAction.moveTo(x: gameHUD.frame.midX, duration: 1.0))
            }
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
           
            switch self.gameState {
                case .shopMenu:
                self.gameState = .reset
                self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
                self.sceneView.overlaySKScene = self.gameHUD
                self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
                self.sceneView.allowsCameraControl = false
                self.setUpResetScene()
                
                
                case . shopShips:
                self.gameState = .shopMenu
                self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
                self.sceneView.overlaySKScene = self.gameHUD
                self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
                self.goToShop()
                self.shopScene.rootNode.enumerateChildNodes { (node, _) in

                  node.removeFromParentNode()
                  node.removeAllAudioPlayers()
                  }
                case .shopMaps:
                self.gameState = .shopMenu
                self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
                self.sceneView.overlaySKScene = self.gameHUD
                self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
                self.goToShop()
                for node in self.mapNode5.childNodes {
                    node.removeFromParentNode()
                }
                for node in self.shopMapsScene.rootNode.childNodes {
                    node.removeFromParentNode()
                }
                self.craneArm?.removeAllActions()
                self.gabelStabler.removeAllActions()
                self.setupPort()
                
                case .settings:
                self.gameState = .reset
                self.gameHUD = GameHUD(with: self.sceneView.bounds.size, gameState: self.gameState)
                self.sceneView.overlaySKScene = self.gameHUD
                self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
                self.setUpResetScene()
                default:
                break
            }
        
            self.sceneView.present(self.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
            if needMusic  {
                self.addMusic()}
 
        }
            
        

    }
    func setupShopButtonsMaps() {
    
        let selectButtonTexture = SKTexture(image: selectButton!)
        let selectedButtonTexture = SKTexture(image: selectedButton!)
        
        let selectButton = SpriteKitButton(defaultButtonImage: selectButtonTexture, action: selectPort)
        let selectedButtonButton  = SpriteKitButton(defaultButtonImage: selectedButtonTexture, action: selectPort)
      
        selectButton.setScale(CGFloat(0.15))
        selectedButtonButton.setScale(CGFloat(0.15))
        selectButton.zPosition = 10
        selectedButtonButton.zPosition = 10
        selectButton.position.y = gameHUD.frame.minY + selectButton.frame.height
        selectButton.position.x = gameHUD.frame.midX
        selectedButtonButton.position = selectButton.position
        
        if mapToShow == NodeInShopName {
        selectButton.isHidden = true
        selectedButtonButton.isHidden = false
            
        }else if mapToShow != NodeInShopName {
        selectedButtonButton.isHidden = true
        selectButton.isHidden = false
        }
        gameHUD.addChild(selectButton)
        gameHUD.addChild(selectedButtonButton)
    }
    func selectPort() {
        if mapToShow != NodeInShopName {
        for child in gameHUD.children {
            if child.position.x == gameHUD.frame.midX && child.position.y < gameHUD.frame.midY - 100{
                if child.isHidden == true{
                    child.isHidden = false
                }else if child.isHidden == false {
                    child.isHidden = true
                }
            }
        }
        }
        mapToShow = NodeInShopName
        UserDefaults.standard.set(mapToShow, forKey: "MapToShow")
    }

    
    func buyInShop() {
        
         switch shopShips {
         case true:
         if NodeInShopName == "ship1" {
             price = 0
         }else if NodeInShopName == "ship2" {
             price = 100
         }else if NodeInShopName == "ship3"{
             price = 500
         }else if NodeInShopName == "ship5" {
            price = 200
         }else if NodeInShopName == "ship6"{
            price = 500
         }else if NodeInShopName == "ship7"{
            price = 700
         }else if NodeInShopName == "ship8"{
            price = 200
         }else if NodeInShopName == "ship9"{
            price = 500
         }else if NodeInShopName == "ship10"{
            price = 1200
        
         }
        
         if portCoins > price || portCoins == price {
             portCoins -= price
                   
                if volume {
                let moneySound = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
                let money = SCNAudioPlayer(source: moneySound!)
                sceneView.scene?.rootNode.addAudioPlayer(money)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if !shipNumbersArray.contains("ship4") && !mapNumbersArray.contains("egypt"){
                  //   self.presentInterstitial()
                        
                    }
                   }
             }
             for child in gameHUD.children{
                if child.zPosition == 3 || child.zPosition == 4 {
                    child.removeFromParent()
                }
            }
            
             UserDefaults.standard.set(portCoins, forKey: "PortCoins")
             shipNumbersArray.append(NodeInShopName)
             UserDefaults.standard.set(shipNumbersArray, forKey: "ShipsArray")
             if let shipInScene = sceneView.scene?.rootNode.childNode(withName: NodeInShopName, recursively: true){
                shipInScene.opacity = 1.0
                shipInScene.runAction(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 2))
            }
            
     
    }
         case false:
            if NodeInShopName == "pirateMap" {
                 price = 700
            }else if NodeInShopName == "middleAgeMap"{
                price = 700
            }else if NodeInShopName == "chinaMap"{
                price = 700
            }
            
              if portCoins > price || portCoins == price {
                     for child in gameHUD.children {
                        if child.zPosition == 3{
                            child.removeFromParent()
                            setupShopButtonsMaps()
                        }
                }
                     portCoins -= price
                     UserDefaults.standard.set(portCoins, forKey: "PortCoins")
                     mapNumbersArray.append(NodeInShopName)
                     UserDefaults.standard.set(mapNumbersArray, forKey: "MapsArray")
                     for mapInScene in shopMapsScene.rootNode.childNodes{
                        if mapInScene.name == NodeInShopName{
                            mapInScene.opacity = 1.0}
                     }
                         
                      if volume {
                      let moneySound = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
                      let money = SCNAudioPlayer(source: moneySound!)
                      sceneView.scene?.rootNode.addAudioPlayer(money)}
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                      if !shipNumbersArray.contains("ship4") && !mapNumbersArray.contains("egypt"){
                     // self.presentInterstitial()
                        
                        }
                      }
              }
         default:
         break
             
     }
                 for child in gameHUD.children {
                     if child.position.x == gameHUD.frame.midX && child.position.y == gameHUD.frame.midY{
                         if child.isHidden{child.isHidden = false}
                         else if !child.isHidden{
                             child.removeFromParent()
                         }

                         
                 }
             }
         
     }
    
    
    
    
    
    func addjustCoinLabel() {

        if portCoins < 10 {
            portCoinLabel.position = CGPoint(x: gameHUD.frame.maxX  - gameHUD.frame.width/3.0 , y: gameHUD.frame.maxY - gameHUD.frame.height/9 )
        }else if portCoins > 10  && portCoins < 100 || portCoins == 10{
            portCoinLabel.position = CGPoint(x: gameHUD.frame.maxX  - gameHUD.frame.width/2.7 , y: gameHUD.frame.maxY - gameHUD.frame.height/9 )
        }else if portCoins > 100  && portCoins < 1000 || portCoins == 100 {
            portCoinLabel.position = CGPoint(x: gameHUD.frame.maxX  - gameHUD.frame.width/2.5 , y: gameHUD.frame.maxY - gameHUD.frame.height/9 )
        }else if portCoins == 1000 || portCoins > 1000 {
            portCoinLabel.position = CGPoint(x: gameHUD.frame.maxX  - gameHUD.frame.width/2.2 , y: gameHUD.frame.maxY - gameHUD.frame.height/9 )
        }
        self.portCoinLabel.text = "\(UserDefaults().integer(forKey: "PortCoins"))"


    }
    
    func buyButton() {
        let buyButtonTexture500 = SKTexture(image: BuyButtonImage500!)
        let buyButtonTexture700 = SKTexture(image: BuyButtonImage700!)
        let buyButtonTexture100 = SKTexture(image: BuyButtonImage100!)
        let buyButtonTexture200 = SKTexture(image: BuyButtonImage200!)
        let buyButtonTexture1200 = SKTexture(image: BuyButtonImage1200!)
        let buyButtonButton : SpriteKitButton!
        if  NodeInShopName == "ship3" || NodeInShopName == "ship6" || NodeInShopName == "ship9"{
            buyButtonButton = SpriteKitButton(defaultButtonImage: buyButtonTexture500, action: buyInShop)
            buyButtonButton.setScale(CGFloat(0.15))
            buyButtonButton.zPosition = 3
                   buyButtonButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButtonButton.frame.height - 200)
                   gameHUD.addChild(buyButtonButton)
        }else if  NodeInShopName == "pirateMap" || NodeInShopName == "middleAgeMap" || NodeInShopName == "chinaMap" || NodeInShopName == "ship7"{
            buyButtonButton = SpriteKitButton(defaultButtonImage: buyButtonTexture700, action: buyInShop)
            buyButtonButton.setScale(CGFloat(0.15))
            buyButtonButton.zPosition = 3
            buyButtonButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButtonButton.frame.height - 200)
            gameHUD.addChild(buyButtonButton)
        }else if NodeInShopName == "ship2" {
            buyButtonButton = SpriteKitButton(defaultButtonImage: buyButtonTexture100, action: buyInShop)
            buyButtonButton.setScale(CGFloat(0.15))
            buyButtonButton.zPosition = 3
            buyButtonButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButtonButton.frame.height - 200)
            gameHUD.addChild(buyButtonButton)
        }else if NodeInShopName == "ship6" || NodeInShopName == "ship5" || NodeInShopName == "ship8" {
            buyButtonButton = SpriteKitButton(defaultButtonImage: buyButtonTexture200, action: buyInShop)
            buyButtonButton.setScale(CGFloat(0.15))
            buyButtonButton.zPosition = 3
            buyButtonButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButtonButton.frame.height - 200)
            gameHUD.addChild(buyButtonButton)
        }else if NodeInShopName == "ship4" || NodeInShopName == "egypt" {
            // In-app purchase
            let buyButtonImage = UIImage(named: "art.scnassets/buttonImages/purchaseButton.png")
            let buyButtonTexture = SKTexture(image: buyButtonImage!)
            let buyButton = SpriteKitButton(defaultButtonImage: buyButtonTexture, action: buyInApp)
            buyButton.setScale(0.15)
            buyButton.zPosition = 3
            buyButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButton.frame.height - 200)
            gameHUD.addChild(buyButton)
        }else if NodeInShopName == "ship10" {
            buyButtonButton = SpriteKitButton(defaultButtonImage: buyButtonTexture1200, action: buyInShop)
            buyButtonButton.setScale(CGFloat(0.15))
            buyButtonButton.zPosition = 3
            buyButtonButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - buyButtonButton.frame.height - 200)
            gameHUD.addChild(buyButtonButton)
        }
    }
    
   
    
    func changeDifficulty() {
        for child in gameHUD.children {
            if child.zPosition == 10 {
                child.removeFromParent()
            }
        }
        let difficultyEasy = SKTexture(image: easy!)
        let difficultyMedium = SKTexture(image: medium!)
        let difficultyPortMaster = SKTexture(image: portMaster!)
        let easyButton = SpriteKitButton(defaultButtonImage: difficultyEasy, action: changeDifficulty)
        let mediumButton = SpriteKitButton(defaultButtonImage: difficultyMedium, action: changeDifficulty)
        let portMasterButton = SpriteKitButton(defaultButtonImage: difficultyPortMaster, action: changeDifficulty)
        
        if difficulty < 2 {
            
            difficulty += 1
        }else {
            difficulty = 0
        }
        
        UserDefaults.standard.set(difficulty, forKey: "Difficulty")
        if difficulty == 0 {
        gameHUD.addChild(easyButton)
        easyButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        easyButton.scale(to: CGSize(width: 150, height: 70))
        easyButton.zPosition = 10
        labelforDifficulty.text = "(1x Portcoins)"
        }else if difficulty == 1 {
        gameHUD.addChild(mediumButton)
        mediumButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        mediumButton.scale(to: CGSize(width: 150, height: 70))
        mediumButton.zPosition = 10
        labelforDifficulty.text = "(2x Portcoins)"
        }else if difficulty == 2 {
        gameHUD.addChild(portMasterButton)
        portMasterButton.position = CGPoint(x: gameHUD.frame.maxX - easyButton.frame.width/3, y: gameHUD.frame.midY - easyButton.frame.height/1.6)
        portMasterButton.scale(to: CGSize(width: 150, height: 70))
        portMasterButton.zPosition = 10
        labelforDifficulty.text = "(3x Portcoins)"
        }
    }
    func SwitchVolume(){
        let clickNoise = SCNAudioPlayer(source: click!)
        scene.rootNode.addAudioPlayer(clickNoise)
        for child in gameHUD.children {
            if child.position.x > sceneView.frame.midX && child.position.y > sceneView.frame.midY || child.position.y == sceneView.frame.midY {
                if child.isHidden {
                    child.isHidden = false
                }else if !child.isHidden{
                    child.isHidden = true
                }
            }
        }
        
        switch volume {
        case true:
            volume = false
            UserDefaults.standard.set(volume, forKey: "Volume")
             DispatchQueue.main.async {
                self.scene.rootNode.removeAllAudioPlayers()
            }
            
        case false:
            volume = true
            UserDefaults.standard.set(volume, forKey: "Volume")
            addMusic()
        }
    }
    func pauseGame() {
        
        if !paused {
            if volume {
        let clickNoise = SCNAudioPlayer(source: click!)
        scene.rootNode.addAudioPlayer(clickNoise)}
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = sceneView.bounds
        blurredEffectView.alpha = 0.4
        sceneView.addSubview(blurredEffectView)
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.isPaused = true
        }
        paused = true
        DispatchQueue.main.async {
            self.scene.rootNode.removeAllAudioPlayers()
        }
        
        
        let playButtonTexture = SKTexture(image: playImage!)
        let playButton = SpriteKitButton(defaultButtonImage: playButtonTexture, action: resumeGame)
        playButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY)
        playButton.scale(to: CGSize(width: 50, height: 50))
        gameHUD.addChild(playButton)
        }
        
    }
    func resumeGame() {
        if volume {
        let clickNoise = SCNAudioPlayer(source: click!)
        scene.rootNode.addAudioPlayer(clickNoise)
        addMusic()
        }
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.isPaused = false
        }
        for subview in sceneView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()

            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.paused = false
        }
        for child in gameHUD.children {
            if child.position.x == gameHUD.frame.midX {
                child.removeFromParent()
            }
        }
    }
    


}






extension GameViewController {
        @objc func swipe1(_ sender: UISwipeGestureRecognizer) {

            sceneView.scene?.rootNode.removeAllAudioPlayers()
            sceneView.addGestureRecognizer(tapGesture)
            for child in gameHUD.children {
                if child.zPosition == 3 || child.zPosition == 10{
                    child.removeFromParent()
                }
            }
            for node in shopScene.rootNode.childNodes{
                if node.name == "ship1"{
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship2" {
                node.scale = SCNVector3(0.9, 0.9,0.9)
                }else if node.name == "ship3"{
                node.scale = SCNVector3(0.4, 0.6, 0.6)
                }else if node.name == "ship4"{
                node.scale = SCNVector3(0.5, 0.9, 0.9)
                }else if node.name == "ship5" || node.name == "ship8" {
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                }else if node.name == "ship6" {
                node.scale = SCNVector3(0.4, 0.4, 0.4)
                }else if node.name == "ship7" {
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship9"{
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship10"{
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                }
                
            }
          for node in shopMapsScene.rootNode.childNodes {
            node.scale = SCNVector3(0.15, 0.15, 0.15)
                    }
                
                if gameState == .shopShips {
                    if shopCamera.position.x < 70 {
                        let action = SCNAction.move(by: SCNVector3(8, 0, 0), duration: 0.5)
                        action.timingMode = .easeOut
                        shopCamera.runAction(action)
                    }
                }else if gameState == .shopMaps {
                    if shopCamera.position.x < 55 {
                        let action = SCNAction.move(by: SCNVector3(15.0, 0, 0), duration: 0.5)
                        action.timingMode = .easeOut
                        shopCamera.runAction(action) }
                }
            
            
        }
        @objc func swipe2(_ sender: UISwipeGestureRecognizer){
  
            sceneView.scene?.rootNode.removeAllAudioPlayers()
              sceneView.addGestureRecognizer(tapGesture)
              for child in gameHUD.children {
                  if child.zPosition == 3 || child.zPosition == 10{
                      child.removeFromParent()
                  }
              }
              for node in shopScene.rootNode.childNodes{
                  if node.name == "ship1"{
                  node.scale = SCNVector3(0.6, 0.6, 0.6)
                  }else if node.name == "ship2" {
                  node.scale = SCNVector3(0.9, 0.9,0.9)
                  }else if node.name == "ship3"{
                  node.scale = SCNVector3(0.4, 0.6, 0.6)
                  }else if node.name == "ship4"{
                  node.scale = SCNVector3(0.5, 0.9, 0.9)
                  }else if node.name == "ship5" || node.name == "ship8" {
                  node.scale = SCNVector3(0.3, 0.3, 0.3)
                  }else if node.name == "ship6" {
                  node.scale = SCNVector3(0.4, 0.4, 0.4)
                  }else if node.name == "ship7" {
                  node.scale = SCNVector3(0.6, 0.6, 0.6)
                  }else if node.name == "ship9" {
                  node.scale = SCNVector3(0.6, 0.6, 0.6)
                  }else if node.name == "ship10"{
                  node.scale = SCNVector3(0.3, 0.3, 0.3)
                  }
                  
              }
            for node in shopMapsScene.rootNode.childNodes {
              node.scale = SCNVector3(0.15, 0.15, 0.15)
                      }
               if gameState == .shopShips {
                   if shopCamera.position.x > 1 {
                       let action = SCNAction.move(by: SCNVector3(-8, 0, 0), duration: 0.5)
                       action.timingMode = .easeOut
                       shopCamera.runAction(action)
                   }
               }else if gameState == .shopMaps {
                   if shopCamera.position.x > 1 {
                    let action = SCNAction.move(by: SCNVector3(-15, 0, 0), duration: 0.5)
                    action.timingMode = .easeOut
                    shopCamera.runAction(action)
               }
          }
    }
       @objc func touch(_ sender: UITapGestureRecognizer) {
        
            if gameState == .shopMaps || gameState == .shopShips {
                
            let touchLocation = tapGesture.location(in: sceneView)
        if touchLocation.y < gameHUD.frame.midY - gameHUD.frame.height/3 && touchLocation.x < gameHUD.frame.midX - gameHUD.frame.width/3{
            goBack()
            
        }else {
             let hitResults = sceneView.hitTest(touchLocation, options: [:])
                if hitResults.count > 0 {
                    let result = hitResults[0]
                    shopCamera.position.x = result.node.position.x
                    shopLight.position = shopCamera.position
                    let label = SKLabelNode(fontNamed: "Retro Gaming")
                    label.fontColor = UIColor.white
                    label.fontSize = 40.0
                    label.position.x  = gameHUD.frame.midX
                    label.position.y = gameHUD.frame.midY - 100
                    label.zPosition = 10
                    gameHUD.addChild(label)
                    let name = result.node.name
                    if name == "ship1" {
                        label.text = "Cargo Ship"
                        result.node.scale = SCNVector3(1.0, 1.0,1.0)
                        let sound = SCNAudioPlayer(source: horn3!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship2" {
                        label.text = "Fisher Boat"
                        result.node.scale = SCNVector3(1.5, 1.5 ,1.5)
                        let sound = SCNAudioPlayer(source: engine!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship3" {
                        label.text = "Old Steam Boat"
                        result.node.scale = SCNVector3(0.8, 0.8, 0.8)
                        let sound = SCNAudioPlayer(source: horn2!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship4" {
                        label.text = "Yacht"
                        result.node.scale = SCNVector3(1.3, 1.3, 1.3)
                        let yachtLabel = SKLabelNode(fontNamed: "Retro Gaming")
                        if !shipNumbersArray.contains("ship4"){
                        yachtLabel.fontColor = UIColor.white
                        yachtLabel.fontSize = 15.0
                        yachtLabel.position.x = gameHUD.frame.midX
                        yachtLabel.position.y = label.position.y - 50
                        yachtLabel.text = "2x Portcoins per ship you pass"
                        yachtLabel.zPosition = 10
                        gameHUD.addChild(yachtLabel)
                            }
                        let sound = SCNAudioPlayer(source: horn!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship5"{
                        label.text = "Pirate Ship"
                        result.node.scale = SCNVector3(0.5, 0.5, 0.5)
                        let sound = SCNAudioPlayer(source: pirateSound!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship6" {
                        label.text = "Chinese Ship"
                        result.node.scale = SCNVector3(0.6, 0.6, 0.6)
                        let sound = SCNAudioPlayer(source: gongSound!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship7"{
                       label.text = "Viking Ship"
                        result.node.scale = SCNVector3(0.9, 0.9, 0.9)
                        let sound = SCNAudioPlayer(source: vikingSound!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship8"{
                        label.text = "Medieval Ship"
                        result.node.scale = SCNVector3(0.5, 0.5, 0.5)
                        let sound = SCNAudioPlayer(source: woodSound!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship9" {
                        label.text = "Egyptian Ship"
                        result.node.scale = SCNVector3(1, 1, 1)
                        let sound = SCNAudioPlayer(source: woodSound2!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "ship10" {
                        label.text = "Ghost Ship"
                        result.node.scale = SCNVector3(0.5, 0.5, 0.5)
                        let sound = SCNAudioPlayer(source: woodSound2!)
                        shopScene.rootNode.addAudioPlayer(sound)
                    }else if name == "pirateMap" {
                        label.text = "Pirate Map"
                        label.position.y = gameHUD.frame.midX + 200
                        for map in shopMapsScene.rootNode.childNodes{
                            map.scale = SCNVector3(0.18, 0.18, 0.18)
                        }
                        if volume {
                        let music = SCNAudioPlayer(source: pirateMusic!)
                        shopMapsScene.rootNode.addAudioPlayer(music)
                        }
                    }else if name == "middleAgeMap" {
                        label.text = "Medieval Map"
                        label.position.y = gameHUD.frame.midX + 200
                        for map in shopMapsScene.rootNode.childNodes  {
                            map.scale = SCNVector3(0.18, 0.18, 0.18)
                        }
                        if volume {
                        let music = SCNAudioPlayer(source: medievalMapMusic!)
                        shopMapsScene.rootNode.addAudioPlayer(music)
                        }
                    }else if name == "containerPort" {
                        label.text = "Container Port"
                        label.position.y = gameHUD.frame.midX + 200
                        let music = SCNAudioSource(named: "art.scnassets/sounds/Drunken Sailor.wav")
                        let musicToPlay = SCNAudioPlayer(source: music!)
                        shopMapsScene.rootNode.addAudioPlayer(musicToPlay)
                        for map in shopMapsScene.rootNode.childNodes  {
                            map.scale = SCNVector3(0.18, 0.18, 0.18)
                        }
                    }else if name == "chinaMap" {
                        label.text = "China"
                        label.position.y = gameHUD.frame.midX + 200
                        if volume{
                        let music = SCNAudioPlayer(source: chineseMapMusic!)
                        shopMapsScene.rootNode.addAudioPlayer(music)}
                        for map in shopMapsScene.rootNode.childNodes  {
                            map.scale = SCNVector3(0.18, 0.18, 0.18)
                        }
                    }else if name == "egypt" {
                        label.text = "Egypt"
                        label.position.y = gameHUD.frame.midX + 200

                        for map in shopMapsScene.rootNode.childNodes  {
                            map.scale = SCNVector3(0.18, 0.18, 0.18)
                        }
                        if volume {
                        let musicSource = SCNAudioSource(named: "art.scnassets/sounds/Egypt.wav")
                        musicSource?.loops = true
                        let music = SCNAudioPlayer(source: musicSource!)
                        self.shopMapsScene.rootNode.addAudioPlayer(music)}
                        if !mapNumbersArray.contains("egypt"){
                            }
                    }
                    NodeInShopName = result.node.name
                    switch shopShips{
                    case true:
                    if !shipNumbersArray.contains(NodeInShopName){
                    sceneView.removeGestureRecognizer(tapGesture)
                    buyButton()
                    }
                    case false:
                    sceneView.removeGestureRecognizer(tapGesture)
                    if !mapNumbersArray.contains(NodeInShopName){
                    buyButton()
                    }else if mapNumbersArray.contains(NodeInShopName){
                    
                    setupShopButtonsMaps()
                        }
                    default:
                    break
                    }
                    
                    
                }
            }
         }
      }
}



/*
extension GameViewController {
    
 
    // advertisment
    func showRewardAD() {
        DispatchQueue.main.async {
            var count = 120
            
            _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (countdown) in
                
                count -= 5
                
                if count <= 0 {
                    countdown.invalidate()
                    self.canWatchRewardVideo = true
                    self.rewardButton.alpha = 1
                }else {
                    self.canWatchRewardVideo = false
                    self.rewardButton.alpha = 0.75
                }
                
                
            }
        }
        if rewardAd?.isReady == true && canWatchRewardVideo {
                self.scene.rootNode.removeAllAudioPlayers()
                rewardAd?.present(fromRootViewController: self, delegate: self)
                portCoinsWhilLoadingAD = portCoins
        }
    }
    func createAndLoadRewardedAd() -> GADRewardedAd{
        
        rewardAd = GADRewardedAd(adUnitID:"ca-app-pub-3940256099942544/1712485313")
                                           
       
        rewardAd!.load(GADRequest()) { error in
          if let error = error {
            print(error.debugDescription)
            return
          } else {
           
            
          }
          
        }
          return (rewardAd!)
      }
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        portCoins += 30
        UserDefaults.standard.set(portCoins, forKey: "PortCoins")
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeAllAudioPlayers()
        }
        
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        rewardAd = createAndLoadRewardedAd()
        if portCoins > portCoinsWhilLoadingAD {
        if volume{
        addMusic()
        let moneySound = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
        let money = SCNAudioPlayer(source: moneySound!)
        sceneView.scene?.rootNode.addAudioPlayer(money)
            }
        portCoinLabel.text = "\(UserDefaults().integer(forKey: "PortCoins"))"
        addjustCoinLabel()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitialAd = GADInterstitial(adUnitID:"ca-app-pub-3940256099942544/4411468910")

      interstitialAd.delegate = self
      interstitialAd.load(GADRequest())
      return interstitialAd
    }
    
    func presentInterstitial() {
        if interstitial.isReady {
            sceneView.scene!.rootNode.removeAllAudioPlayers()
            interstitial.present(fromRootViewController: self)
            
        }else {
           
            
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        if volume{
            sceneView.scene?.rootNode.removeAllAudioPlayers()
            addMusic()
        }
        if gameState == .shopMaps || gameState == .shopShips{
            sceneView.scene?.rootNode.removeAllAudioPlayers()
            sceneView.addGestureRecognizer(tapGesture)
            for child in gameHUD.children {
                if child.zPosition == 3 || child.zPosition == 10{
                    child.removeFromParent()
                }
            }
            for node in shopScene.rootNode.childNodes{
                if node.name == "ship1"{
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship2" {
                node.scale = SCNVector3(0.9, 0.9,0.9)
                }else if node.name == "ship3"{
                node.scale = SCNVector3(0.4, 0.6, 0.6)
                }else if node.name == "ship4"{
                node.scale = SCNVector3(0.5, 0.9, 0.9)
                }else if node.name == "ship5" {
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                }else if node.name == "ship6" {
                node.scale = SCNVector3(0.4, 0.4, 0.4)
                }else if node.name == "ship7" {
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship8" {
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                }else if node.name == "ship9" {
                node.scale = SCNVector3(0.6, 0.6, 0.6)
                }else if node.name == "ship10" {
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                }
                
            }
            for node in shopMapsScene.rootNode.childNodes {
                node.scale = SCNVector3(0.15 ,0.15, 0.15)
            }
            if shipNumbersArray.count == 3 && mapNumbersArray.count == 2{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if #available( iOS 10.3, *) {
                    SKStoreReviewController.requestReview()}
                }
                     
                
                    }

                }
        }
        
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
       
    }

}
 
 
    */

extension GameViewController: SKPaymentTransactionObserver{

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                
                if gameState != .settings{
                for child in gameHUD.children {
                    if child.zPosition == 3 {
                        child.removeFromParent()
                        let purchasingTexture = SKTexture(image: purchasingImage!)
                        let purchasingButton = SpriteKitButton(defaultButtonImage: purchasingTexture, action: buyInApp)
                        purchasingButton.isUserInteractionEnabled = false
                        purchasingButton.setScale(0.15)
                        purchasingButton.zPosition = 3
                        purchasingButton.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY - purchasingButton.frame.height - 200)
                        gameHUD.addChild(purchasingButton)
                    }
                }
            }
                
                break
                
            case .purchased:
                if gameState != .settings {
                for child in gameHUD.children{
                if child.zPosition == 3 || child.zPosition == 4 || child.zPosition == 10 {
                    child.removeFromParent()
                    }
                }
                if let shipInScene = sceneView.scene?.rootNode.childNode(withName: NodeInShopName, recursively: true){
                    if gameState == .shopMaps {
                    for node in shopMapsScene.rootNode.childNodes {
                        if node.name == NodeInShopName {
                            node.opacity = 1.0
                            node.runAction(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 2))
                            mapNumbersArray.append(NodeInShopName)
                            UserDefaults.standard.set(mapNumbersArray, forKey: "MapsArray")
                            }
                        }
                    }else if gameState == .shopShips{
                    shipInScene.opacity = 1.0
                    shipInScene.runAction(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 2))
                    shipNumbersArray.append(NodeInShopName)
                    UserDefaults.standard.set(shipNumbersArray, forKey: "ShipsArray")
                        }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if volume {
                    let moneySound = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
                    let money = SCNAudioPlayer(source: moneySound!)
                    self.sceneView.scene?.rootNode.addAudioPlayer(money)}
                }
            }
            queue.finishTransaction(transaction)
            
            case .failed:
                if gameState != .settings{
                    for child in gameHUD.children{
                        if child.zPosition == 3 || child.zPosition == 4 {
                            child.removeFromParent()
                        }
                    }
                             
                              let label = SKLabelNode(fontNamed: "Retro Gaming")
                             label.fontColor = UIColor.white
                             label.fontSize = 25.0
                             label.position = CGPoint(x: gameHUD.frame.midX, y: gameHUD.frame.midY)
                             label.text = "Purchase Failed"
                             label.zPosition = 4
                             gameHUD.addChild(label)
                             DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                                 label.removeFromParent()
                                 self.buyButton()
                             })
                }
                    queue.finishTransaction(transaction)
            case .restored:
                restoredProductsArray.append(transaction.payment.productIdentifier)
                restoredProducts += 1
                print(restoredProducts)
                queue.finishTransaction(transaction)
                
                
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if restoredProducts == 1  {
            unlockRestoredProducts()
        }else if restoredProducts == 2{
            unlockRestoredProducts()
        }else{
            self.alert = UIAlertController(title: "Nothing to restore", message: "Restoring failed", preferredStyle: .alert)
                self.present(self.alert, animated: true, completion:  nil)
                self.alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            let texture = SKTexture(image: restorePurchasesButtonImage!)
            restoreButton.defaultButton.texture = texture
            restoreButton.isUserInteractionEnabled = true
            restoreButton.alpha = 1.0
            }
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.alert = UIAlertController(title: "Something went wrong", message: "Restoring failed", preferredStyle: .alert)
        self.present(self.alert, animated: true, completion:  nil)
        self.alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
    }
    
    func restorePurchases() {
        if SKPaymentQueue.canMakePayments() {
            let texture = SKTexture(image: restoringPurchasesButtonImage!)
            restoreButton.defaultButton.texture = texture
            restoreButton.isUserInteractionEnabled = false
            restoreButton.alpha = 0.75
            restoredProducts = 0
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    
    func buyInApp() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            if NodeInShopName == "ship4"{
            paymentRequest.productIdentifier = yachtProductID
            }else if NodeInShopName == "egypt" {
            paymentRequest.productIdentifier = egyptProductID
            }
            SKPaymentQueue.default().add(paymentRequest)
            
        }else {
           
        }
        
    }
    
    func unlockRestoredProducts() {
       
        if restoredProducts == 2 {
            for node in shopMapsScene.rootNode.childNodes{
                if node.name == "egypt" {
                    node.opacity = 1
                }
            }
            mapNumbersArray.append("egypt")
            
            for node in shopScene.rootNode.childNodes{
                if node.name == "ship4" {
                    node.opacity = 1
                }
            }
            shipNumbersArray.append("ship4")
            self.alert = UIAlertController(title: "Sucess", message: "The Yacht and the Egyptian Map have been restored", preferredStyle: .alert)
            
        
        }else if restoredProducts == 1 {
           
            if restoredProductsArray.contains(yachtProductID){
            
                for node in shopScene.rootNode.childNodes{
                    if node.name == "ship4" {
                        node.opacity = 1
                    }
                }
                shipNumbersArray.append("ship4")
                self.alert = UIAlertController(title: "Sucess", message: "Yacht has been restored", preferredStyle: .alert)
                                  
            }else if restoredProductsArray.contains(egyptProductID){
              
                for node in shopMapsScene.rootNode.childNodes{
                    if node.name == "egypt" {
                        node.opacity = 1
                    }
                }
                self.alert = UIAlertController(title: "Sucess", message: "Egyptian World has been restored", preferredStyle: .alert)
                mapNumbersArray.append("egypt")
                
                
                
                    }
                }
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                   if volume {
                   let moneySound = SCNAudioSource(named: "art.scnassets/sounds/money.caf")
                   let money = SCNAudioPlayer(source: moneySound!)
                   self.sceneView.scene?.rootNode.addAudioPlayer(money)}
                   let texture = SKTexture(image: restorePurchasesButtonImage!)
                   self.restoreButton.defaultButton.texture = texture
                   self.restoreButton.alpha = 1
                   self.restoreButton.isUserInteractionEnabled = true
                   self.present(self.alert, animated: true, completion:  nil)
                   self.alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
               }
        UserDefaults.standard.set(mapNumbersArray, forKey: "MapsArray")
        UserDefaults.standard.set(shipNumbersArray, forKey: "ShipsArray")
        }
    
}
