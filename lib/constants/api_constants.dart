

class ApiConstants{
  static var BASE_URL = "https://thee4square.com/api/index.php/api/";
  static var HOTEL_BASE_URL = "https://hotel.thee4square.in/mobileapi/";
  static var WEB_BASE_URL = "https://thee4square.com/";
  static var IMG_BASE_URL = "https://thee4square.com/api/index.php/api_vendor/";
  static var currency = "₹";

  static var amenities = ["","Free Wi-Fi","Swimming Pool","Fitness Center","Restaurant",
  "Spa","Room Service","Parking","Air Conditioning","24-Hour Front Desk","Pet-Friendly","Business Center","Safety Deposit Box"];

  static var login = BASE_URL+"login";
  static var validation = BASE_URL+"Validation/";
  static var homeData = BASE_URL+"homeData/";
  static var myOrder = BASE_URL+"order/list/";
  static var orderDetails = BASE_URL+"order/orderDetails/";
  static var listVendor = BASE_URL+"listShopbyid/";
  static var listBannerVendor = BASE_URL+"listBannerVendor/";
  static var categories = BASE_URL+"categories/";
  static var category_wise_restaurantproduct = BASE_URL+"category_wise_restaurantproduct/";
  static var category_wise_product = BASE_URL+"category_wise_product/";
  static var createOrder = BASE_URL+"order/test/null/test";
  static var addAddress = BASE_URL+"addAddress";
  static var updateAddress = BASE_URL+"updateAddress/";
  static var listAddress = BASE_URL+"listAddress/";
  static var deleteAddress = BASE_URL+"deleteAddress/";
  static var getZone = BASE_URL+"getZone";
  static var GetGroceryCategory = BASE_URL+"GetCategory/";
  static var listServicecategory = BASE_URL+"listServicecategory/";
  static var addService = BASE_URL+"AddService";
  static var listOtherService = BASE_URL+"listOtherService/";
  static var listOtherServiceById = BASE_URL+"listOtherServiceById/";
  static var balance = BASE_URL+"wallet/balance/";
  static var getPaymentGateway = BASE_URL+"getPaymentGateway/";
  static var balanceList = BASE_URL+"wallet/list/";
  static var getProfile = BASE_URL+"getProfile/";
  static var getProfileLogout = BASE_URL+"getProfileLogout/";
  static var getDeliveryFees = BASE_URL+"getDeliveryFees/";
  static var getVendorDetails = BASE_URL+"getVendorDetails/";
  static var updateFcmtoken = BASE_URL+"updateFcmtoken";
  static var profileimage = BASE_URL+"profileimage/";
  static var getDriverDetails = BASE_URL+"getDriverDetails/";
  static var getZoneInformation = BASE_URL+"getZoneInformation/";
  static var listCoupons = BASE_URL+"listCoupons/";
  static var addChat = BASE_URL+"addChat";
  static var listChat = BASE_URL+"listChat/";
  static var getServiceDeliveryFees = BASE_URL+"getServiceDeliveryFees/";
  static var shopRating = BASE_URL+"shopRating/";
  static var getDeliveryTips = BASE_URL+"getDeliveryTips/";
  static var search = BASE_URL+"search/";
  static var servicebanner = BASE_URL+"servicebanner/";
  static var createrazorpayorderid = BASE_URL+"createrazorpayorderid/";
  static var appupdate = BASE_URL+"appupdate/";
  static var removeAccount = BASE_URL+"deleteaccount/";
  static var listvendortype = BASE_URL+"listvendortype";


  //Hotel Api's

  static var hotellist = HOTEL_BASE_URL+"hotellist";
  static var hoteldetails = HOTEL_BASE_URL+"hoteldetailsnew";
  static var searchtimeslot = HOTEL_BASE_URL+"searchtimeslot";
  static var submitbooking = HOTEL_BASE_URL+"submitbooking";
  static var mybooking = HOTEL_BASE_URL+"mybooking";
  static var bookingdetails = HOTEL_BASE_URL+"bookingdetails";
  static var getzoneid = HOTEL_BASE_URL+"getzoneid/";


}