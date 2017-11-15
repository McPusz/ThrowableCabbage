//
//  Explode+SCNNode.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 14.11.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import SceneKit

extension SCNNode {
    func explodeFrom(position: SCNVector3) {
        
        let maxRangeDistance: Float = 2.0
        let strengthMultiplier: Float = 5.0
        
        let xPos = self.position.x - position.x
        let yPos = self.position.y - position.y
        let zPos = self.position.z - position.z
        
        //distance vector between camera and object
        let distanceVector = SCNVector3Make(xPos, yPos, zPos)
        //float non-negative distance
        let distance: Float = sqrtf((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y) + (distanceVector.z * distanceVector.z))
        // if object is further than maxDistance, force won't affect the object
        var strength = max(0, (maxRangeDistance - distance))
        //scale strength
        strength = strength * strength * strengthMultiplier
        
        let scaledDistanceX = distanceVector.x / distance * strength
        let scaledDistanceY = distanceVector.y / distance * strength
        let scaledDistanceZ = distanceVector.z / distance * strength
        
        let scaledDistance = SCNVector3Make(scaledDistanceX, scaledDistanceY, scaledDistanceZ)
        
        //apply force to geometry of objects
        let cornerPosition = SCNVector3Make(0.05, 0.05, 0.05)
        self.physicsBody?.applyForce(scaledDistance, at: cornerPosition, asImpulse: true)
    }
}
