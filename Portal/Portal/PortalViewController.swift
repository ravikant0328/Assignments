import UIKit
import ARKit

class PortalViewController: UIViewController,ARSessionDelegate {

  @IBOutlet var sceneView: ARSCNView?
  @IBOutlet weak var messageLabel: UILabel?
  @IBOutlet weak var sessionStateLabel: UILabel?
  @IBOutlet weak var crosshair: UIView!
    
  var debugPlanes: [SCNNode] = []
  var portalNode: SCNNode? = nil
  var isPortalPlaced = false
  var currentAngleY:Float = 0.0
  var currentAngleX:Float = 0.0
  
  //Mark: Calculating center point of screen
  var viewCenter: CGPoint {
    let viewBounds = view.bounds
    return CGPoint(x: viewBounds.width / 2.0, y: viewBounds.height / 2.0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    runSession()
    sceneView?.showsStatistics = true
    sceneView?.delegate = self
    sceneView?.autoenablesDefaultLighting = true
    showMessage("Session Active", label: sessionStateLabel!, seconds: 3)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didtap(_:)))
    sceneView?.addGestureRecognizer(tapGesture)
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didpinch(_:)))
    sceneView?.addGestureRecognizer(pinchGesture)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didpan(_:)))
    sceneView?.addGestureRecognizer(panGesture)
  }
  
  //Mark: Moving the object on tapping
  @objc func didtap(_ gesture: UITapGestureRecognizer){
    guard let _ = portalNode else {return}
    let tapLocation = gesture.location(in: sceneView)
    let result = sceneView?.hitTest(tapLocation, types: .featurePoint)
    if let result = result?.first{
      let translation = result.worldTransform.translation
      portalNode?.position = SCNVector3Make(translation.x, translation.y, translation.z)
      sceneView?.scene.rootNode.addChildNode(portalNode!)
    }
  }
  
  
  //Mark: Resizing the object on pinching
  @objc func didpinch(_ gesture: UIPinchGestureRecognizer){
    guard let _ = portalNode else{return}
    var originalScale = portalNode?.scale
    switch gesture.state{
    case .began:
      originalScale = portalNode?.scale
      gesture.scale = CGFloat((portalNode?.scale.x)!)
    case .changed:
      guard var newScale = originalScale else { return }
      if gesture.scale <= 0.05{
        newScale = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
      }else if gesture.scale > 1{
        newScale = SCNVector3(1, 1, 1)
      }else{
        newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
      }
      portalNode?.scale = newScale
    case .ended:
      guard var newScale = originalScale else { return }
      if gesture.scale <= 0.05{
        newScale = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
      }else if gesture.scale > 1{
        newScale = SCNVector3(1, 1, 1)
      }else{
        newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
      }
      portalNode?.scale = newScale
      gesture.scale = CGFloat((portalNode?.scale.x)!)
    default:
      gesture.scale = 1
      originalScale = nil
    }
  }
  
  
  //Mark: Rotating the object
  @objc func didpan(_ gesture: UIPanGestureRecognizer){
    guard let _ = portalNode else {return}
    let translation = gesture.translation(in: gesture.view)
    var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
    var newAngleX = (Float)(translation.y)*(Float)(Double.pi)/180.0
    newAngleY += currentAngleY
    newAngleX += currentAngleX
    portalNode?.eulerAngles.y = newAngleY
    portalNode?.eulerAngles.x = newAngleX
    if gesture.state == .ended{
      currentAngleY = newAngleY
      currentAngleX = newAngleX
    }
  }
    

  
  
  //Mark: Start of a session
  func runSession(){
    let configuration = ARWorldTrackingConfiguration.init()
    configuration.planeDetection = [.horizontal, .vertical]
    configuration.isLightEstimationEnabled = true
    sceneView?.session.run(configuration,options: [.resetTracking, .removeExistingAnchors])
    
    #if DEBUG
       sceneView?.debugOptions = [SCNDebugOptions.showFeaturePoints]
    #endif
  }
  

  
  func showMessage(_ message: String, label: UILabel, seconds: Double) {
    label.text = message
    label.alpha = 1
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
      if label.text == message {
        label.text = ""
        label.alpha = 0
      }
    }
  }

  
  //Mark : Clearing the screen of planes and nodes
  func removeAllNodes() {
    removeDebugPlanes()
    self.portalNode?.removeFromParentNode()
    self.isPortalPlaced = false
  }

  func removeDebugPlanes() {
    for debugPlaneNode in self.debugPlanes {
      debugPlaneNode.removeFromParentNode()
    }
    
    self.debugPlanes = []
  }
  
  
  // Mark: Adding anchor as the touch happens
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let hit = sceneView?.hitTest(viewCenter, types: [.existingPlaneUsingExtent]).first{
      sceneView?.session.add(anchor: ARAnchor.init(transform: hit.worldTransform))
    }
  }
  
  //Mark: Adding object to the plane
  func makePortal() -> SCNNode{
    let portal = SCNNode()
    let box = SCNScene(named: "Assets.scnassets/missile.dae")
    let boxChildNode = box?.rootNode.childNodes
    for childNode in boxChildNode!{
      portal.addChildNode(childNode)
    }
    
    // Adding texture to the object
    let material = SCNMaterial()
    material.diffuse.contents = UIImage(named: "Texture.png")
    portal.geometry?.materials = [material]
    portal.scale = SCNVector3(0.05,0.05,0.05)
    
    return portal
  }
}

