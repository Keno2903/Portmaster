//
//  button-Backup.swift
//  Backup
//
//  Created by Keno Göllner  on 10.02.20.
//  Copyright © 2020 Keno Göllner . All rights reserved.
//

import SpriteKit
import SceneKit



class SpriteKitButton: SKSpriteNode {

    var defaultButton: SKSpriteNode
    var action: () -> ()

    
    init(defaultButtonImage: SKTexture, action: @escaping () -> ()) {
        defaultButton = SKSpriteNode(texture: defaultButtonImage)
        self.action = action
        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.25
  
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location) {
            defaultButton.yScale = 0.9
            defaultButton.alpha = 0.75
        } else {
            defaultButton.alpha = 1.0
        }

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location) {
            action()
        }
        defaultButton.yScale = 1.0
        defaultButton.alpha = 1.0
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 1.0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
