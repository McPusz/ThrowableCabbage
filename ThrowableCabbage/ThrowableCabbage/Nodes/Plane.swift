//
//  Plane.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 26.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import ARKit
import SceneKit

class Plane: SCNNode {
    static let name = "GridPlane"
    
    private var anchor: ARPlaneAnchor?
    private var planeGeometry: SCNPlane?
    
    init(with anchor: ARPlaneAnchor) {
        super.init()
        
        self.anchor = anchor
        let width: CGFloat = CGFloat(anchor.extent.x)
        let length: CGFloat = CGFloat(anchor.extent.z)
        
        self.planeGeometry = SCNPlane(width: width, height: length)
        
        let gridMaterial = SCNMaterial()
        let gridImage = #imageLiteral(resourceName: "grid")
        gridMaterial.diffuse.contents = gridImage
        self.planeGeometry?.materials = [gridMaterial]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.physicsBody = self.getPlanePhysicsBody()
       
        //rotate plane to be horizontal
        planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0)
        planeNode.name = Plane.name
        
        self.setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.planeGeometry?.width = CGFloat(anchor.extent.x)
        self.planeGeometry?.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        let node = self.childNodes.first
        node?.physicsBody = self.getPlanePhysicsBody()
        self.setTextureScale()
    }
    
    private func getPlanePhysicsBody() -> SCNPhysicsBody? {
        guard let geometry = self.planeGeometry else { return nil }
        let planeShape = SCNPhysicsShape(geometry: geometry, options: nil)
        let body = SCNPhysicsBody(type: .kinematic, shape: planeShape)
        return body
    }
    
    private func setTextureScale() {
        let width = Float(self.planeGeometry?.width ?? 0)
        let height = Float(self.planeGeometry?.height ?? 0)
        
        if let material = self.planeGeometry?.materials.first {
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1)
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
        }
    }
    
}
