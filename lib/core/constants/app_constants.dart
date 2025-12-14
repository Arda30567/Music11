class AppConstants {
  // App Info
  static const String appName = 'Music Player';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Ultra Premium Music Player';
  
  // Audio Configuration
  static const int audioBufferSize = 8192;
  static const int audioSessionId = 0;
  static const String audioNotificationChannelId = 'com.musicplayer.channel';
  static const String audioNotificationChannelName = 'Music Player';
  
  // Database Configuration
  static const String databaseName = 'music_player.db';
  static const int databaseVersion = 1;
  
  // Preferences Keys
  static const String prefThemeMode = 'theme_mode';
  static const String prefEqualizerEnabled = 'equalizer_enabled';
  static const String prefEqualizerBands = 'equalizer_bands';
  static const String prefVolume = 'volume';
  static const String prefPlaybackSpeed = 'playback_speed';
  static const String prefShuffleMode = 'shuffle_mode';
  static const String prefRepeatMode = 'repeat_mode';
  
  // File Paths
  static const String musicDirectory = '/storage/emulated/0/Music';
  static const String downloadsDirectory = '/storage/emulated/0/Download';
  static const String appDataDirectory = '/data/data/com.musicplayer';
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.musicplayer.com';
  static const String apiTimeout = '30'; // seconds
  static const String apiRetryCount = '3';
  
  // UI Configuration
  static const int maxRecentSearches = 10;
  static const int maxPlaylistItems = 10000;
  static const int maxQueueItems = 1000;
  static const int animationDuration = 300; // milliseconds
  
  // Feature Flags
  static const bool enableEqualizer = true;
  static const bool enableLyrics = true;
  static const bool enableRecommendations = true;
  static const bool enableCrossfade = true;
  static const bool enableGaplessPlayback = true;
  static const bool enableSleepTimer = true;
  static const bool enablePodcastSupport = true;
  
  // Equalizer Configuration
  static const List<double> equalizerFrequencies = [
    60, 230, 910, 3600, 14000
  ];
  static const double equalizerMinGain = -12.0;
  static const double equalizerMaxGain = 12.0;
  static const double equalizerDefaultGain = 0.0;
  
  // Audio Effects Configuration
  static const double bassBoostMin = 0.0;
  static const double bassBoostMax = 100.0;
  static const double virtualizerMin = 0.0;
  static const double virtualizerMax = 100.0;
  static const double reverbMin = 0.0;
  static const double reverbMax = 100.0;
  
  // Playback Configuration
  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 2.0;
  static const double defaultPlaybackSpeed = 1.0;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const double defaultVolume = 0.8;
  
  // Sleep Timer Configuration
  static const int sleepTimerMinMinutes = 5;
  static const int sleepTimerMaxMinutes = 180;
  static const int sleepTimerDefaultMinutes = 30;
  
  // Search Configuration
  static const int searchDebounceMs = 300;
  static const int searchMinLength = 2;
  static const int searchMaxLength = 100;
  
  // Cache Configuration
  static const int cacheMaxSizeMB = 100;
  static const int cacheMaxEntries = 1000;
  static const int cacheExpirationDays = 7;
}