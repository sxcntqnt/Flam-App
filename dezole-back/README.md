# Dezole Backend - Spring Boot Ride-Sharing App

A Spring Boot backend for the Dezole ride-sharing application with rich state management matching the Flutter Riverpod-based frontend.

## Tech Stack
- Spring Boot 3.2.0
- Java 17
- Spring Security with JWT Authentication
- PostgreSQL Database
- Spring Data JPA

## Rich State Management

The backend implements state management patterns that mirror the Flutter Riverpod frontend:

### AuthStatus Enum
```java
public enum AuthStatus {
    INITIAL,      // App just started
    LOADING,       // Auth operation in progress
    AUTHENTICATED, // User is logged in
    UNAUTHENTICATED, // User logged out
    ERROR          // Auth operation failed
}
```

### RideStatus Enum (Richer State Machine)
```java
public enum RideStatus {
    INITIAL,          // Ride created but not searching
    SEARCHING,         // Actively looking for drivers
    OFFERS_RECEIVED,   // Drivers sent offers
    DRIVER_ASSIGNED,   // Offer accepted, driver assigned
    PICKING_UP,        // Driver going to pickup
    IN_PROGRESS,       // Ride started
    RIDING,            // Passenger in vehicle
    COMPLETED,         // Ride finished
    CANCELLED,         // Ride cancelled
    NO_DRIVERS_FOUND   // No available drivers
}
```

### PaymentMethod Enum
```java
public enum PaymentMethod {
    VISA,
    MASTERCARD,
    PAYPAL,
    CASH_APP,
    WALLET,
    M_PESA
}
```

### RideType Enum
```java
public enum RideType {
    TRANSPORT,
    DELIVERY
}
```

## State Response DTOs

### AuthStateResponse
```json
{
  "status": "AUTHENTICATED",
  "token": "jwt-token",
  "userId": "uuid",
  "email": "user@example.com",
  "role": "CUSTOMER",
  "errorMessage": null
}
```

### RideStateResponse
```json
{
  "id": "uuid",
  "rideType": "TRANSPORT",
  "transportType": "CAR",
  "fromAddress": "Nairobi CBD",
  "toAddress": "Westlands",
  "status": "SEARCHING",
  "isSearching": true,
  "offersReceived": false,
  "hasError": false,
  "errorMessage": null,
  "selectedOfferId": null,
  "offersCount": 0,
  "requestedAt": "2026-04-10T10:00:00",
  "driverAssignedAt": null,
  "startedAt": null,
  "completedAt": null
}
```

### WalletStateResponse
```json
{
  "id": 1,
  "availableBalance": 5000.00,
  "totalExpenditure": 1200.00,
  "selectedMethod": "WALLET",
  "isLoading": false,
  "error": null,
  "recentTransactions": [...],
  "savedPaymentMethods": [...]
}
```

## Features
- User Authentication (Register/Login) with state tracking
- Driver Management (Registration, Location Updates, Availability)
- Rich Ride State Machine (INITIAL → SEARCHING → OFFERS_RECEIVED → DRIVER_ASSIGNED → ...)
- Ride Offer System (drivers send offers, passengers accept/decline)
- Bus Reservation System
- Route & Schedule Management
- Wallet & Transactions with payment methods
- Favorites Management
- Real-time Chat
- Push Notifications
- Social Feed/Posts
- Referral System
- Complaint Management
- Offers & Promotions
- Subscriptions
- Geofences
- Weather Information
- Static Pages

## Setup

### Prerequisites
- Java 17+
- Maven 3.6+
- PostgreSQL 12+

### Database Setup
Create a PostgreSQL database:
```sql
CREATE DATABASE dezole;
```

### Configuration
Update `src/main/resources/application.yml` with your database credentials.

### Running the Application
```bash
mvn spring-boot:run
```

The server will start on `http://localhost:8080`

## API Endpoints

### Auth State Management
- `GET /api/auth/state` - Get current auth state
- `POST /api/auth/register` - Register user (returns AuthStateResponse)
- `POST /api/auth/login` - Login (returns AuthStateResponse)
- `POST /api/auth/logout` - Logout

### Rides (Rich State Machine)
- `POST /api/rides` - Create ride request
- `POST /api/rides/{id}/search` - Start searching for drivers
- `POST /api/rides/{id}/stop-search` - Stop searching
- `POST /api/rides/{id}/accept-offer/{offerId}` - Accept driver offer
- `POST /api/rides/{id}/decline-offers` - Decline all offers
- `POST /api/rides/{id}/offers` - Create ride offer (driver)
- `GET /api/rides/{id}` - Get ride state
- `GET /api/rides/{id}/offers` - Get ride offers
- `GET /api/rides/my-rides` - Get passenger rides
- `GET /api/rides/driver/rides` - Get driver rides
- `GET /api/rides/available` - Get available rides for driver
- `PUT /api/rides/{id}/status` - Update ride status
- `POST /api/rides/{id}/cancel` - Cancel ride

### Wallet (State Management)
- `GET /api/wallet` - Get wallet state
- `POST /api/wallet/topup` - Top up wallet
- `POST /api/wallet/add-money` - Add money with payment method
- `POST /api/wallet/select-method` - Select payment method
- `GET /api/wallet/transactions` - Get transactions
- `GET /api/wallet/balance` - Get balance
- `GET /api/wallet/check-balance?amount=X` - Check if sufficient balance

### Other Endpoints
- User management
- Driver management
- Routes, Buses, Schedules
- Reservations
- Favorites
- Chat
- Notifications
- Posts
- Referrals
- Complaints
- Offers
- Subscriptions
- Geofences
- Weather
- Static Pages

## Project Structure
```
dezole-back/
├── pom.xml
├── README.md
└── src/main/
    ├── java/com/rideapp/dezole/
    │   ├── DezoleApplication.java
    │   ├── config/
    │   ├── controller/
    │   ├── dto/
    │   ├── exception/
    │   ├── model/
    │   │   ├── dto/response/ (State responses)
    │   │   ├── entity/
    │   │   └── enums/
    │   ├── repository/
    │   ├── security/
    │   └── service/
    └── resources/
        └── application.yml
```

## Testing

```bash
# Get auth state
curl -X GET http://localhost:8080/api/auth/state

# Register
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","firstName":"Test","lastName":"User","phone":"+254700000000"}'

# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Create ride request
curl -X POST http://localhost:8080/api/rides \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fromAddress":"Nairobi CBD","toAddress":"Westlands","transportType":"CAR"}'

# Start searching for drivers
curl -X POST http://localhost:8080/api/rides/{id}/search \
  -H "Authorization: Bearer $TOKEN"

# Get wallet state
curl -X GET http://localhost:8080/api/wallet \
  -H "Authorization: Bearer $TOKEN"
```

## License
MIT License
