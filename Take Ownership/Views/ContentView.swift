import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LogoView()
            FileSelector(ownershipTaker: OwnershipTaker(fileManager: FileManager.default))
        }
        .frame(width: 400.0, height: 530)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
