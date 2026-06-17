# FlopIn API Documentation
Base URL: http://localhost:3000/api/v1
Format: All request and response payloads utilize application/json with native Postgres UUID formats across primary/foreign keys.
1. Authentication Endpoints (Unprotected)
1.1 Native Password Signup
Endpoint: POST /auth/signup
Description: Registers a new account using an email and password. Automatically creates a login session.
Request Body
JSON
{
  "user": {
    "email": "userb@gmail.com",
    "username": "rndbn",
    "password": "supersecurepassword123"
  }
}

Success Response (201 Created)
JSON
{
  "access_token": "eyJhbGciOiJIUzI1NiJ9.ey...",
  "refresh_token": "a18ef7c4390b1c2d3e4f...",
  "user": {
    "id": "e3b0c442-98fc-11eb-a8b3-0242ac130003",
    "username": "rndbn",
    "email": "user@gmail.com"
  }
}

1.2 Native Password Login
Endpoint: POST /auth/login
Description: Validates credentials against password_digest and returns a new token pair.
Request Body
JSON
{
  "email": "user@gmail.com",
  "password": "supersecurepassword123"
}

Success Response (200 OK)
JSON
{
  "access_token": "eyJhbGciOiJIUzI1NiJ9.ey...",
  "refresh_token": "b92fd8d3401a2b3c4d5e...",
  "user": {
    "id": "e3b0c442-98fc-11eb-a8b3-0242ac130003",
    "username": "rndbn",
    "email": "user@gmail.com"
  }
}

1.3 Google OAuth Sign-In / Sign-Up
Endpoint: POST /auth/google
Description: Accepts Google Identity Provider tokens. Verifies signatures locally. If the email doesn't exist, it auto-registers a safe profile with a defensive high-entropy placeholder password hash.
Request Body
JSON
{
  "id_token": "AIzaSyD-google-identity-token-stream..."
}

Success Response (200 OK)
JSON
{
  "access_token": "eyJhbGciOiJIUzI1NiJ9.ey...",
  "refresh_token": "c73fe8b1029c3d4e5f6a...",
  "user": {
    "id": "e3b0c442-98fc-11eb-a8b3-0242ac130003",
    "username": "rndbn",
    "email": "user@gmail.com"
  }
}

1.4 Token Refresh Rotation
Endpoint: POST /auth/refresh
Description: Invoked silently when an access token expires. Deletes the passed refresh token to prevent replay attacks, generating a brand-new access token and rolling a new refresh token back to the client.
Request Body
JSON
{
  "refresh_token": "a18ef7c4390b1c2d3e4f..."
}

Success Response (200 OK)
JSON
{
  "access_token": "eyJhbGciOiJIUzI1NiJ9.ey...NEW_TOKEN",
  "refresh_token": "f48ab29c018d3e4f5a6b...NEW_ROTATED_TOKEN",
  "user": {
    "id": "e3b0c442-98fc-11eb-a8b3-0242ac130003",
    "username": "rndbn",
    "email": "user@gmail.com"
  }
}

2. Session Revocation (Protected)
2.1 Logout
Endpoint: DELETE /auth/logout
Description: Purges the passed tracking reference from the refresh_tokens database table.
Request Body
JSON
{
  "refresh_token": "f48ab29c018d3e4f5a6b..."
}

Success Response (200 OK)
JSON
{
  "message": "Logged out successfully"
}

3. Core Resource Feeds (Protected)
3.1 Get Homepage Feed (All Posts)
Endpoint: GET /posts
Description: Returns workplace timeline entries with categorical mapping, user details, aggregate reaction totals, and nested arrays of sticker metadata parsed straight out of message stories.
Request Body: None (Empty)
Success Response (200 OK)
JSON
[
  {
    "id": "7b8e12ac-34bc-41de-89fa-112233445566",
    "category": "Production Meltdown",
    "story": "hello hi :wave: I am stuck in deep :tutorial_hell:",
    "created_at": "2026-05-31T00:15:00.000Z",
    "user": {
      "id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
      "username": "rndbn"
    },
    "stickers": [
      {
        "id": "5fa23bc0-21de-49b8-ba90-5566778899aa",
        "name": "wave",
        "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780147789/flopin_stickers/wave.png"
      },
      {
        "id": "c10b47ac-58cc-4372-a567-0e02b2c3d479",
        "name": "tutorial_hell",
        "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780147900/flopin_stickers/tutorial_hell.png"
      }
    ],
    "reaction_counts": {
      "fail": 42,
      "relatable": 18,
      "dead": 5,
      "cheers": 0
    }
  }
]

3.2 Create a Failure Post
Endpoint: POST /posts
Description: Submits a failure snippet. Backend captures string via regex, matches active tokens, and creates relational rows inside your join table.
Request Body
JSON
{
  "post": {
    "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
    "category": "Production Meltdown",
    "story": "Dropped the main production database on day 3 of my internship. :general_mess:"
  }
}

Success Response (201 Created)
JSON
{
  "id": "8c9f23bd-45cd-52ef-90ab-223344556677",
  "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
  "category": "Production Meltdown",
  "story": "Dropped the main production database on day 3 of my internship. :general_mess:",
  "stickers": [
    {
      "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
      "name": "general_mess",
      "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780148100/flopin_stickers/general_mess.png"
    }
  ],
  "created_at": "2026-05-31T00:25:00.000Z",
  "updated_at": "2026-05-31T00:25:00.000Z"
}

