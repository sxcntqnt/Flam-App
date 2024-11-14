// Constants for currency in East Africa (Kenya and its neighbors)
const String currencyKenya = 'KSh'; // Kenya Shilling
const String currencyUganda = 'UGX'; // Ugandan Shilling
const String currencyTanzania = 'TZS'; // Tanzanian Shilling
const String currencyRwanda = 'RWF'; // Rwandan Franc
const String currencyBurundi = 'BIF'; // Burundian Franc
const String currencySouthSudan = 'SSP'; // South Sudanese Pound
const String currencyEthiopia = 'ETB'; // Ethiopian Birr
const String currencySomalia = 'SOS'; // Somali Shilling

const String bus33seater = 'bus33seater';  // 33-seater bus
const String bus46seater = 'bus46seater';  // 46-seater bus
const String bus60seater = 'bus60seater';  // 60-seater bus
const String nissan6seater = 'nissan6seater'; // Nissan 6-seater
const String nissan14seater = 'nissan14seater'; // Nissan 14-seater
const String nissan20seater = 'nissan20seater'; // Nissan 20-seater

const String reservationConfirmed = 'Confirmed';
const String reservationCancelled = 'Cancelled';
const String reservationActive = 'Active';
const String reservationExpired = 'Expired';
const String emptyFieldErrMessage = 'This field must not be empty';
const String accessToken = 'accessToken';
const String loginTime = 'loginTime';
const String expirationDuration = 'expirationDuration';
const String routeNameHome = 'search';
const String routeNameSearchResultPage = 'search_result';
const String routeNameLoginPage = 'login';
const String routeNameSeatPlanPage = 'seat_plan';
const String routeNameBookingConfirmationPage = 'booking_confirmation';
const String routeNameAddBusPage = 'add_bus';
const String routeNameAddRoutePage = 'add_route';
const String routeNameAddSchedulePage = 'add_schedule';
const String routeNameScheduleListPage = 'schedule_list';
const String routeNameReservationPage = 'reservation';

const String emailFormatError = 'Invalid email format';
const String passwordStrengthError = 'Password must be at least 8 characters long';
const String phoneNumberError = 'Invalid phone number format';
const String reservationNotFoundError = 'Reservation not found';
const String genericErrorMessage = 'Something went wrong, please try again later';

const String roleAdmin = 'Admin';
const String roleCustomer = 'Customer';
const String roleDriver = 'Driver';

// Permission levels
const String permissionView = 'view';
const String permissionEdit = 'edit';
const String permissionDelete = 'delete';

const String apiSuccessMessage = 'Request successful';
const String apiFailureMessage = 'Request failed';
const String apiUnauthorizedMessage = 'Unauthorized request';
const String apiExpiredMessage = 'Session expired, please log in again';

const Color primaryColor = Color(0xFF2196F3); // Blue for primary buttons or app theme
const Color secondaryColor = Color(0xFF4CAF50); // Green for success or confirmations
const Color errorColor = Color(0xFFFF5722); // Red for error states
const Color backgroundColor = Color(0xFFF5F5F5); // Light grey for backgrounds

const double defaultPadding = 16.0;  // Default padding for UI components
const double defaultFontSize = 14.0; // Default font size for texts
const double titleFontSize = 18.0;  // Font size for titles or headers

const String dateFormat = 'dd MMM yyyy';  // Format for displaying dates
const String timeFormat = 'hh:mm a';      // Format for displaying times (AM/PM)

const String bookingDateFormat = 'yyyy-MM-dd';  // Format for saving or sending dates (ISO format)

const String toastSuccess = 'Operation successful';
const String toastError = 'Something went wrong';
const String toastLoading = 'Please wait...';

const String alertTitle = 'Alert';
const String alertConfirmButton = 'Confirm';
const String alertCancelButton = 'Cancel';


const cities = [
  'Nairobi',
  'Kiambu',
  'Kajiado',
  'Machakos',

];

enum ResponseStatus {
  SAVED, FAILED, UNAUTHORIZED, AUTHORIZED, EXPIRED, NONE,
}

const busTypes = [
  bus33seater, 
  bus46seater, 
  bus60seater, 
  nissan6seater, 
  nissan14seater, 
  nissan20seater, 
  busTypeACBusiness, 
  busTypeACEconomy, 
  busTypeNonAc
];

const seatLabelList = ['A','B','C','D','E','F','G','H','I','J','K','L'];

