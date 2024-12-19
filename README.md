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

### Home Page
![Screenshot_1734629025](https://github.com/user-attachments/assets/6b0838d8-d629-41d2-82f6-5757d0fe9040)
![Screenshot_1734629098](https://github.com/user-attachments/assets/e67d25f5-f6bb-42d4-a9a0-68b0d336dcfc)

### Categories Page
![Screenshot_1734629050](https://github.com/user-attachments/assets/595adee4-79d3-416a-932b-0fab346401fd)

### Search Page
![Screenshot_1734629175](https://github.com/user-attachments/assets/11097cf0-6200-4b35-9a21-79b5ff4cb5f6)

### Movie Detail Page
![Screenshot_1734629206](https://github.com/user-attachments/assets/c1e413c4-c135-4b5b-abf9-4fe421e70f8b)

### Tv Show Detail Page
![Screenshot_1734629225](https://github.com/user-attachments/assets/190814e5-cdc3-47ae-be15-bf95ecd17414)
![Screenshot_1734630160](https://github.com/user-attachments/assets/f876764f-e7ae-4737-b2bf-d1d989ef9e32)

### Person Detail Page
![Screenshot_1734629281](https://github.com/user-attachments/assets/77e9f6fd-f582-4907-8666-09983d091b22)
![Screenshot_1734630094](https://github.com/user-attachments/assets/7f8e9f5c-5c8e-40ed-ab07-8536de07c733)

### Profile View
![Screenshot_1734629188](https://github.com/user-attachments/assets/e48b5a60-14c5-4f8f-bda9-75cb2558971a)

