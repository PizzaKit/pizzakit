import UIKit

/// CALayer subclass, который анимирует внутреннее свойство progress,
/// при изменении этого свойства у view, которая ассоциирована с этим слоем
/// будет вызываться display
///
/// Как работать с этим слоем
/// 1. Создаем view и меняем layerClass на текущий
/// 2. Реализуем метод display(layer) и внутри заполняем другие слоя/view на основе
///    `(layer as! PizzaProgressTrackLayer).displayProgress`
/// 3. Настраиваем длительность анимации `configure(animationDuration:)`
/// 4. Выставляем прогресс, когда это необходимо `update(progress:animated:)`
open class PizzaProgressTrackLayer: CALayer {

    /// Текущий выставленный progress
    public var progress: CGFloat {
        customProgress - 1
    }

    /// Прогресс, который нужно использовать в реализации метода display у view
    public var displayProgress: CGFloat {
        // фикс случая, когда мы отменяем анимацию и хотим засеттить значение без анимации.
        // тогда если проверить, то presentation будет существовать, но нам оттуда значение брать не нужно
        if animationKeys()?.contains("customProgress") == true, let presentation = presentation() {
            return presentation.progress
        }
        return progress
    }

    /// делаем от 1 до 2, чтобы потом отнять единицу - чтобы initial display происходил.
    /// Наверно NSManaged дефолтное значение 0, поэтому не происходит initial display
    @NSManaged private(set) var customProgress: CGFloat

    open override class func needsDisplay(forKey key: String) -> Bool {
        if key == "customProgress" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    open override func action(forKey event: String) -> CAAction? {
        let superAction = super.action(forKey: event)
        if event == "customProgress" && needAnimate, let animationDuration {
            let animation = CABasicAnimation(keyPath: "customProgress")
            if let presentation = presentation() {
                animation.fromValue = presentation.customProgress
            }
            animation.toValue = nil
            animation.duration = animationDuration
            return animation
        }
        return superAction
    }

    private var needAnimate = false
    open func update(progress: CGFloat, animated: Bool) {
        self.needAnimate = animated
        self.removeAllAnimations()
        self.customProgress = progress + 1
        self.needAnimate = false
    }

    private var animationDuration: TimeInterval?
    open func configure(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }

    public override init() {
        super.init()
    }

    public override init(layer: Any) {
        super.init(layer: layer)

        if let other = layer as? PizzaProgressTrackLayer {
            self.customProgress = other.customProgress
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
