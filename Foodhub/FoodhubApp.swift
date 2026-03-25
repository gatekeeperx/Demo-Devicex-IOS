//
//  FoodhubApp.swift
//  Foodhub
//
//  Created by Yury Camacho on 03/03/2026.
//

import SwiftUI
import DeviceX

@main
struct FoodhubApp: App {
    init() {
        Task {
            do {
                try await Devicex.configureGloballyAsync { config in
                    config.setApiKey("YOUR_API_KEY")
                    config.setTenant("YOUR_TENANT")
                    config.setEnvironment(.sandbox)
                }
                if let version = try? Devicex.instance.version {
                    print("Devicex inicializado correctamente - version: \(version)")
                }
            } catch {
                print("Error al inicializar Devicex: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
