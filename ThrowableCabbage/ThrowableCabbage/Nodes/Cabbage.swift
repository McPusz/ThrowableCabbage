//
//  Cabbage.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 30.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Cabbage: SCNNode {
    
    init(at position: SCNVector3, fromSceneView sceneView: ARSCNView) {
        super.init()

        guard let cabbageNode = sceneView.scene.rootNode.childNode(withName: "kapusta", recursively: true) else { return }
        cabbageNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cabbageNode.physicsBody?.mass = 2.0
        cabbageNode.physicsBody?.categoryBitMask = CollisionCategory.cabbage.rawValue
        cabbageNode.position = position
        self.addChildNode(cabbageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func remove() {
        self.removeFromParentNode()
    }
}
