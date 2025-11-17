//
//  LoadingStateView.swift
//  VentureVoyage
//
//  Reusable loading state components for consistent UX
//  Provides various loading indicators and empty states
//

import SwiftUI

// MARK: - Loading State View

/// Main loading state view with customizable message
struct LoadingStateView: View {
    let message: String
    let style: LoadingStyle

    init(message: String = "Loading...", style: LoadingStyle = .default) {
        self.message = message
        self.style = style
    }

    var body: some View {
        VStack(spacing: 20) {
            switch style {
            case .default:
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.blue)

            case .circular:
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)

            case .custom(let color):
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(color)

            case .dots:
                DotsLoadingView()
            }

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

/// Loading style options
enum LoadingStyle {
    case `default`
    case circular
    case custom(Color)
    case dots
}

// MARK: - Dots Loading View

/// Animated dots loading indicator
struct DotsLoadingView: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

// MARK: - Skeleton Loading View

/// Skeleton loading view for content placeholders
struct SkeletonLoadingView: View {
    @State private var animating = false

    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    init(width: CGFloat = 200, height: CGFloat = 20, cornerRadius: CGFloat = 4) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color(.systemGray6),
                        Color(.systemGray5)
                    ]),
                    startPoint: animating ? .leading : .trailing,
                    endPoint: animating ? .trailing : .leading
                )
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    animating.toggle()
                }
            }
    }
}

// MARK: - Empty State View

/// Empty state view with icon and message
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Retry State View

/// Retry state view for error scenarios
struct RetryStateView: View {
    let errorMessage: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            VStack(spacing: 12) {
                Text("Something went wrong")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Inline Loading View

/// Inline loading view for buttons or small spaces
struct InlineLoadingView: View {
    let text: String
    let color: Color

    init(text: String = "Loading", color: Color = .blue) {
        self.text = text
        self.color = color
    }

    var body: some View {
        HStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
                .tint(color)

            Text(text)
                .font(.subheadline)
                .foregroundColor(color)
        }
    }
}

// MARK: - Loading Overlay

/// Full-screen loading overlay
struct LoadingOverlay: View {
    let message: String
    let showBackground: Bool

    init(message: String = "Loading...", showBackground: Bool = true) {
        self.message = message
        self.showBackground = showBackground
    }

    var body: some View {
        ZStack {
            if showBackground {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
            }

            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray))
            )
        }
    }
}

// MARK: - View Extension

extension View {
    /// Adds a loading overlay to the view
    func loadingOverlay(
        isLoading: Bool,
        message: String = "Loading..."
    ) -> some View {
        ZStack {
            self

            if isLoading {
                LoadingOverlay(message: message)
            }
        }
    }
}

// MARK: - Previews

#Preview("Loading State") {
    LoadingStateView(message: "Generating your business ideas...")
}

#Preview("Empty State") {
    EmptyStateView(
        icon: "lightbulb.slash",
        title: "No Ideas Yet",
        message: "Generate your first business idea to get started on your entrepreneurial journey",
        actionTitle: "Generate Ideas",
        action: {}
    )
}

#Preview("Retry State") {
    RetryStateView(
        errorMessage: "Unable to connect to the server. Please check your internet connection and try again.",
        retryAction: {}
    )
}

#Preview("Dots Loading") {
    DotsLoadingView()
}

#Preview("Skeleton Loading") {
    VStack(spacing: 16) {
        SkeletonLoadingView(width: 300, height: 20)
        SkeletonLoadingView(width: 250, height: 20)
        SkeletonLoadingView(width: 200, height: 20)
    }
}
