//
//  SCNNodeHelper.swift
//  Portal
//
//  Created by Ravi on 19/09/18.
//  Copyright © 2018 Namrata Bandekar. All rights reserved.
//

import Foundation
import SceneKit

func createPlaneNode(center: vector_float3,extent: vector_float3) -> SCNNode {
  let plane = SCNPlane(width: CGFloat(extent.x),height: CGFloat(extent.z))
  let planeMaterial = SCNMaterial()
  planeMaterial.diffuse.contents = UIColor.yellow.withAlphaComponent(0.4)
  plane.materials = [planeMaterial]
  let planeNode = SCNNode(geometry: plane)
  planeNode.position = SCNVector3Make(center.x, 0, center.z)
  planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
  return planeNode
}

func updatePlaneNode(_ node: SCNNode,center: vector_float3,extent: vector_float3) {
  let geometry = node.geometry as? SCNPlane
  geometry?.width = CGFloat(extent.x)
  geometry?.height = CGFloat(extent.z)
  node.position = SCNVector3Make(center.x, 0, center.z)
}

extension float4x4{
  var translation:float3{
    let translation = self.columns.3
    return(float3(translation.x, translation.y, translation.z))
  }
}
