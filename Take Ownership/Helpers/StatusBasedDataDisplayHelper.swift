import SwiftUI

func getColorBy(_ status: TaskStatus?) -> Color {
    switch status {
    case nil:
        return .gray
    case .error:
        return .red
    case .success:
        return .green
    }
}

func getIconBy(_ status: TaskStatus?) -> String {
    switch status {
    case nil:
        return "plus.app"
    case .error:
        return "x.circle.fill"
    case .success:
        return "checkmark.circle.fill"
    }
}

func getTaskTextBy(_ status: TaskStatus?) -> String {
    switch status {
    case nil:
        return String.localized("TaskStatusReady")
    case .error:
        return String.localized("TaskStatusError")
    case .success:
        return String.localized("TaskStatusSuccess")
    }
}

func getHintTextByStatus(_ status: TaskStatus?) -> String {
    switch status {
    case nil:
        return String.localized("HintDetails")
    case .error:
        return String.localized("HintError")
    case .success:
        return String.localized("HintSuccess").replacingOccurrences(of: "%s", with: NSUserName())
    }
}
