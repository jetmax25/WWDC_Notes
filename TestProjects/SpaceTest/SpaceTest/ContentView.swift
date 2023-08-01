//
//  ContentView.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Recent", systemImage: "hourglass")
                }
            PicByDateView()
                .tabItem {
                    Label("Date", systemImage: "calendar")
                }
            EndlessView()
                .tabItem {
                    Label("Endless", systemImage: "infinity")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
