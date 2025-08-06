# Facebook Integration

This document describes the Facebook integration feature that allows users to post content to their Facebook account, including their wall, stories, and managed pages.

## Features

### 1. Authentication & Authorization
- OAuth-based authentication using Facebook's API
- Secure token management
- Support for multiple permissions (profile, pages, posting)

### 2. Post Targets
- **Personal Wall**: Post to user's personal timeline
- **Stories**: Share content to user's story (planned)
- **Managed Pages**: Post to Facebook pages the user manages

### 3. Permission Management
- Automatic permission checking for managed pages
- Request additional permissions when needed
- Visual indicators for insufficient permissions

### 4. Content Types
- Text posts
- Posts with image URLs
- Support for hashtags and metadata

## Architecture

### Modular Design
The integration is built using a modular architecture to support future social media platforms:

```
lib/
├── models/
│   ├── post_target.dart    # Target definitions (wall, story, page)
│   └── social_post.dart    # Post content model
├── services/
│   ├── social_media_service.dart  # Abstract interface
│   └── facebook_service.dart      # Facebook implementation
└── screens/
    └── facebook_post_screen.dart  # UI for posting
```

### Key Components

#### 1. SocialMediaService (Abstract)
Defines the interface for all social media integrations:
- Authentication methods
- Post target retrieval
- Content posting
- Permission management

#### 2. FacebookService
Implements the Facebook-specific functionality:
- OAuth authentication flow
- Facebook Graph API integration
- Page access token management
- Error handling

#### 3. FacebookPostScreen
Provides the user interface for:
- Authentication status
- Target selection
- Content composition
- Posting and feedback

## Usage

### 1. Authentication
Users must first authenticate with Facebook by clicking "Sign in with Facebook" on the Facebook integration screen.

### 2. Selecting Targets
After authentication, users can choose from:
- My Wall (personal timeline)
- My Story (story posting)
- Managed pages (if any)

### 3. Posting Content
Users can:
- Enter text content
- Add image URLs
- Select the target destination
- Post to Facebook

## Dependencies

- `flutter_facebook_auth`: Facebook authentication
- `http`: API calls to Facebook Graph API
- `provider`: State management

## Configuration

### Facebook App Setup
To use this integration, you need to:

1. Create a Facebook App in Facebook Developer Console
2. Configure OAuth redirect URLs
3. Request necessary permissions:
   - `email`
   - `public_profile`
   - `pages_show_list`
   - `pages_read_engagement`
   - `pages_manage_posts`
   - `publish_to_groups`

### Platform Configuration
- **Android**: Configure Facebook App ID in `android/app/src/main/res/values/strings.xml`
- **iOS**: Configure Facebook App ID in `ios/Runner/Info.plist`

## Future Enhancements

1. **Story Posting**: Complete implementation of story posting
2. **Media Upload**: Support for uploading images/videos directly
3. **Scheduled Posts**: Allow users to schedule posts
4. **Analytics**: Post performance tracking
5. **Multiple Platforms**: Extend to Instagram, Twitter, etc.

## Error Handling

The integration includes comprehensive error handling for:
- Authentication failures
- Network connectivity issues
- Permission denied scenarios
- API rate limiting
- Invalid content formats

## Testing

Unit tests are provided for:
- Service initialization
- Model creation and validation
- Data serialization
- Error scenarios

To run tests:
```bash
flutter test
```

## Security Considerations

- Access tokens are stored securely
- Permissions are checked before posting
- User data is not stored locally
- All API calls use HTTPS