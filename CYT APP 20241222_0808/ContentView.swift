//
//  ContentView.swift
//  CYT APP 20241222_0808
//
//  Created by Deon Janse van Noordwyk on 2024/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "book.fill")
                }
            
            DebtView()
                .tabItem {
                    Label("Debt", systemImage: "dollarsign.circle.fill")
                }
            
            WealthView()
                .tabItem {
                    Label("Wealth", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
