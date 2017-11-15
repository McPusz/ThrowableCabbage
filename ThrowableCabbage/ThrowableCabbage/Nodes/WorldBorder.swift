//
//  WorldBorder.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 30.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class WorldBorder: SCNNode {
    static let name = "WorldBorder"
    
    override init() {
        super.init()
        let bottomGeometry = SCNBox(width: 1000, height: 0.5, length: 1000, chamferRadius: 0)
        let bottomMaterial = SCNMaterial()
        bottomMaterial.transparency = 0
        bottomGeometry.materials = [bottomMaterial]
        
        let borderNode = SCNNode(geometry: bottomGeometry)
        borderNode.position = SCNVector3Make(0, -10, 0)
        borderNode.name = WorldBorder.name
        
        borderNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        borderNode.physicsBody?.categoryBitMask = CollisionCategory.world.rawValue
        borderNode.physicsBody?.contactTestBitMask = CollisionCategory.cabbage.rawValue
        
        self.addChildNode(borderNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
