//
//  ContentView.swift
//  LoginApi
//
//  Created by Aji Suryawan on 01/08/20.
//  Copyright © 2020 RPL RUS. All rights reserved.
//

import SwiftUI
import Combine
let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)



struct ServerMessage : Decodable {
    let success : String
    let user_id : Int
    let role : Int
}



func postAdd(email : String , password : String, completion:@escaping(String, String)->()) {
    
    let url = URL(string: "https://api-ios.admin.tangriaspa.com/api/user/login")
    let bodi: [String : String] = ["email" : email , "password" : password , "fcm_token" : "123"]
    
    let finalBody = try! JSONSerialization.data(withJSONObject: bodi)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = finalBody
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if error == nil, let data = data, let response = response as? HTTPURLResponse {
            print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
            print("statusCode: \(response.statusCode)")
            let finalData = try! JSONDecoder().decode(ServerMessage.self , from : data)
            //print(finalData.success)
            completion(String(finalData.success),String(finalData.user_id))
            print(String(data: data, encoding: .utf8) ?? "")
        } else {
            completion("404","error")
        }
    }.resume()
    
}


struct ContentView: View {
    @ObservedObject var userSettings = UserSettings()
    @State private var showDetails = false
    @State private var isAlert = false
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        LoadingView(isShowing: .constant(showDetails)) {
            ZStack  {
                VStack {
                    Text("Login Form")
                    
                    UsernameTextField(username: self.$username)
                    PasswordSecureField(password: self.$password)
                    Button(action: {
                        self.showDetails = true
                        print(self.username)
                        print(self.password)
                        
                        //self.manager.checkDetails(email: self.username, password: self.password)
                        postAdd(email: self.username, password: self.password) { data, data2 in
                            print("makanan "+String(data) + " , minuman : "+String(data2))
                            self.userSettings.email = self.username
                            self.userSettings.username = data
                            self.userSettings.desc = data2
                            
                            self.showDetails = false
                            self.isAlert = true
                        }
                        
                    }) {
                        LoginButtonContent()
                    }
                }
                .padding()
                if self.isAlert {
                    NavigationView {
                        
                        Loadingku()
                    }
                }
                
            }
            
        }
        
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
struct LoadingView<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
    
}

struct LoginButtonContent: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
    }
}

struct UsernameTextField: View {
    
    @Binding var username: String
    
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}

struct PasswordSecureField: View {
    
    @Binding var password: String
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