3.3 Edit a Post
Endpoint: PUT /posts/:id or PATCH /posts/:id
Request Body
JSON
{
  "post": {
    "story": "Dropped the main production database on day 3 of my internship. Wiped out master entirely.",
    "category": "Git Tangle"
  }
}

Success Response (200 OK)
JSON
{
  "id": "8c9f23bd-45cd-52ef-90ab-223344556677",
  "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
  "category": "Git Tangle",
  "story": "Dropped the main production database on day 3 of my internship. Wiped out master entirely.",
  "stickers": [],
  "created_at": "2026-05-31T00:25:00.000Z",
  "updated_at": "2026-05-31T00:28:10.000Z"
}

3.4 Delete a Post
Endpoint: DELETE /posts/:id
Success Response: 204 No Content (Empty body)
3.5 Add/Update Reaction to a Post
Endpoint: POST /posts/:post_id/reactions
Description: Commits sentiment types (fail, relatable, dead, cheers). Overwrites previous selection for that specific user in place to prevent duplication.
Request Body
JSON
{
  "reaction": {
    "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
    "reaction_type": "relatable"
  }
}

Success Response (200 OK or 201 Created)
JSON
{
  "id": "9d0e14af-67df-63f0-01ba-334455667788",
  "post_id": "c44c98e5-17aa-4b2b-a863-08b026d9214b",
  "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
  "reaction_type": "relatable",
  "created_at": "2026-05-31T00:30:00.000Z",
  "updated_at": "2026-05-31T00:32:05.000Z"
}

4. User Profiles & Settings (Protected)
4.1 Get User Profile Summary
Endpoint: GET /users/:id
Description: Generates aggregate profile stats and returns the global system sticker dictionary asset list to instantiate input completion states on the frontend.
Request Body: None (Empty)
Success Response (200 OK)
JSON
{
  "id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
  "username": "rndbn",
  "profile_picture_url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780149100/flopin_avatars/rndbn_avatar_xyz789.png",
  "stats": {
    "posts_count": 14,
    "reactions_received_count": 523
  },
  "available_stickers": [
    {
      "id": "5fa23bc0-21de-49b8-ba90-5566778899aa",
      "name": "sad_pepe_dev",
      "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780147789/flopin_stickers/sad_pepe_dev.png"
    }
  ]
}

4.2 Update Profile Attributes / Avatar
Endpoint: PATCH /users/:id
Description: Patches core profile rows. Sending a cloudinary_public_id mounts a record inside the generic decoupled media index under the profile_picture enum, assigning it as the nullable foreign key avatar pointer.
Request Body
JSON
{
  "user": {
    "username": "rndbn_updated",
    "cloudinary_public_id": "flopin_avatars/rndbn_avatar_xyz789"
  }
}

Success Response (200 OK)
JSON
{
  "id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
  "username": "rndbn_updated",
  "profile_picture_url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780149100/flopin_avatars/rndbn_avatar_xyz789.png",
  "stats": {
    "posts_count": 14,
    "reactions_received_count": 523
  }
}

5. Media & Asset Utilities (Protected)
5.1 Get Cloudinary Direct Upload Signature
Endpoint: GET /media/signature?type=sticker (or type=profile_picture)
Description: Unified endpoint fetching short-lived credentials so Flutter clients can stream multipart asset binary data strings directly into target subfolders without utilizing server resources.
Request Body: None (Empty)
Success Response (200 OK)
JSON
{
  "signature": "b94f61230132b8aa07e6f827a3c3f15f0132890a",
  "timestamp": 1780147789,
  "api_key": "291331853196969",
  "cloud_name": "dopflwqoq",
  "folder": "flopin_stickers"
}

5.2 Register Custom Sticker Assets
Endpoint: POST /stickers
Description: Takes an asset footprint uploaded to storage and attaches its cloudinary_public_id reference to a unique trigger text token wrapper inside your tables.
Request Body
JSON
{
  "sticker": {
    "user_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574",
    "name": "sad_pepe_dev",
    "cloudinary_public_id": "flopin_stickers/sad_pepe_dev_abc123"
  }
}

Success Response (201 Created)
JSON
{
  "sticker_id": "5fa23bc0-21de-49b8-ba90-5566778899aa",
  "name": "sad_pepe_dev",
  "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780147789/flopin_stickers/sad_pepe_dev.png",
  "creator_id": "3a1f5f9e-dcf8-4c88-8e39-9c06e3719574"
}

5.3 List All Custom Stickers
Endpoint: GET /stickers
Description: Returns the global list of active platform stickers to populate the keyboard accessory tray layout.
Request Body: None (Empty)
Success Response (200 OK)
JSON
[
  {
    "id": "5fa23bc0-21de-49b8-ba90-5566778899aa",
    "name": "sad_pepe_dev",
    "url": "https://res.cloudinary.com/dopflwqoq/image/upload/v1780147789/flopin_stickers/sad_pepe_dev.png"
  }
]

6. Client Token Challenge Error Schema
Status Boundary: 401 Unauthorized
Description: Spitted back by your global filter if a token expiration event triggers, allowing easy interceptor detection in Flutter.
JSON
{
  "error": "Token expired",
  "code": "TOKEN_EXPIRED"
}

7. Client Data Validation Error Format
Status Boundary: 422 Unprocessable Entity
Description: Enforces schema unique constraints.
JSON
{
  "errors": [
    "Email has already been taken",
    "Username has already been taken",
    "Password is too short (minimum is 6 characters)"
  ]
}


