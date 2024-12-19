# MovieBar

MovieBar is a modern Flutter application that allows users to discover, search, and track movies, TV shows and actors using The Movie Database (TMDB) API. The app provides a seamless user experience for exploring media content and managing personal watchlists.

## Features

- **Authentication**: Secure login and account management using TMDB credentials
- **Search**: Advanced search functionality for movies, TV shows, and people
- **Discovery**: Browse trending, popular, and upcoming content
- **Watchlist Management**: Add/remove content to personal watchlists
- **Detailed Information**: Access comprehensive details about movies and TV shows
- **Responsive Design**: Optimized for both mobile and tablet devices

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- TMDB API Key
- TMDB ACCES TOKEN (TMDB Api read token for v4 requests)
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/moviebar.git
cd moviebar
```

2. Install dependencies:

```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your TMDB API key:

```
TMDB_API_KEY=your_api_key_here
TMDB_ACCES_TOKEN =your_access_token_here
```

4. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── providers/           # API services and network calls
│   ├── models/              # Data models
│   └── utils/               # Utility functions and constants
├── view/
│   ├── navigation/          # Controller for navigations
│   ├── auth/                # Authentication related screens and logic
│   ├── home/                # Provides popular movies and show
│   ├── search/              # Search functionality
│   ├── categories/          # Discover by categories
│   ├── profile/             # User's profile page
│   ├── movie_detail/        # Detail page for movies
│   ├── tv_show_detail/      # Detail page for tv shows
│   ├── person_detail/       # Detail page for actors, directors etc.
│   ├── search/              # Search functionality
│   |
|   ├── widgets/
│
└── main.dart
```

## Architecture

MovieBar follows a clean architecture pattern with:

- Provider for state management
- Repository pattern for data handling
- Service layer for API communication
- Feature-first folder structure

## Dependencies

Key packages used in the project:

- `provider`: State management
- `dio`: HTTP client for API requests
- `shared_preferences`: Local storage
- `flutter_dotenv`: Environment configuration
- `cached_network_image`: Caching images

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## Screenshots

[Place your app screenshots here]
