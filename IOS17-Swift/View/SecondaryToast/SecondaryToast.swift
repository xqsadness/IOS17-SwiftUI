//
//  SecondaryToast.swift
//  IOS17-Swift
//
//  Created by xqsadness on 3/6/25.
//

import SwiftUI

// MARK: - Toast Model
/// Define the Toast structure that represents a single toast message
struct SecondaryToast: Identifiable, Equatable {
    // Unique identifier for each toast instance (required by Identifiable protocol)
    let id = UUID()
    
    /// The type of toast (success, error, warning, etc.)
    let type: ToastType
    /// Main title text displayed in the toast
    let title: String
    /// Optional secondary message text
    let message: String?
    /// How long the toast should be displayed before auto-dismissing
    let duration: TimeInterval
    /// Position of the toast (top or bottom)
    let position: ToastPosition
    
    /// Custom initializer with default values
    init(type: ToastType, title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        self.type = type
        self.title = title
        self.message = message
        self.duration = duration
        self.position = position
    }
}

// Enumeration denoting all possible toast types
enum ToastType: CaseIterable {
    // Success toast for positive feedback
    case success
    // Error toast for failures and errors
    case error
    // Warning toast for cautionary messages
    case warning
    // Info toast for general information
    case info
    // Loading toast for ongoing processes
    case loading
    
    // Computed property that returns the appropriate SF Symbol name for each toast type
    var iconName: String {
        switch self {
        case .success:
            // Checkmark in circle for success
            return "checkmark.circle.fill"
        case .error:
            // X mark in circle for errors
            return "xmark.circle.fill"
        case .warning:
            // Triangle with exclamation for warnings
            return "exclamationmark.triangle.fill"
        case .info:
            // Info symbol in circle for information
            return "info.circle.fill"
        case .loading:
            // Rotating arrow for loading state
            return "arrow.clockwise"
        }
    }
    
    // Computed property that returns the primary color for each toast type
    var primaryColor: Color {
        switch self {
        case .success:
            // Green for positive actions
            return .green
        case .error:
            // Red for errors and failures
            return .red
        case .warning:
            // Orange for warnings and cautions
            return .orange
        case .info:
            // Blue for informational messages
            return .blue
        case .loading:
            // Gray for neutral loading state
            return .gray
        }
    }
    
    // Computed property that returns the background color with transparency for each toast type
    var backgroundColor: Color {
        switch self {
        case .success:
            // Light green background with 10% opacity
            return Color.green.opacity(0.1)
        case .error:
            // Light red background with 10% opacity
            return Color.red.opacity(0.1)
        case .warning:
            // Light orange background with 10% opacity
            return Color.orange.opacity(0.1)
        case .info:
            // Light blue background with 10% opacity
            return Color.blue.opacity(0.1)
        case .loading:
            // Light gray background with 10% opacity
            return Color.gray.opacity(0.1)
        }
    }
}

// Enumeration for toast position
enum ToastPosition {
    case top
    case bottom
}

