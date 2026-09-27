import SwiftUI

struct ContentView: View {
    // The text entered by the user is stored in these @State variables:
    @State private var email = ""
    @State private var password = ""

    @State private var isLoggingIn = false
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    // FocusState makes it possible to move from the email field to the password field
    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Email")
                .font(.headline)

            TextField("yourname@example.com", text: $email)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }

            Text("Password")
                .font(.headline)

            SecureField("Your password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    login()
                }

            HStack {
                Spacer()

                Button("Login") {
                    login()
                }

                Spacer()
            }

            if isLoggingIn {
                HStack {
                    Spacer()
                    ProgressView("Logging in...")
                    Spacer()
                }
            }

            Spacer()
        }
        .padding()
        .disabled(isLoggingIn)
        .alert(alertTitle, isPresented: $isShowingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }

    private func login() {
        // Remove the keyboard when the login starts
        focusedField = nil

        guard !email.isEmpty, !password.isEmpty else {
            showAlert(
                title: "Missing information",
                message: "Please enter your email address and password."
            )
            return
        }

        isLoggingIn = true

        // To simulate the asynchronous nature of the login, use the following code snippet:
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoggingIn = false

            if email == "student@example.com" && password == "password123" {
                showAlert(
                    title: "Login successful",
                    message: "Welcome!"
                )
            } else {
                showAlert(
                    title: "Login failed",
                    message: "The email address or password is incorrect."
                )
            }
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isShowingAlert = true
    }
}

#Preview {
    ContentView()
}
