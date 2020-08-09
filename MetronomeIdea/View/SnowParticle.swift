
import UIKit

class SnowParticleView:UIView {
    
    var particleImage:UIImage?
    
    override class var layerClass:AnyClass {
        return CAEmitterLayer.self
    }
    
    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3//10
        cell.lifetime = 20.0
        cell.lifetimeRange = 0
        cell.velocity = -velocity
        cell.velocityRange = -velocity / 4
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 8
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = particleImage?.cgImage
        
//        let color = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        cell.color = color.cgColor
//        cell.redRange = 0.5
//        cell.greenRange = 0.5
//        cell.blueRange = 0.5
        
        return cell
    }
    
    override func layoutSubviews() {
        let emitter = self.layer as! CAEmitterLayer
        emitter.masksToBounds = true
        emitter.emitterShape = .line
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: screenHeight)
        emitter.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
//        let near = makeEmmiterCell(color: UIColor.white, velocity: 100, scale: 0.3)
//        let middle = makeEmmiterCell(color: UIColor.orange, velocity: 80, scale: 0.2)
//        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 60, scale: 0.1)
        
//        let near = makeEmmiterCell(color: UIColor.white, velocity: 50, scale: 0.2)
//        let middle = makeEmmiterCell(color: UIColor.orange, velocity: 40, scale: 0.1)
//        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 30, scale: 0.05)
        
        let near = makeEmmiterCell(color: UIColor.white, velocity: 40, scale: 0.2)
        let middle = makeEmmiterCell(color: UIColor.orange, velocity: 30, scale: 0.1)
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 10, scale: 0.05)
        
        emitter.emitterCells = [near, middle, far]
    }
}
