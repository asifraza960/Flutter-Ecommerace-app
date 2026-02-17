# E-Commerce Flutter Application

A modern, feature-rich e-commerce mobile application built with Flutter following MVVM architecture and using BLoC for state management.

## 📱 Features

### Core Features ✅
- **Product Listing**: Browse all products in a beautiful grid layout with images, titles, prices, and ratings
- **Product Details**: View comprehensive product information including description, category, price, and ratings
- **Shopping Cart**: View cart items with quantity, remove options, and total calculation
- **User Profile**: Display user information including name, email, phone, and address

### Bonus Features ✅
- **Pull-to-Refresh**: Refresh product list and cart with a simple pull gesture
- **Dark Mode Toggle**: Switch between light and dark themes seamlessly
- **Search Functionality**: Search products by title, description, or category in real-time
- **Responsive UI**: Clean, modern interface that works on all screen sizes

## 🏗️ Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture with the following structure:

```
lib/
├── models/           # Data models (Product, Cart, User)
├── views/            # UI screens
├── cubits/           # State management (BLoC/Cubit)
├── services/         # API services
└── main.dart         # App entry point
```

## 🛠️ Technologies Used

- **Flutter SDK**: ^3.10.7
- **State Management**: flutter_bloc (Cubit) ^8.1.3
- **HTTP Client**: dio ^5.4.0
- **Image Caching**: cached_network_image ^3.3.0
- **Local Storage**: shared_preferences ^2.2.2
- **Immutable State**: equatable ^2.0.5

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A device or emulator to run the app

### Installation

1. **Clone the repository** (or extract the ZIP file)
   ```bash
   cd flutter_application_1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   Or press F5 in VS Code / Run button in Android Studio

### Build for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📖 API Reference

The app uses [Fake Store API](https://fakestoreapi.com/) for data:

- **Products**: `GET /products` - Fetch all products
- **Product Detail**: `GET /products/:id` - Get single product
- **User Cart**: `GET /carts/user/:userId` - Get user's cart
- **User Info**: `GET /users/:id` - Get user details

## 🎨 Features in Detail

### 1. Product Listing Screen
- Grid layout with 2 columns
- Product image, title, price, and rating
- Real-time search functionality
- Pull-to-refresh capability
- Smooth navigation to product details

### 2. Product Detail Screen
- Full-screen product image with hero animation
- Complete product information
- Category badge
- Star rating display
- Add to cart button (with confirmation)

### 3. Shopping Cart Screen
- List of cart items with images
- Quantity and price per item
- Swipe-to-delete functionality
- Total items and amount calculation
- Empty state with call-to-action

### 4. User Profile Screen
- User avatar with initials
- Contact information (email, phone)
- Complete address details
- Edit profile and logout buttons
- Pull-to-refresh capability

### 5. Dark Mode
- Toggle between light and dark themes
- Persisted using SharedPreferences
- Smooth theme transitions
- Consistent styling across all screens

## 📱 Screenshots

The app features:
- Clean, modern Material Design 3 UI
- Consistent color scheme (Blue theme)
- Smooth animations and transitions
- Proper loading, error, and empty states
- Professional typography and spacing

## 🧪 Testing

The app handles various states:
- ✅ **Loading State**: Shows circular progress indicator
- ✅ **Success State**: Displays data with smooth animations
- ✅ **Error State**: Shows error message with retry button
- ✅ **Empty State**: Displays helpful message and actions

## 🔄 State Management

Using **BLoC Pattern (Cubit)**:
- `ProductCubit`: Manages product list and search
- `CartCubit`: Handles cart operations and calculations
- `UserCubit`: Manages user profile data
- `ThemeCubit`: Controls dark/light theme

## 📝 Code Quality

- ✅ Clean code with proper naming conventions
- ✅ Separation of concerns (MVVM)
- ✅ Immutable state using Equatable
- ✅ Proper error handling
- ✅ Consistent file structure
- ✅ Type-safe models with JSON serialization

## 🎯 Requirements Checklist

### Core Requirements
- [x] Product listing with grid/list view
- [x] Product details screen
- [x] Cart management with quantity and total
- [x] User profile with basic details
- [x] MVVM folder structure
- [x] Dio for HTTP requests
- [x] BLoC/Cubit state management
- [x] Loading, error, and empty states
- [x] Responsive UI and good UX

### Bonus Features
- [x] Pull-to-refresh on product list
- [x] Dark mode toggle
- [x] Search bar for products

## 🐛 Known Limitations

- Cart modifications (add/remove) are simulated (API doesn't support POST/DELETE)
- User authentication is mocked (uses fixed userId: 1)
- Checkout functionality is placeholder

## 👨‍💻 Developer

Built with ❤️ following Flutter best practices and clean architecture principles.

## 📄 License

This project is created for demonstration purposes.

---

**Note**: This app was built according to the Flutter Development Assignment requirements, implementing all core features and bonus features with professional code quality and UI/UX design.

