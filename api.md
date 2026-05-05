# API Documentation

## Base URL
`https://g3bfvqjf-8000.uks1.devtunnels.ms`

## Authentication

### 1. Sign Up
- **Endpoint**: `/api/signup/`
- **Method**: `POST`
- **Request Body**:
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone_number": "0123456789",
  "password": "password123",
  "confirm_password": "password123"
}
```
- **Success Response**: `201 Created`
- **Error Response**: `400 Bad Request` (Validation errors)

### 2. Sign In
- **Endpoint**: `/api/login/` (Assumed)
- **Method**: `POST`
- **Request Body**:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```
- **Success Response**: `200 OK` (Token/User data)
- **Error Response**: `401 Unauthorized`
