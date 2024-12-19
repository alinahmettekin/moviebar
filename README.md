![Screenshot_1734629025](https://github.com/user-attachments/assets/e6714c83-2d06-4d1d-b975-b927d00989b8)# MovieBar

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
![Screenshot_1734629025](https://github.com/user-attachments/assets/b016974d-6948-4948-aa73-fe8a06be4de6)
![Screenshot_1734629098](https://github.com/user-attachments/assets/48a93997-38a5-48a3-ac20-a3c053efd489)

### Categories Page
![Screenshot_1734629050](https://github.com/user-attachments/assets/41e03b5f-3622-41b4-921f-18d7ac6075c8)

### Search Page
![Screenshot_1734629175](https://github.com/user-attachments/assets/ff7edb92-cf9f-41d5-83c2-f0c5488865ae)

### Movie Detail Page
![Screenshot_1734629206](https://github.com/user-attachments/assets/0aa73b48-f2cf-4dd2-96e8-6ed1700ffc05)

### Tv Show Detail Page
![Screenshot_1734629225](https://github.com/user-attachments/assets/cb68f2d2-3f58-40e5-bbf5-ed08f6f7c523)
![Screenshot_1734630160](https://github.com/user-attachments/assets/1d1bef75-41eb-45e9-8705-35fbafe14d0a)

### Person Detail Page
![Screenshot_1734629281](https://github.com/user-attachments/assets/6f4f72e0-bef1-467a-8233-f924908e4b77)
![Screenshot_1734630094](https://github.com/user-attachments/assets/fcf033a1-40cf-41ce-8e22-02ff16813f40)

### Profile View
![Screenshot_1734629188](https://github.com/user-attachments/assets/57d1d17a-0c55-418f-8b2b-0b49c8f79231)
