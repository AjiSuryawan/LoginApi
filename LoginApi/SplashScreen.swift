//
//  SplashScreen.swift
//  LoginApi
//
//  Created by Aji Suryawan on 02/08/20.
//  Copyright © 2020 RPL RUS. All rights reserved.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @ObservedObject var userSettings = UserSettings()
    var body: some View {
        VStack {
            if self.userSettings.email.isEmpty || self.userSettings.email == "" {
                NavigationView {
                    ContentView()
                }
            }else{
                NavigationView {
                    Loadingku()
                }
            }
//            Spacer()
//            Image("login_title")
//                .resizable()
//                .scaledToFit()
//
//            Spacer()
        }.padding()
    }
}
