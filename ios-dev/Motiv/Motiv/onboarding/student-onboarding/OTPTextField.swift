//
//  OTPTextField.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI
import Combine


// A SwiftUI view for entering OTP (One-Time Password).
struct OTPTextField: View {
    
    @FocusState private var pinFocusState: FocusPin?
    @Binding private var otp: String
    @State private var pins: [String]
    
    var numberOfFields: Int
    
    enum FocusPin: Hashable {
        case pin(Int)
    }
    
    init(numberOfFields: Int, otp: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otp = otp
        self._pins = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $pins[index])
                    .modifier(OtpModifier(pin: $pins[index]))
                    .foregroundColor(.white)
                    .onChange(of: pins[index]) { newVal in
                        if newVal.count == 1 {
                            if index < numberOfFields - 1 {
                                pinFocusState = FocusPin.pin(index + 1)
                            } else {
                                // Uncomment this if you want to clear focus after the last digit
                                // pinFocusState = nil
                            }
                        }
                        else if newVal.count == numberOfFields, let intValue = Int(newVal) {
                            // Pasted value
                            otp = newVal
                            updatePinsFromOTP()
                            pinFocusState = FocusPin.pin(numberOfFields - 1)
                        }
                        else if newVal.isEmpty {
                            if index > 0 {
                                pinFocusState = FocusPin.pin(index - 1)
                            }
                        }
                        updateOTPString()
                    }
                    .focused($pinFocusState, equals: FocusPin.pin(index))
                    .onTapGesture {
                        // Set focus to the current field when tapped
                        pinFocusState = FocusPin.pin(index)
                    }
            }
        }
        .onAppear {
            // Initialize pins based on the OTP string
            updatePinsFromOTP()
        }
    }
    
    private func updatePinsFromOTP() {
        let otpArray = Array(otp.prefix(numberOfFields))
        for (index, char) in otpArray.enumerated() {
            pins[index] = String(char)
        }
    }
    
    private func updateOTPString() {
        otp = pins.joined()
    }
}

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    var textLimit = 1
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 48, height: 58)
            .font(.custom("F37Ginger-Light", size: 18))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("SheetGrey"))
            )
    }
}

struct OTPTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("VERIFICATION CODE")
                .foregroundColor(Color.gray)
                .font(.system(size: 12))
            OTPTextField(numberOfFields: 5, otp: .constant("54321"))
                .previewLayout(.sizeThatFits)
        }
    }
}
