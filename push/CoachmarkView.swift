import UIKit

class CoachmarkView: UIView {
    
    var targetView: UIView
    var title: String
    var message: String
    var currentIndex: Int
    var totalSteps: Int
    var onNext: (() -> Void)?
    var onSkip: (() -> Void)?
    
    private let stepIndicatorLabel = UILabel()
    
    init(targetView: UIView, title: String, message: String, currentIndex: Int, totalSteps: Int, frame: CGRect) {
        self.targetView = targetView
        self.title = title
        self.message = message
        self.currentIndex = currentIndex
        self.totalSteps = totalSteps
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView1() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Highlight target area
        let path = UIBezierPath(rect: self.bounds)
        let targetFrame = targetView.convert(targetView.bounds, to: self)
        let cutoutPath = UIBezierPath(roundedRect: targetFrame.insetBy(dx: -8, dy: -8), cornerRadius: 10)
        path.append(cutoutPath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        self.layer.mask = maskLayer
        
        // Add tooltip
        let tooltipView = createTooltipView(below: targetFrame)
        self.addSubview(tooltipView)
        // Add step indicator inside the tooltip view
        configureStepIndicator(in: tooltipView)
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Create a mask for the target view
        let path = UIBezierPath(rect: self.bounds)
        let targetFrame = targetView.convert(targetView.bounds, to: self)
        let cutoutPath = UIBezierPath(roundedRect: targetFrame.insetBy(dx: -8, dy: -8), cornerRadius: 10)
        path.append(cutoutPath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        self.layer.mask = maskLayer
        
        // **Fix Spacing Between Tooltip and Target**
        let spacing: CGFloat = 40  // Ensure proper gap for the arrow
        let tooltipView = createTooltipView(below: targetFrame.offsetBy(dx: 0, dy: spacing))
        self.addSubview(tooltipView)
        
        // Add step indicator inside tooltip
        configureStepIndicator(in: tooltipView)

        // **Fix Dotted Line Position & Thickness**
//        let startPoint = CGPoint(x: targetFrame.midX, y: targetFrame.maxY + 8) // Below Target
//        let endPoint = CGPoint(x: tooltipView.frame.midX, y: tooltipView.frame.minY - 8) // Above Tooltip
        
        let startX = targetFrame.midX
        let endX = tooltipView.frame.midX
        let commonX = (startX + endX) / 2  // Ensures alignment along X-axis

        let startPoint = CGPoint(x: commonX, y: targetFrame.maxY + 5) // Below TargetView
        let endPoint = CGPoint(x: commonX, y: tooltipView.frame.minY - 5) // Above Tooltip
        
        let dottedLineView = DottedLineView(startPoint: startPoint, endPoint: endPoint)
        dottedLineView.frame = self.bounds
        dottedLineView.isUserInteractionEnabled = false // **Fix Click Issue**
        self.addSubview(dottedLineView)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func createTooltipView(below rect: CGRect) -> UIView {
        let tooltipView = UIView(frame: CGRect(x: 20, y: rect.maxY + 10, width: self.frame.width - 40, height: 145))
        tooltipView.backgroundColor = .white
        tooltipView.layer.cornerRadius = 12
        tooltipView.layer.shadowColor = UIColor.black.cgColor
        tooltipView.layer.shadowOpacity = 0.2
        tooltipView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tooltipView.layer.shadowRadius = 4
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 12, width: tooltipView.frame.width - 32, height: 22))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        tooltipView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 16, y: 38, width: tooltipView.frame.width - 32, height: 40))
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        tooltipView.addSubview(messageLabel)
        
        // Buttons Container
        let buttonsContainer = UIStackView(frame: CGRect(x: 16, y: 95, width: tooltipView.frame.width - 32, height: 35))
        buttonsContainer.axis = .horizontal
        buttonsContainer.alignment = .fill
        buttonsContainer.distribution = .fillEqually  // Ensures both buttons have the same width
        buttonsContainer.spacing = 10
        
        // Skip Button
        let skipButton = UIButton(type: .system)
        var skipConfig = UIButton.Configuration.filled()
        skipConfig.baseBackgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        skipConfig.baseForegroundColor = .black
        skipConfig.cornerStyle = .medium
        skipConfig.title = "Skip"
        skipButton.configuration = skipConfig
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        // Next/Done Button
        let nextButton = UIButton(type: .system)
        nextButton.setTitle(currentIndex == totalSteps ? "Ready to Explore" : "Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .red
        nextButton.layer.cornerRadius = 5
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        // Add both buttons to the stack view
        buttonsContainer.addArrangedSubview(skipButton)
        buttonsContainer.addArrangedSubview(nextButton)
        tooltipView.addSubview(buttonsContainer)
        
        // Hide Skip Button but Keep Its Space
        if currentIndex == totalSteps {
            skipButton.alpha = 0  // Hides it visually
            skipButton.isUserInteractionEnabled = false  // Disables interaction
        } else {
            skipButton.alpha = 1  // Shows it again
            skipButton.isUserInteractionEnabled = true  // Enables interaction
        }
        
        
        return tooltipView
    }
    
    private func configureStepIndicator(in tooltipView: UIView) {
        stepIndicatorLabel.text = "\(currentIndex)/\(totalSteps)"
        stepIndicatorLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        stepIndicatorLabel.textColor = UIColor.gray
        stepIndicatorLabel.textAlignment = .right
        stepIndicatorLabel.backgroundColor = .clear
        stepIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to the tooltip view
        tooltipView.addSubview(stepIndicatorLabel)
        
        // Constraints to position at the top-right corner of the tooltip view
        NSLayoutConstraint.activate([
            stepIndicatorLabel.topAnchor.constraint(equalTo: tooltipView.topAnchor, constant: 8),
            stepIndicatorLabel.trailingAnchor.constraint(equalTo: tooltipView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc private func skipTapped() {
        onSkip?()
        self.removeFromSuperview()
    }
    
    @objc private func nextTapped() {
        onNext?()
        self.removeFromSuperview()
    }
}
