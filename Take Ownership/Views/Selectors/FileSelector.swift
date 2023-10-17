import SwiftUI

struct FileSelector: View {
    @State
    var status: TaskStatus?
    var ownershipTaker: OwnershipTaker
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(getColorBy(status), style: StrokeStyle(lineWidth: 6, dash: [11.7]))
                .foregroundColor(Color.black.opacity(0.5))
                .frame(width: 340, height: 300)
                .overlay(
                    ZStack{
                        VStack() {
                            Image(systemName: getIconBy(status))
                                .foregroundColor(getColorBy(status))
                                .font(.system(size: 60))
                            Text(getTaskTextBy(status))
                                .foregroundColor(getColorBy(status))
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(20.0)
                        }
                    }
                )
                .contentShape(RoundedRectangle(cornerRadius: 25))
                .onTapGesture {
                    status = .none
                    if let url = openFileSelectorPanel() {
                        let ownershipTaken = ownershipTaker.takeOwnership(url)
                        handleTakeOwnershipResult(success: ownershipTaken)
                    }
                }
                .onDrop(of: [.fileURL], isTargeted: nil, perform: { providers, _ in
                    status = .none
                    takeOwnershipFileDropped(providers: providers)
                    return true
                })
            Text(getHintTextByStatus(status))
                .foregroundColor(Color.gray)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(7.0)
                .padding(.bottom, 5)
                .fixedSize()
        }
        .frame(width: 340.0, height: 350.0)
        .padding()
        .fixedSize()
    }
    
    private func handleTakeOwnershipResult(success: Bool) {
        if (success) {
            showSuccess()
        } else {
            showError()
        }
    }
    
    private func showSuccess() {
        status = .success
        scheduleStatusReset(resetAfterSeconds: 5.0)
    }
    
    private func showError() {
        status = .error
        scheduleStatusReset(resetAfterSeconds: 7.0)
    }
    
    private func scheduleStatusReset(resetAfterSeconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfterSeconds) {
            status = .none
        }
    }
    
    private func takeOwnershipFileDropped(providers: [NSItemProvider]) {
        if let item = providers.first {
            let _ = item.loadObject(ofClass: URL.self) { object, error in
                if let url = object {
                    let ownershipTaken = ownershipTaker.takeOwnership(url)
                    handleTakeOwnershipResult(success: ownershipTaken)
                }
            }
        }
    }
}

private func openFileSelectorPanel() -> URL? {
    let panel = NSOpenPanel()
    panel.title = String.localized("SelectFilePanelText")
    panel.allowsMultipleSelection = false;
    panel.canChooseDirectories = false;
    return panel.runModal() == .OK ? panel.url?.absoluteURL : nil
}

struct FileSelector_Previews: PreviewProvider {
    static var previews: some View {
        FileSelector(ownershipTaker: OwnershipTaker())
    }
}