extension PortalViewController: ARSCNViewDelegate{
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let planeAnchor = anchor as? ARPlaneAnchor{
        #if DEBUG
           let debugPlaneNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
           node.addChildNode(debugPlaneNode)
           self.debugPlanes.append(debugPlaneNode)
        #endif
        self.messageLabel?.alpha = 1.0
        self.messageLabel?.text = "Tap on the detected plane to place the object"
      }
      else if !self.isPortalPlaced{
        self.portalNode = self.makePortal()
        if let portal = self.portalNode {
          node.addChildNode(portal)
          self.isPortalPlaced = true
          self.removeDebugPlanes()
          self.sceneView?.debugOptions = []
          DispatchQueue.main.async {
            self.messageLabel?.text = ""
            self.messageLabel?.alpha = 0
          }
        }
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async {
      if let planeAnchor = anchor as? ARPlaneAnchor, node.childNodes.count > 0{
        updatePlaneNode(node.childNodes[0],center: planeAnchor.center,extent: planeAnchor.extent)
      }
    }
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    guard let label = self.sessionStateLabel else {return}
    showMessage(error.localizedDescription, label: label, seconds: 3)
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    guard let label = self.sessionStateLabel else {return}
    showMessage("Session Interrupted", label: label, seconds: 3)
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    guard let label = self.sessionStateLabel else {return}
    showMessage("Session Resumed", label: label, seconds: 3)
    DispatchQueue.main.async {
      self.removeAllNodes()
    }
    runSession()
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
      if let _ = self.sceneView?.hitTest(self.viewCenter, types: [.existingPlaneUsingExtent]).first{
        self.crosshair.backgroundColor = UIColor.green
      }else{
        self.crosshair.backgroundColor = UIColor.lightGray
      }
    }
  }
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
    case .normal :
      messageLabel!.text = "Move the device to detect horizontal or vertical surfaces."
      
    case .notAvailable:
      messageLabel!.text = "Tracking not available."
      
    case .limited(.excessiveMotion):
      messageLabel!.text = "Tracking limited - Move the device more slowly."
      
    case .limited(.insufficientFeatures):
      messageLabel!.text = "Tracking limited - Point the device at an area with visible surface detail."
      
    case .limited(.initializing):
      messageLabel!.text = "Initializing AR session."
      
    default:
      messageLabel!.text = ""
    }
  }
  

}


