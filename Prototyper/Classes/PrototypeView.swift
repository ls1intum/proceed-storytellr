//
//  PrototypeView.swift
//  Pods
//
//  Created by Paul Schmiedmayer on 5/28/17.
//
//

import UIKit

@IBDesignable open class PrototypeView: UIView {
    
    @IBInspectable open var container: String = "container" {
        didSet {
            loadPrototype()
        }
    }
    
    @IBInspectable open var startPage: Int = 0 {
        didSet {
            loadPage()
        }
    }
    
    var prototype: Prototype?
    let imageView = UIImageView()
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadPrototype()
        setupView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        loadPrototype()
        setupView()
    }
    
    fileprivate func setupView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstaint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstaint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)

        self.addSubview(imageView)
        self.addConstraints([topConstaint, bottomConstaint, leftConstraint, rightConstraint])
        
        imageView.contentMode = .scaleToFill
        
        let longPressRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(showFeedbackView(touchRecognizer:)))
        self.addGestureRecognizer(longPressRecognizer)
        
        let touchRecognizer = UITapGestureRecognizer(target:self, action: #selector(flashButtons(touchRecognizer:)))
        self.addGestureRecognizer(touchRecognizer)
    }
    
    fileprivate func loadPrototype() {
        if prototype == nil {
            prototype = Prototype.prototypeFromContainer(named: container)
            if startPage != 0, let page = prototype?.pages.filter({$0.id == startPage}).first {
                prototype?.currentPage = page
            }
            loadPage()
        }
    }
    
    fileprivate func loadPage() {
        guard let currentPage = prototype?.currentPage else {
            return
        }
        
        imageView.image = currentPage.image
    }
    
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        guard let image = UIImage(named: "Prototyper", in: Bundle(for: PrototypeView.self), compatibleWith: nil) else {
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        let textLabel = UILabel(frame: CGRect.zero)
        textLabel.text = container
        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        
        let imageCenterXConstaint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let imageCenterYConstaint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let labelCenterXConstaint = NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let labelCenterYConstaint = NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([imageCenterXConstaint, imageCenterYConstaint, labelCenterXConstaint, labelCenterYConstaint])
        
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        #if !TARGET_INTERFACE_BUILDER
            guard let prototype = prototype, let currentPage = prototype.currentPage, let image = currentPage.image else {
                return
            }
            
            for subView in subviews where subView is UIButton {
                subView.removeFromSuperview()
            }
            
            let scale = CGVector(dx: self.bounds.size.width/image.size.width, dy: self.bounds.size.height/image.size.height)
            for prototypeTransition in currentPage.transitions {
                let button = UIButton(frame: prototypeTransition.frame*scale)
                button.tag = prototypeTransition.id
                button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
                
                self.addSubview(button)
            }
        #endif
    }
    
    // MARK: - User Interaction
    
    @objc func buttonPressed(button: UIButton) {
        guard let prototype = prototype, let transition = prototype.currentPage?.transitions.filter({$0.id == button.tag}).first else {
            return
        }
        
        transition.performTransition(prototyperView: self, completion: { (finished: Bool) in
            prototype.currentPage = prototype.pages.filter({$0.id == transition.destinationID}).first
            self.loadPage()
            self.setNeedsDisplay()
        })
    }
    
    @objc func showFeedbackView(touchRecognizer: UIGestureRecognizer) {
        if touchRecognizer.state == .began {
            PrototypeController.sharedInstance.showFeedbackView()
        }
    }
    
    @objc func flashButtons(touchRecognizer: UIGestureRecognizer) {
        for subView in subviews where subView is UIButton {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
                subView.backgroundColor = PrototypeUI.ButtonColor
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.1, delay: PrototypeUI.ShowButtonsTime, options: .allowUserInteraction, animations: {
                    subView.backgroundColor = .clear
                })
            })
        }
    }
}

// MARK: - Custom Extensions

fileprivate extension CGRect {
    static func * (rect: CGRect, scalar: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x*scalar, y: rect.origin.y*scalar, width: rect.width*scalar, height: rect.height*scalar)
    }
    
    static func * (rect: CGRect, scalar: CGVector) -> CGRect {
        return CGRect(x: rect.origin.x*scalar.dx, y: rect.origin.y*scalar.dy, width: rect.width*scalar.dx, height: rect.height*scalar.dy)
    }
}
