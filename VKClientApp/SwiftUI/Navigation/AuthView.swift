//
//  AuthView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 04.05.2022.
//

import Combine
import SwiftUI
import CodingStyle

struct AuthView: View {
    @State private var login = ""
    @State private var password = ""
    @State private var shouldShowLogo = true
    @State private var showAlert = false
    @Binding var isUserLoggedIn: Bool
    @CodingStyle(coding: .camel) var appName = "My VK client app"
    var presentWebLogin: (() -> Void)?

    private let keyboardIsOnPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for:
            UIResponder.keyboardWillChangeFrameNotification)
            .map { _ in true },
        NotificationCenter.default.publisher(for:
            UIResponder.keyboardWillHideNotification)
            .map { _ in false }
    ).removeDuplicates()

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                SwiftUI.Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            }
            ScrollView(showsIndicators: false) {
                VStack {
                    if shouldShowLogo {
                        Text(appName)
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }
                    VStack {
                        HStack {
                            Text("Login:")
                            Spacer()
                            TextField("", text: $login)
                                .frame(maxWidth: 150)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Password:")
                            Spacer()
                            SecureField("", text: $password)
                                .frame(maxWidth: 150)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }.frame(maxWidth: 250)
                        .padding(.top, 20)
                    Button(action: {
                        if isValid() {
                            self.presentWebLogin?()
                            isUserLoggedIn = true
                        } else {
                            self.showAlert = true
                        }
                    }) {
                        Text("Log in")
                            .font(.title)
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .padding(10)
                            .border(Color.white, width: 10)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(login.isEmpty || password.isEmpty)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("invalid Login/Password"), dismissButton: .default(Text("Ok")))
                    }
                }
            }
            .onReceive(keyboardIsOnPublisher) { isKeyboardOn in
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    self.shouldShowLogo = !isKeyboardOn
                }
            }
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private func isValid() -> Bool {
        login == "Admin" && password == "123"
    }
}
