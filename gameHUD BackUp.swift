//
//  gameHUD BackUp.swift
//  Backup
//
//  Created by Keno Göllner  on 27.01.20.
//  Copyright © 2020 Keno Göllner . All rights reserved.
//

import SpriteKit

var scaleAction = SKAction.scale(to: 0.9, duration: 0.6)
var scaleAction2 = SKAction.scale(to: 1.1, duration: 0.6)
var Animation = SKAction.repeatForever(SKAction.sequence([scaleAction2,scaleAction]))
var highScore = UserDefaults().integer(forKey: "HighScore")
var volume = UserDefaults().bool(forKey: "Volume")
var portCoins = UserDefaults().integer(forKey: "PortCoins")
var shipNumbersArray = UserDefaults.standard.array(forKey: "ShipsArray") as? [String] ?? [String]()
var mapNumbersArray = UserDefaults.standard.array(forKey: "MapsArray") as? [String] ?? [String]()
var difficulty = UserDefaults().integer(forKey: "Difficulty")
var mapToShow = UserDefaults().string(forKey: "MapToShow")
var themeOnly = false
var onoffButton : SpriteKitButton!
var pauseImage = UIImage(named: "art.scnassets/buttonImages/pausePixel.png")
var playImage = UIImage(named: "art.scnassets/buttonImages/playPixel.png")
var homeImage = UIImage(named: "art.scnassets/buttonImages/RetryPixel2.png")
var settingsImage = UIImage(named: "art.scnassets/buttonImages/settingsPixel2.png")
var shopImage = UIImage(named: "art.scnassets/buttonImages/ShopPixel2.png")
var volumeImageON = UIImage(named: "art.scnassets/buttonImages/SpeakerOn.png")
var volumeImageOff = UIImage(named: "art.scnassets/buttonImages/SpeakerOff.png")
var shopArrowRight  = UIImage(systemName: "chevron.right")
var shopArrowLeft = UIImage(systemName: "chevron.left")
var BuyButtonImage500 = UIImage(named: "art.scnassets/buttonImages/BuyButton500.png")
var BuyButtonImage700 = UIImage(named: "art.scnassets/buttonImages/BuyButton700.png")
var BuyButtonImage1200 = UIImage(named: "art.scnassets/buttonImages/1200.png")
let easy = UIImage(named: "art.scnassets/buttonImages/easyLabel.png")
let medium = UIImage(named: "art.scnassets/buttonImages/mediumLabel.png")
let portMaster = UIImage(named: "art.scnassets/buttonImages/portMasterLabel.png")
let maps = UIImage(named: "art.scnassets/buttonImages/mapsButton.png")
let selectButton = UIImage(named: "art.scnassets/buttonImages/buttonSelect.png")
let selectedButton = UIImage(named: "art.scnassets/buttonImages/buttonSelected.png")
let defaultMapButton = UIImage(named: "art.scnassets/buttonImages/buttonDefaultPort.png")
var goBackImage = UIImage(named: "art.scnassets/buttonImages/goBackArrow.png")
var earnPortCoinsButtonImage = UIImage(named: "art.scnassets/buttonImages/EarnPortCoinsButton.png")
var aboutButtonImage = UIImage(named: "art.scnassets/buttonImages/About.png")
var BuyButtonImage100 = UIImage(named: "art.scnassets/buttonImages/100Button.png")
var BuyButtonImage200 = UIImage(named: "art.scnassets/buttonImages/200Button.png")
var purchasingImage = UIImage(named: "art.scnassets/buttonImages/purchasing Button.png")
var restorePurchasesButtonImage = UIImage(named: "art.scnassets/buttonImages/RestoreButton.png")
var restoringPurchasesButtonImage = UIImage(named: "art.scnassets/buttonImages/Restoring.png")


var info = false
class GameHUD: SKScene {
    var logoLabel: SKLabelNode?
    var tapToPlayLabel: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    var pointsLabel: SKLabelNode?
    var coinsLabel: SKLabelNode?
    var button: SKSpriteNode!
    var portCoinImage2 : SKSpriteNode!
    var infoNode : SKSpriteNode!
    var resetLabel = SKLabelNode()
    
    
    init(with size: CGSize, gameState: GameState) {
        super.init(size: size)
        if gameState == .menu {
            addMenuLabels()
        } else if gameState == . playing {
            addPointsLabel()
        }else if gameState == .reset {
            addResetScene()
        }else if gameState == .settings {
            addSettingsScene()
        }else if gameState == .shopShips {
            addShopSceneShips()
        }else if gameState == .shopMaps{
             addShopSceneMaps()
        }else if gameState == .shopMenu {
            addShopMenu()
        }else if gameState == .loading {
            addLoadingScene()
        }
    }
    
