//
//  NeumorphicDesign.swift
//  BillingApp
//
//  Neumorphic Design System — Soft UI Components & Tokens
//

import SwiftUI

// MARK: - Design Tokens

enum NeuTheme {
    // Base background color — the core of neumorphism
    static let baseColor = Color(red: 0.90, green: 0.91, blue: 0.93)
    static let baseDark = Color(red: 0.82, green: 0.83, blue: 0.86)
    
    // Accent colors
    static let greenAccent = Color(red: 0.18, green: 0.49, blue: 0.20)
    static let greenLight = Color(red: 0.30, green: 0.69, blue: 0.31)
    static let blueAccent = Color(red: 0.13, green: 0.37, blue: 0.66)
    static let redAccent = Color(red: 0.78, green: 0.15, blue: 0.16)
    static let orangeAccent = Color(red: 0.90, green: 0.49, blue: 0.13)
    static let goldAccent = Color(red: 0.83, green: 0.69, blue: 0.22)
    
    // Shadow parameters
    static let shadowLight = Color.white.opacity(0.70)
    static let shadowDark = Color.black.opacity(0.18)
    static let shadowRadius: CGFloat = 8
    static let shadowOffset: CGFloat = 6
    
    // Corner radius
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 24
    
    // Spacing
    static let padding: CGFloat = 16
    static let paddingSmall: CGFloat = 10
    static let paddingLarge: CGFloat = 24
    
    // Gradients
    static let greenGradient = LinearGradient(
        colors: [greenLight, greenAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [blueAccent.opacity(0.8), blueAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [baseColor, baseDark],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Neumorphic View Modifier

struct NeuRaised: ViewModifier {
    var radius: CGFloat = NeuTheme.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .background(NeuTheme.baseColor)
            .cornerRadius(radius)
            .shadow(color: NeuTheme.shadowLight, radius: NeuTheme.shadowRadius, x: -NeuTheme.shadowOffset, y: -NeuTheme.shadowOffset)
            .shadow(color: NeuTheme.shadowDark, radius: NeuTheme.shadowRadius, x: NeuTheme.shadowOffset, y: NeuTheme.shadowOffset)
    }
}

struct NeuPressed: ViewModifier {
    var radius: CGFloat = NeuTheme.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .background(NeuTheme.baseColor)
            .cornerRadius(radius)
            .shadow(color: NeuTheme.shadowLight, radius: 2, x: -2, y: -2)
            .shadow(color: NeuTheme.shadowDark, radius: 2, x: 2, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.black.opacity(0.03))
            )
    }
}

struct NeuInset: ViewModifier {
    var radius: CGFloat = NeuTheme.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(NeuTheme.baseColor)
                    .shadow(color: NeuTheme.shadowDark, radius: 3, x: -3, y: -3)
                    .shadow(color: NeuTheme.shadowLight, radius: 3, x: 3, y: 3)
                    .innerShadow(using: RoundedRectangle(cornerRadius: radius))
            )
            .cornerRadius(radius)
    }
}

// MARK: - Inner Shadow Extension

extension Shape {
    func innerShadow(using shape: Self, color: Color = Color.black.opacity(0.12), radius: CGFloat = 4) -> some View {
        self
            .fill(NeuTheme.baseColor)
            .overlay(
                shape
                    .stroke(color, lineWidth: 1)
                    .blur(radius: radius)
                    .mask(shape)
            )
    }
}

extension View {
    func innerShadow<S: Shape>(using shape: S, color: Color = Color.black.opacity(0.12), radius: CGFloat = 4) -> some View {
        self.overlay(
            shape
                .stroke(color, lineWidth: 1)
                .blur(radius: radius)
                .mask(shape)
        )
    }
}

// MARK: - View Extensions

extension View {
    func neuRaised(radius: CGFloat = NeuTheme.cornerRadius) -> some View {
        modifier(NeuRaised(radius: radius))
    }
    
    func neuPressed(radius: CGFloat = NeuTheme.cornerRadius) -> some View {
        modifier(NeuPressed(radius: radius))
    }
    
    func neuInset(radius: CGFloat = NeuTheme.cornerRadius) -> some View {
        modifier(NeuInset(radius: radius))
    }
}

// MARK: - Reusable Neumorphic Components

/// A soft, raised card container
struct NeuCard<Content: View>: View {
    var radius: CGFloat = NeuTheme.cornerRadius
    var padding: CGFloat = NeuTheme.padding
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(padding)
        .neuRaised(radius: radius)
    }
}

/// A soft, inset card container (for fields, inputs)
struct NeuInsetCard<Content: View>: View {
    var radius: CGFloat = NeuTheme.cornerRadiusSmall
    var padding: CGFloat = NeuTheme.padding
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .padding(padding)
        .background(NeuTheme.baseColor)
        .cornerRadius(radius)
        .shadow(color: NeuTheme.shadowDark, radius: 3, x: -3, y: -3)
        .shadow(color: NeuTheme.shadowLight, radius: 3, x: 3, y: 3)
    }
}

/// Neumorphic button with press animation
struct NeuButton: View {
    var title: String
    var icon: String? = nil
    var gradient: LinearGradient = NeuTheme.greenGradient
    var shadowColor: Color = NeuTheme.greenAccent
    var foregroundColor: Color = .white
    var fontSize: CGFloat = 16
    var action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: fontSize, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: fontSize, weight: .semibold))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: NeuTheme.cornerRadius)
                    .fill(gradient)
                    .shadow(color: shadowColor.opacity(0.4), radius: isPressed ? 2 : 6, x: 0, y: isPressed ? 2 : 4)
            )
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

