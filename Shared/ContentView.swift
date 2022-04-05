//
//  ContentView.swift
//  WatchConnectivityTest
//
//  Created by Leo Dion on 3/30/22.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @EnvironmentObject var object: WCObject
    #if os(iOS)
        static let padding = 20.0
    #else
        static let padding = 0.0

    #endif
    static let activationStateSystemNames = [
        "bolt.slash.circle",
        "bolt.slash.circle.fill",
        "bolt.circle.fill"
    ]
    static let activationStateNames = [
        "Not Activated",
        "Inactive",
        "Active"
    ]
    static let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]

    var body: some View {
        #if os(watchOS)
      watchOSBody.onAppear(perform: self.object.forceActivate)
        #else
            iOSBody.onAppear(perform: self.object.forceActivate)
        #endif
    }

    var watchOSBody: some View {
        VStack {
            HStack {
                VStack {
                    Rectangle().fill(object.lastColorReceived ?? Color.secondary).cornerRadius(8.0).aspectRatio(1.0, contentMode: .fit)
                }
                VStack {
                    Rectangle().fill(object.lastColorSent ?? Color.secondary).cornerRadius(8.0).aspectRatio(1.0, contentMode: .fit)
                }
            }
            HStack {
                HStack {
                    Image(systemName: object.isReachable ? "applewatch.watchface" : "exclamationmark.applewatch")
                }
                HStack {
                    Image(systemName: object.isCompanionAppInstalled ? "applewatch.watchface" : "square.and.arrow.down")
                }
                HStack {
                    Image(systemName: Self.activationStateSystemNames[self.object.activationState.rawValue])
                }

                HStack {
                    Image(systemName: self.object.lastError != nil ? "xmark.circle.fill" : "octagon")
                }.opacity(self.object.lastError != nil ? 1.0 : 0.2)
            }
            HStack {
                ForEach(0 ..< 6) { index in
                    Button {
                        object.sendColor(Self.colors[index])
                    } label: {
                        Text("   ")
                    }.padding(Self.padding).background(Self.colors[index]).cornerRadius(4.0)
                }
            }.padding()
        }
    }

    var iOSBody: some View {
        Form {
            Section(header: Text("Color Status")) {
                HStack {
                    List {
                        VStack {
                            Rectangle().fill(object.lastColorReceived ?? Color.secondary).cornerRadius(8.0).aspectRatio(1.0, contentMode: .fit)
                            HStack {
                                Image(systemName: "applewatch.radiowaves.left.and.right")
                                Text("Received").font(.system(size: 12.0))
                                Image(systemName: "iphone.and.arrow.forward")
                            }
                        }
                        VStack {
                            Rectangle().fill(object.lastColorSent ?? Color.secondary).cornerRadius(8.0).aspectRatio(1.0, contentMode: .fit)
                            HStack {
                                Image(systemName: "iphone.radiowaves.left.and.right")
                                Text("Sent").font(.system(size: 12.0))
                                Image(systemName: "applewatch")
                            }
                        }
                    }
                }.padding()
            }
            #if os(iOS)
                Section(header: Text("Communication Status")) {
                    List {
                        HStack {
                            Image(systemName: object.isReachable ? "applewatch.watchface" : "exclamationmark.applewatch")
                            Text(object.isReachable ? "Reachable" : "Not Reachable")
                        }
                        HStack {
                            Image(systemName: object.isPaired ? "applewatch.watchface" : "applewatch.slash")
                            Text(object.isPaired ? "Paired" : "Not Paired")
                        }
                        HStack {
                            Image(systemName: object.isCompanionAppInstalled ? "applewatch.watchface" : "square.and.arrow.down")
                            Text(object.isCompanionAppInstalled ? "Installed" : "Not Installed")
                        }
                        HStack {
                            Image(systemName: Self.activationStateSystemNames[self.object.activationState.rawValue])
                            Text(Self.activationStateNames[self.object.activationState.rawValue])
                        }

                        HStack {
                            Image(systemName: self.object.lastError != nil ? "xmark.circle.fill" : "octagon")
                            Text(self.object.lastError?.localizedDescription ?? "No Error")
                        }.opacity(self.object.lastError != nil ? 1.0 : 0.2)
                    }
                }
            #endif
            Section(header: Text("send color")) {
                HStack {
                    ForEach(0 ..< 6) { index in
                        Button {
                            object.sendColor(Self.colors[index])
                        } label: {
                            Text("   ")
                        }.padding(Self.padding).background(Self.colors[index]).cornerRadius(4.0)
                    }
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(WCObject())
    }
}
