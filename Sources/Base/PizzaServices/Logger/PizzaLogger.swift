import PizzaCore
import Foundation

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

        public var toNSError: NSError {
            NSError(
                domain: label,
                code: 1,
                userInfo: payload
                    .merging(
                        [
                            "label": label,
                            "file": file,
                            "function": function,
                            "line": line,
                            "level": level.description,
                            "message": message
                        ],
                        uniquingKeysWith: { $1 }
                    )
            )
        }
    }
    public static var handlers: [PizzaClosure<HandlerPayload>] = []
    public static func log(
        label: String,
        level: PizzaLoggerLevel,
        message: String,
        payload: [String: Any] = [:],
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        handlers.forEach {
            $0(
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

    public static func tryCatchErrorAsync(
        label: String,
        block: () async throws -> Void,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) async {
        do {
            try await block()
        } catch {
            logError(
                label: label,
                error: error,
                file: file,
                function: function,
                line: line
            )
        }
    }

    public static func tryCatchError(
        label: String,
        block: () throws -> Void,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        do {
            try block()
        } catch {
            logError(
                label: label,
                error: error,
                file: file,
                function: function,
                line: line
            )
        }
    }

    public static func logError(
        label: String,
        error: Error,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        if let nsError = error as? NSError {
            log(
                label: label,
                level: .error,
                message: "NSError \(nsError.localizedDescription) occurred",
                payload: [
                    "nsError": nsError,
                    "userInfo": nsError.userInfo,
                    "domain": nsError.domain,
                    "code": nsError.code,
                    "underlyingErrors": nsError.underlyingErrors,
                    "localizedRecoverySuggestion": nsError.localizedRecoverySuggestion,
                    "localizedFailureReason": nsError.localizedFailureReason
                ],
                file: file,
                function: function,
                line: line
            )
        } else if let localizedError = error as? LocalizedError {
            log(
                label: label,
                level: .error,
                message: "LocalizedError \(localizedError.localizedDescription) occurred",
                payload: [
                    "error": localizedError,
                    "helpAnchor": localizedError.helpAnchor,
                    "errorDescription": localizedError.errorDescription,
                    "recoverySuggestion": localizedError.recoverySuggestion,
                    "failureReason": localizedError.failureReason
                ],
                file: file,
                function: function,
                line: line
            )
        } else {
            log(
                label: label,
                level: .error,
                message: "Error \(error.localizedDescription) occurred",
                payload: [
                    "error": error
                ],
                file: file,
                function: function,
                line: line
            )
        }
    }
}