    func addMenuLabels() {
        logoLabel = SKLabelNode(fontNamed: "Retro Gaming")
        tapToPlayLabel = SKLabelNode(fontNamed: "Retro Gaming")
        guard let logoLabel = logoLabel, let tapToPlayLabel = tapToPlayLabel else {
            return
        }
        logoLabel.text = "Port Master"
        logoLabel.fontSize = 40.0
        logoLabel.fontColor = UIColor.white
        logoLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logoLabel)
        
        tapToPlayLabel.text = "Tap to play"
        tapToPlayLabel.fontSize = 30.0
        tapToPlayLabel.fontColor = UIColor.white
        tapToPlayLabel.position = CGPoint(x: frame.midX, y: frame.midY-logoLabel.frame.size.height)

        addChild(tapToPlayLabel)
        self.logoLabel!.run(Animation)
        self.tapToPlayLabel!.run(Animation)
        Animation.timingMode = .easeInEaseOut
        
       let themeOnlyLabel = SKLabelNode(fontNamed: "Retro Gaming")
       themeOnlyLabel.text = "theme only:"
       themeOnlyLabel.fontColor = UIColor.white
       themeOnlyLabel.fontSize = 25.0
       themeOnlyLabel.position = CGPoint(x: frame.minX + themeOnlyLabel.frame.size.width/2, y: frame.maxY - themeOnlyLabel.frame.size.height * 2.2)
       addChild(themeOnlyLabel)
        
        
       let offImage = UIImage(named: "art.scnassets/buttonImages/off.png")
       let onImage = UIImage(named: "art.scnassets/buttonImages/on.png")
       let offTexture = SKTexture(image: offImage!)
       let onTexture = SKTexture(image: onImage!)
      if themeOnly {
       onoffButton = SpriteKitButton(defaultButtonImage: onTexture, action: changeThemeOnly)
        }else {
        onoffButton = SpriteKitButton(defaultButtonImage: offTexture, action: changeThemeOnly)
        }
        
      onoffButton.scale(to: CGSize(width: 40, height: 50))
      onoffButton.position = CGPoint(x: frame.midX + 20, y: frame.maxY - onoffButton.frame.size.height)
      addChild(onoffButton)
      if mapToShow == "chinaMap" && !shipNumbersArray.contains("ship6"){
        onoffButton.isUserInteractionEnabled = false
        onoffButton.alpha = 0.75
        }else if mapToShow == "pirateMap" && !shipNumbersArray.contains("ship5") {
        onoffButton.isUserInteractionEnabled = false
        onoffButton.alpha = 0.75
        }else if mapToShow == "middleAgeMap" && !shipNumbersArray.contains("ship8") {
        onoffButton.isUserInteractionEnabled = false
        onoffButton.alpha = 0.75
        }else if mapToShow == "egypt" && !shipNumbersArray.contains("ship9"){
        onoffButton.isUserInteractionEnabled = false
        onoffButton.alpha = 0.75
        }else {
        onoffButton.isUserInteractionEnabled = true
        onoffButton.alpha = 1
        }
       
