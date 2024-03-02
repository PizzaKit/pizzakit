import Combine

// TODO: realize publisher with defaults library combine support
// (когда обновление происходит при выставлении ключа в UserDefaults)
public class PizzaRPublisher<ValueType, ErrorType: Error> {
    public var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        fatalError()
    }
    public var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        fatalError()
    }
    public var value: ValueType {
        fatalError()
    }

    init() {}
}

public class PizzaRWPublisher<ValueType, ErrorType: Error>: PizzaRPublisher<ValueType, ErrorType> {
    public override var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        fatalError()
    }
    public override var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        fatalError()
    }
    public override var value: ValueType {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    override init() {}
}

public class PizzaCurrentValueRWPublisher<ValueType, ErrorType: Error>: PizzaRWPublisher<ValueType, ErrorType> {
    private let _subject: CurrentValueSubject<ValueType, ErrorType>

    public override var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject.eraseToAnyPublisher()
    }
    public override var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject
            .dropFirst()
            .eraseToAnyPublisher()
    }
    public override var value: ValueType {
        get {
            _subject.value
        }
        set {
            _subject.value = newValue
        }
    }

    public init(subject: CurrentValueSubject<ValueType, ErrorType>) {
        self._subject = subject
    }
}

public class PizzaPassthroughRWPublisher<ValueType, ErrorType: Error>: PizzaRWPublisher<ValueType, ErrorType> {
    private var _currentValue: PizzaEmptyReturnClosure<ValueType>
    private let _subject: PassthroughSubject<ValueType, ErrorType>
    private let _onValueChanged: PizzaClosure<ValueType>

    public override var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return Just(_currentValue())
            .setFailureType(to: ErrorType.self)
            .merge(with: _subject.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }
    public override var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject.eraseToAnyPublisher()
    }
    public override var value: ValueType {
        get {
            _currentValue()
        }
        set {
            _onValueChanged(newValue)
            _subject.send(newValue)
        }
    }

    public init(
        currentValue: @escaping PizzaEmptyReturnClosure<ValueType>,
        onValueChanged: @escaping PizzaClosure<ValueType>
    ) {
        self._currentValue = currentValue
        self._subject = .init()
        self._onValueChanged = onValueChanged
    }

    public func setNeedsUpdate() {
        self.value = _currentValue()
    }
}

public class PizzaCurrentValueRPublisher<ValueType, ErrorType: Error>: PizzaRPublisher<ValueType, ErrorType> {
    private let _subject: CurrentValueSubject<ValueType, ErrorType>

    public override var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject.eraseToAnyPublisher()
    }
    public override var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject
            .dropFirst()
            .eraseToAnyPublisher()
    }
    public override var value: ValueType {
        get {
            _subject.value
        }
    }

    public init(subject: CurrentValueSubject<ValueType, ErrorType>) {
        self._subject = subject
    }
}

public class PizzaPassthroughRPublisher<ValueType, ErrorType: Error>: PizzaRPublisher<ValueType, ErrorType> {
    private var _currentValue: PizzaEmptyReturnClosure<ValueType>
    private let _subject: PassthroughSubject<ValueType, ErrorType>

    public override var withCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return Just(_currentValue())
            .setFailureType(to: ErrorType.self)
            .merge(with: _subject.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }
    public override var withoutCurrentValue: AnyPublisher<ValueType, ErrorType> {
        return _subject.eraseToAnyPublisher()
    }
    public override var value: ValueType {
        _currentValue()
    }

    public init(
        currentValue: @escaping PizzaEmptyReturnClosure<ValueType>
    ) {
        self._currentValue = currentValue
        self._subject = .init()
    }

    public func setNeedsUpdate() {
        _subject.send(_currentValue())
    }
}
