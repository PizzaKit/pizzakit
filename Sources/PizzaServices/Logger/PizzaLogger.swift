import PizzaCore

public enum PizzaLoggerLevel: Int, CustomStringConvertible {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical

    public var description: String {
        switch self {
        case .trace:
            return "trace"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .notice:
            return "notice"
        case .warning:
            return "warning"
        case .error:
            return "error"
        case .critical:
            return "critical"
        }
    }
}

public enum PizzaLogger {
    public struct HandlerPayload {
        public let label: String
        public let level: PizzaLoggerLevel
        public let message: String
        public let payload: [String: Any]
        public let file: String
        public let function: String
        public let line: UInt
    }
    public static var handler: PizzaClosure<HandlerPayload>?
    public static func log(
        label: String,
        level: PizzaLoggerLevel,
        message: String,
        payload: [String: Any] = [:],
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        handler?(
            .init(
                label: label,
                level: level,
                message: message,
                payload: payload,
                file: file,
                function: function,
                line: line
            )
        )
    }
}