       let infoButtonImage = UIImage(named: "art.scnassets/buttonImages/infoButton.png")
       let infoButtonTexture = SKTexture(image: infoButtonImage!)
       let infoButton = SpriteKitButton(defaultButtonImage: infoButtonTexture, action: showInfo)
       infoButton.setScale(0.15)
       infoButton.position = CGPoint(x: frame.maxX - infoButton.frame.size.width, y: frame.maxY - infoButton.frame.size.height * 1.8)
        addChild(infoButton)
   

    }
    
    func addPointsLabel() {
        pointsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        guard let pointsLabel = pointsLabel else {
            return
        }
        pointsLabel.text = "0"
        pointsLabel.fontSize = 50.0

        pointsLabel.position = CGPoint(x: frame.minX + pointsLabel.frame.size.width, y: frame.maxY - pointsLabel.frame.size.height * 2)
        
        addChild(pointsLabel)
        
        coinsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        guard let coinsLabel = coinsLabel else {
            return
        }
        
        coinsLabel.text = "0"
        coinsLabel.fontSize = 40.0
        coinsLabel.position = CGPoint(x: frame.maxX - coinsLabel.frame.size.width * 3, y: frame.minY + coinsLabel.frame.size.height)
        
        addChild(coinsLabel)
        

        portCoinImage2 = SKSpriteNode(imageNamed: "art.scnassets/buttonImages/portCoin.png")
        portCoinImage2.scale(to: CGSize(width: 40, height: 40))
        portCoinImage2.position = CGPoint(x: frame.maxX - portCoinImage2.frame.size.width/1.3, y: coinsLabel.position.y + 15)
        portCoinImage2.zPosition = 2
        
        addChild(portCoinImage2)
        
    }
    
    func addResetScene() {

        resetLabel = SKLabelNode(fontNamed: "Retro Gaming")
        resetLabel.fontSize = 30.0
        resetLabel.fontColor = UIColor.white
        resetLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        resetLabel.run(Animation)
        
        
        
        
        let portCoinImage = SKSpriteNode(imageNamed: "art.scnassets/buttonImages/portCoin.png")
        portCoinImage.position = CGPoint(x: frame.maxX - 50 , y: frame.maxY - frame.height/9 + 20)
        portCoinImage.scale(to: CGSize(width: 60, height: 60))
        portCoinImage.zPosition = 2
        
        highScoreLabel = SKLabelNode(fontNamed: "Retro Gaming")
        guard let highScoreLabel = highScoreLabel else {
            return
        }
        highScoreLabel.text = "best: \(UserDefaults().integer(forKey: "HighScore"))"
        highScoreLabel.fontSize = 30.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.minX + highScoreLabel.frame.size.width / 1.8, y: frame.minY + highScoreLabel.frame.size.height)
        
        
        
        addChild(highScoreLabel)
        addChild(portCoinImage)
        addChild(resetLabel)
    }
    
    func addLoadingScene() {
        let box = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        let box2 = SKShapeNode(rect: box)
        box2.fillColor = UIColor.systemTeal
        box2.strokeColor = UIColor.systemTeal
        addChild(box2)
        
        let labelOne = SKLabelNode(fontNamed: "Retro Gaming")
        labelOne.position = CGPoint(x: frame.maxX + frame.width, y: frame.midY)
        labelOne.text = "Port Master..."
        labelOne.fontColor = UIColor.white
        labelOne.fontSize = 40.0
        addChild(labelOne)
        
        
    }
    
    func addSettingsScene() {
        let box = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        let box2 = SKShapeNode(rect: box)
        box2.fillColor = UIColor.systemTeal
        box2.strokeColor = UIColor.systemTeal
        box2.alpha = 0.75
        addChild(box2)
        
        let settingsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        settingsLabel.text = "Settings"
        settingsLabel.fontSize = 40.0
        settingsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - settingsLabel.frame.height * 2)
        settingsLabel.fontColor = UIColor.white
        settingsLabel.zPosition = 1
        

        let volumeLabel = SKLabelNode(fontNamed: "Retro Gaming")
        volumeLabel.text = "volume:"
        volumeLabel.fontSize = 30.0
        volumeLabel.fontColor = UIColor.white
        volumeLabel.position = CGPoint(x: frame.minX + volumeLabel.frame.width/1.8, y: frame.midY - volumeLabel.frame.height/2)
        
        let difficultyLabel = SKLabelNode(fontNamed: "Retro Gaming")
        difficultyLabel.text = "difficulty:"
        difficultyLabel.fontSize = 30.0
        difficultyLabel.fontColor = UIColor.white
        difficultyLabel.position = CGPoint(x: frame.minX + difficultyLabel.frame.width/1.8, y: frame.midY - difficultyLabel.frame.height * 4)
        difficultyLabel.zPosition = 2
        
        
        addChild(difficultyLabel)
        addChild(settingsLabel)
        addChild(volumeLabel)
    }
    
    func addShopSceneShips() {

        
        let settingsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        settingsLabel.text = "Ships"
        settingsLabel.fontSize = 25.0
        settingsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - settingsLabel.frame.height * 3)
        settingsLabel.fontColor = UIColor.white
        settingsLabel.zPosition = 1
        addChild(settingsLabel)
        
    }
    func addShopMenu(){
        let box = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        let box2 = SKShapeNode(rect: box)
        box2.fillColor = UIColor.systemTeal
        box2.strokeColor = UIColor.systemTeal
        box2.alpha = 0.75
        addChild(box2)
        
        let settingsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        settingsLabel.text = "Shop"
        settingsLabel.fontSize = 30.0
        settingsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - settingsLabel.frame.height * 3)
        settingsLabel.fontColor = UIColor.white
        settingsLabel.zPosition = 1
        addChild(settingsLabel)

            
    }
    func addShopSceneMaps() {
        let settingsLabel = SKLabelNode(fontNamed: "Retro Gaming")
        settingsLabel.text = "Maps"
        settingsLabel.fontSize = 30.0
        settingsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - settingsLabel.frame.height * 3)
        settingsLabel.fontColor = UIColor.white
        settingsLabel.zPosition = 1
        addChild(settingsLabel)
    }
    
    func changeThemeOnly() {
        
        
        let offImage = UIImage(named: "art.scnassets/buttonImages/off.png")
        let onImage = UIImage(named: "art.scnassets/buttonImages/on.png")
        let offTexture = SKTexture(image: offImage!)
        let onTexture = SKTexture(image: onImage!)
        if themeOnly{
        onoffButton.defaultButton.texture = offTexture
        }else {
        onoffButton.defaultButton.texture = onTexture
        }
        themeOnly = !themeOnly

    }

       

    func showInfo() {
        infoNode = SKSpriteNode(imageNamed: "art.scnassets/buttonImages/Info.png")
        infoNode.position = CGPoint(x: frame.midX, y: frame.midY)
        infoNode.scale(to: CGSize(width: 300, height: 350))
        addChild(infoNode)
        info = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


