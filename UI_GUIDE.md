# UI Screenshots and Visual Guide

## Main App Navigation

The app now includes three main sections accessible via the navigation rail:

1. **Home** (🏠): Original word generator functionality
2. **Favorites** (❤️): View saved favorite word pairs
3. **Facebook** (📘): New Facebook integration feature

## Facebook Integration Screens

### 1. Authentication Screen
**When user is not authenticated:**
```
┌─────────────────────────────────────┐
│ Facebook Integration            [⬅] │
├─────────────────────────────────────┤
│                                     │
│           📘 Facebook               │
│                                     │
│        Connect to Facebook          │
│                                     │
│    Sign in to Facebook to share     │
│    your content with friends and    │
│           followers.                │
│                                     │
│   [🔑 Sign in with Facebook]        │
│                                     │
└─────────────────────────────────────┘
```

### 2. Posting Interface
**When user is authenticated:**
```
┌─────────────────────────────────────┐
│ Facebook Integration        [🚪 ⬅] │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Post to:                        │ │
│ │ [👤 My Wall              ▼]     │ │
│ │   Post to your personal timeline│ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Content:                        │ │
│ │ ┌─────────────────────────────┐ │ │
│ │ │ What's on your mind?        │ │ │
│ │ │                             │ │ │
│ │ │                             │ │ │
│ │ └─────────────────────────────┘ │ │
│ │                                 │ │
│ │ Image URL (optional):           │ │
│ │ ┌─────────────────────────────┐ │ │
│ │ │ https://example.com/image...│ │ │
│ │ └─────────────────────────────┘ │ │
│ └─────────────────────────────────┘ │
│                                     │
│      [📤 Post to Facebook]          │
│                                     │
└─────────────────────────────────────┘
```

### 3. Post Target Options
**Dropdown showing available targets:**
```
┌─────────────────────────────────┐
│ 👤 My Wall                      │
│   Post to your personal timeline│
├─────────────────────────────────┤
│ 📷 My Story                     │
│   Share to your story           │
├─────────────────────────────────┤
│ 🏢 Business Page Name           │
│   Post to Business Page Name    │
└─────────────────────────────────┘
```

### 4. Success/Error States
**Success message:**
```
┌─────────────────────────────────┐
│ ✅ Successfully posted to My    │
│    Wall!                        │
└─────────────────────────────────┘
```

**Error message:**
```
┌─────────────────────────────────┐
│ ❌ Authentication failed.       │
│    Please try again.            │
└─────────────────────────────────┘
```

## Key UI Features

### Visual Indicators
- **Authentication Status**: Clear login/logout states
- **Permission Warnings**: Orange warning icons for insufficient permissions
- **Loading States**: Progress indicators during API calls
- **Target Icons**: Different icons for wall (👤), story (📷), and pages (🏢)

### User Experience
- **Responsive Design**: Works on different screen sizes
- **Clear Navigation**: Easy access via navigation rail
- **Form Validation**: Ensures content is entered before posting
- **Feedback**: Clear success/error messages
- **Accessibility**: Semantic labels and proper focus handling

### Color Scheme
- **Primary Actions**: Blue (Facebook brand color)
- **Success**: Green
- **Errors**: Red
- **Warnings**: Orange
- **Background**: Follows app theme (orange-based)