import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("Logo")
            .resizable(resizingMode: .stretch)
            .frame(width: 80.0, height: 80.0)
            .padding(.top, 10.0)
        Text(String.localized("TakeOwnershipName"))
            .font(.title)
            .padding(.top, -5)
    }
}
