//
//  ContentView.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @ScaledMetric var scale: CGFloat = 1
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack(alignment: .center, spacing: 5) {
                        Image("")
                            .resizable()
                            .frame(width: 50 * scale, height: 50 * scale)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recipe's name")
                                .font(.headline)
                            
                            Text("Recipe's type of cuisine")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