/// Neumorphic soft button (non-gradient, base color)
struct NeuSoftButton: View {
    var title: String
    var icon: String? = nil
    var accentColor: Color = NeuTheme.greenAccent
    var action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(accentColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(NeuTheme.baseColor)
            .cornerRadius(NeuTheme.cornerRadius)
            .shadow(color: NeuTheme.shadowLight, radius: isPressed ? 1 : NeuTheme.shadowRadius, x: isPressed ? -1 : -NeuTheme.shadowOffset, y: isPressed ? -1 : -NeuTheme.shadowOffset)
            .shadow(color: NeuTheme.shadowDark, radius: isPressed ? 1 : NeuTheme.shadowRadius, x: isPressed ? 1 : NeuTheme.shadowOffset, y: isPressed ? 1 : NeuTheme.shadowOffset)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

/// Neumorphic text field
struct NeuTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var borderColor: Color? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(borderColor != nil ? borderColor! : .gray)
                    .font(.system(size: 16))
            }
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .keyboardType(keyboardType)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(NeuTheme.baseColor)
        .cornerRadius(NeuTheme.cornerRadiusSmall)
        .shadow(color: NeuTheme.shadowDark, radius: 3, x: -3, y: -3)
        .shadow(color: NeuTheme.shadowLight, radius: 3, x: 3, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: NeuTheme.cornerRadiusSmall)
                .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 2 : 0)
        )
    }
}

/// Neumorphic circular icon badge
struct NeuCircleIcon: View {
    var systemName: String
    var size: CGFloat = 44
    var iconSize: CGFloat = 18
    var accentColor: Color = NeuTheme.greenAccent
    
    var body: some View {
        ZStack {
            Circle()
                .fill(NeuTheme.baseColor)
                .frame(width: size, height: size)
                .shadow(color: NeuTheme.shadowLight, radius: NeuTheme.shadowRadius, x: -NeuTheme.shadowOffset, y: -NeuTheme.shadowOffset)
                .shadow(color: NeuTheme.shadowDark, radius: NeuTheme.shadowRadius, x: NeuTheme.shadowOffset, y: NeuTheme.shadowOffset)
            
            Image(systemName: systemName)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(accentColor)
        }
    }
}

/// Floating Action Button (FAB) — neumorphic style
struct NeuFab: View {
    var icon: String = "plus"
    var accentColor: Color = NeuTheme.greenAccent
    var action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(NeuTheme.baseColor)
                    .frame(width: 60, height: 60)
                    .shadow(color: NeuTheme.shadowLight, radius: isPressed ? 2 : NeuTheme.shadowRadius, x: isPressed ? -1 : -NeuTheme.shadowOffset, y: isPressed ? -1 : -NeuTheme.shadowOffset)
                    .shadow(color: NeuTheme.shadowDark, radius: isPressed ? 2 : NeuTheme.shadowRadius, x: isPressed ? 1 : NeuTheme.shadowOffset, y: isPressed ? 1 : NeuTheme.shadowOffset)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(accentColor)
                    .rotationEffect(.degrees(isPressed ? 45 : 0))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

/// Neumorphic search bar
struct NeuSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(NeuTheme.baseColor)
        .cornerRadius(NeuTheme.cornerRadius)
        .shadow(color: NeuTheme.shadowDark, radius: 3, x: -3, y: -3)
        .shadow(color: NeuTheme.shadowLight, radius: 3, x: 3, y: 3)
    }
}

/// Neumorphic section header
struct NeuSectionHeader: View {
    var title: String
    var icon: String? = nil
    
    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(NeuTheme.greenAccent)
            }
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
    }
}

/// Neumorphic badge / pill
struct NeuBadge: View {
    var text: String
    var color: Color = NeuTheme.greenAccent
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color.opacity(0.12))
            )
    }
}

/// Neumorphic divider
struct NeuDivider: View {
    var body: some View {
        Rectangle()
            .fill(NeuTheme.baseColor)
            .frame(height: 2)
            .shadow(color: NeuTheme.shadowLight, radius: 1, x: 0, y: -1)
            .shadow(color: NeuTheme.shadowDark, radius: 1, x: 0, y: 1)
            .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        NeuTheme.baseColor.ignoresSafeArea()
        
        ScrollView {
            VStack(spacing: 24) {
                NeuCard {
                    Text("Raised Card").font(.headline)
                    Text("This is a neumorphic raised card component.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                NeuInsetCard {
                    Text("Inset Card").font(.headline)
                    Text("This is a neumorphic inset card — great for inputs.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                NeuButton(title: "Generate Bill", icon: "cart.fill") {}
                
                NeuSoftButton(title: "View Details", icon: "eye.fill") {}
                
                NeuButton(title: "Receive Payment", icon: "dollarsign.circle.fill", gradient: NeuTheme.blueGradient) {}
                
                HStack(spacing: 16) {
                    NeuCircleIcon(systemName: "leaf.fill", accentColor: NeuTheme.greenAccent)
                    NeuCircleIcon(systemName: "cart.fill", accentColor: NeuTheme.blueAccent)
                    NeuCircleIcon(systemName: "person.fill", accentColor: NeuTheme.orangeAccent)
                }
                
                NeuBadge(text: "₹250.00 Credit", color: NeuTheme.redAccent)
                NeuBadge(text: "Paid", color: NeuTheme.greenAccent)
                
                NeuDivider()
            }
            .padding()
        }
    }
}
