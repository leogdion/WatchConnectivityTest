import SwiftUI
import SundialKit

struct PreviewContentView: View {
  var body: some View {
    ContentView().environmentObject(WCObject())
  }
}

struct PreviewContentView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewContentView()
  }
}