// MARK: - Toast View
/// SwiftUI view that renders a single toast message
struct SecondaryToastView: View {
    let toast: SecondaryToast
    @State private var isVisible = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Group {
                if toast.type == .loading {
                    Image(systemName: toast.type.iconName)
                        .foregroundColor(toast.type.primaryColor)
                        .rotationEffect(.degrees(rotationAngle))
                        .onAppear {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                                rotationAngle = 360
                            }
                        }
                } else {
                    Image(systemName: toast.type.iconName)
                        .foregroundColor(toast.type.primaryColor)
                }
            }
            .font(.system(size: 28, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                if let message = toast.message {
                    Text(message)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: 350, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(toast.type.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(toast.type.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .scaleEffect(isVisible ? 1 : 0.92)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.75)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Toast Manager
/// Observable class that manages all toast messages and their lifecycle
class SecondaryToastManager: ObservableObject {
    // Published array of active toasts (automatically updates UI when changed)
    @Published var toasts: [SecondaryToast] = []
    
    // Maximum number of toasts that can be shown at once
    let maxToasts: Int
    
    // Initialize with maximum number of toasts
    init(maxToasts: Int = 3) {
        self.maxToasts = maxToasts
    }
    
    // Method to display a new toast
    func show(_ toast: SecondaryToast) {
        // Check if we need to remove oldest toast
        if toasts.count >= maxToasts {
            // Remove the oldest toast (first in array)
            if let oldestToast = toasts.first {
                dismiss(oldestToast)
            }
        }
        
        // Add the new toast to the active toasts array
        toasts.append(toast)
        
        // Schedule automatic dismissal after the specified duration
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
            // Remove the toast after its duration expires
            self.dismiss(toast)
        }
    }
    
    // Convenience methods for different toast types
    func showSuccess(title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        show(SecondaryToast(type: .success, title: title, message: message, duration: duration, position: position))
    }
    
    func showError(title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        show(SecondaryToast(type: .error, title: title, message: message, duration: duration, position: position))
    }
    
    func showWarning(title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        show(SecondaryToast(type: .warning, title: title, message: message, duration: duration, position: position))
    }
    
    func showInfo(title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        show(SecondaryToast(type: .info, title: title, message: message, duration: duration, position: position))
    }
    
    func showLoading(title: String, message: String? = nil, duration: TimeInterval = 3.0, position: ToastPosition = .bottom) {
        show(SecondaryToast(type: .loading, title: title, message: message, duration: duration, position: position))
    }
    
    // Method to dismiss a specific toast
    func dismiss(_ toast: SecondaryToast) {
        // Animate the removal of the toast
        withAnimation(.easeInOut(duration: 0.3)) {
            // Remove the toast with matching ID from the array
            toasts.removeAll { $0.id == toast.id }
        }
    }
    
    // Method to dismiss all active toasts
    func dismissAll() {
        // Animate the removal of all toasts
        withAnimation(.easeInOut(duration: 0.3)) {
            // Clear the entire toasts array
            toasts.removeAll()
        }
    }
}

// MARK: - Toast Container View
/// Container view that displays all active toasts in a stack
struct ToastContainerView: View {
    // Access the shared ToastManager from the environment
    @EnvironmentObject var toastManager: SecondaryToastManager
    
    var body: some View {
        // Vertical stack that positions toasts
        VStack {
            // Show toasts at top if they have top position
            VStack(spacing: 8) {
                ForEach(toastManager.toasts.filter { $0.position == .top }) { toast in
                    SecondaryToastView(toast: toast)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                        .onTapGesture {
                            toastManager.dismiss(toast)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Spacer()
            
            // Show toasts at bottom if they have bottom position
            VStack(spacing: 8) {
                ForEach(toastManager.toasts.filter { $0.position == .bottom }) { toast in
                    SecondaryToastView(toast: toast)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .onTapGesture {
                            toastManager.dismiss(toast)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        // Prevent toasts from blocking touches to underlying content
        .allowsHitTesting(false)
    }
}

// MARK: - View Extension for Toast
/// Extension to easily add toast functionality to any view
extension View {
    /// Method that adds toast functionality to any view
    func toast(maxToasts: Int = 3) -> some View {
        // Return the view with toast container overlay
        return self
            .overlay(
                ToastContainerView()
            )
    }
}

// MARK: - Demo Content View
/// Demo view that showcases all toast types with interactive buttons
struct SecondaryToastViewDemo: View {
    // Access the ToastManager from the environment to trigger toasts
    @StateObject private var toastManager = SecondaryToastManager(maxToasts: 3)
    
    var body: some View {
        // Navigation wrapper for the demo content
        NavigationView {
            // Scrollable content area
            ScrollView {
                // Main content stack
                VStack(spacing: 20) {
                    // Main title
                    Text("Toast Message System")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Subtitle description
                    Text("Tap buttons below to test different toast types")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Grid layout for toast demo buttons
                    LazyVGrid(columns: [
                        // Two flexible columns
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        
                        // Success toast demo button
                        ToastButton(
                            title: "Success",
                            color: .green,
                            icon: "checkmark.circle.fill"
                        ) {
                            // Show success toast when tapped
                            toastManager.show(.init(type: .success, title: "abc", message: "mess"))
                        }
                        
                        // Error toast demo button
                        ToastButton(
                            title: "Error",
                            color: .red,
                            icon: "xmark.circle.fill"
                        ) {
                            // Show error toast when tapped
                            toastManager.show(.init(type: .error, title: "Error Occurred", message: "Something went wrong. Please try again."))
                        }
                        
                        // Warning toast demo button
                        ToastButton(
                            title: "Warning",
                            color: .orange,
                            icon: "exclamationmark.triangle.fill"
                        ) {
                            // Show warning toast when tapped
                            toastManager.showWarning(
                                title: "Warning",
                                message: "Please check your input and try again."
                            )
                        }
                        
                        // Info toast demo button
                        ToastButton(
                            title: "Info",
                            color: .blue,
                            icon: "info.circle.fill"
                        ) {
                            // Show info toast when tapped
                            toastManager.showInfo(
                                title: "Information",
                                message: "Here's some helpful information for you."
                            )
                        }
                        
                        // Loading toast demo button
                        ToastButton(
                            title: "Loading",
                            color: .gray,
                            icon: "arrow.clockwise"
                        ) {
                            // Show loading toast when tapped
                            toastManager.showLoading(
                                title: "Loading...",
                                message: "Please wait while we process your request."
                            )
                        }
                        
                        // Clear all toasts demo button
                        ToastButton(
                            title: "Clear All",
                            color: .purple,
                            icon: "trash.fill"
                        ) {
                            // Dismiss all active toasts when tapped
                            toastManager.dismissAll()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 200)
                }
            }
            .navigationBarHidden(true)
        }
        .toast(maxToasts: 3)
        .environmentObject(toastManager)    
    }
}

// MARK: - Toast Button Component
/// Reusable button component for the demo interface
struct ToastButton: View {
    // Button display text
    let title: String
    // Theme tone color
    let color: Color
    // SF Symbol icon name
    let icon: String
    // Action to execute when button is tapped
    let action: () -> Void
    
    var body: some View {
        // Button wrapper
        Button(action: action) {
            // Vertical stack for icon and text
            VStack(spacing: 8) {
                // Button icon
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                
                // Button title text
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            // Make button fill available width
            .frame(maxWidth: .infinity)
            // Set fixed height for consistent appearance
            .frame(height: 80)
            // Button background styling
            .background(
                RoundedRectangle(cornerRadius: 12)
                // Light background with theme color
                    .fill(color.opacity(0.1))
                // Border with theme color
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        // Remove default button styling to use custom appearance
        .buttonStyle(PlainButtonStyle())
    }
}
