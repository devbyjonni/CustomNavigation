//
//  ContentView.swift
//  CustomNavigation
//
//  Created by Jonni Akesson on 2022-05-15.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    @State var barColor: Color = .init(white: 0)
    @State var barTextColor: Color = .primary
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // MARK: Sample data
                    ForEach(1...30, id: \.self) { index in
                        HStack(spacing: 15) {
                            let opacity = 0.5
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.gray.opacity(opacity))
                                .frame(width: 50, height: 50)
                                .padding(.vertical, 4)
                            VStack(alignment: .leading, spacing: 15) {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.gray.opacity(opacity))
                                    .frame(height: 10)
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.gray.opacity(opacity))
                                    .frame(height: 10)
                                    .padding(.trailing, 90)
                            }
                        }
                    }
                } header: {
                    Picker(selection: $barColor) {
                        Text("Pink")
                            .tag(Color.pink)
                        Text("White")
                            .tag(Color.white)
                        
                    } label: {
                        
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Custom Navigation")
            .toolbar {
                Button("Reset") {
                    barColor = .init(white: 0)
                    resetNavBar()
                }
            }
        }
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search items"))
        .onAppear {
            setNavbarColor(color: .white)
            setNavbarTitleColor(color: .gray)
        }
        .onChange(of: barColor) { newValue in
            if barColor == Color.init(white: 0){ return }
            setNavbarColor(color: barColor)
            setNavbarTitleColor(color: .blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}


// MARK: Customization Options for Navigation Bar
extension View{
    
    func setNavbarColor(color: Color) {
        
        // MARK: Updating Nav Bar Color
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil, userInfo: [
                // Sending Color
                "color": color
            ])
        }
    }
    
    func resetNavBar(){
        // MARK: Resetting Nav Bar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil)
        }
    }
    
    func setNavbarTitleColor(color: Color){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil,userInfo: [
                // Sending Color
                "color": color,
                "forTitle": true
            ])
        }
    }
}

// MARK: NavigationController Helpers
extension UINavigationController{
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Since it's base navigation Controller load method
        // so what ever changes done here will reflect on navigation bar
        
        // MARK: Notification Observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavBar(notification:)), name: NSNotification.Name("UPDATENAVBAR"), object: nil)
    }
    
    @objc
    func updateNavBar(notification: Notification){
        
        if let info = notification.userInfo{
            
            let color = info["color"] as! Color
            
            if let _ = info["forTitle"]{
                
                // MARK: Title Color
                // Update color in Apperance
                navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                navigationBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                navigationBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.compactAppearance?.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                return
            }
            
            if color == .clear{
                
                // Transparent Nav Bar
                let transparentApperance = UINavigationBarAppearance()
                transparentApperance.configureWithTransparentBackground()
                
                navigationBar.standardAppearance = transparentApperance
                navigationBar.scrollEdgeAppearance = transparentApperance
                navigationBar.compactAppearance = transparentApperance
                
                return
            }
            
            // MARK: Updating Nav Bar Color
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = UIColor(color)
            
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = apperance
            navigationBar.compactAppearance = apperance
        }
        else{
            // MARK: Reset Nav bar
            let apperance = UINavigationBarAppearance()
            
            let transparentApperance = UINavigationBarAppearance()
            transparentApperance.configureWithTransparentBackground()
            
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = transparentApperance
            navigationBar.compactAppearance = apperance
        }
    }
}
