import 'package:logger/logger.dart';

const kBaseURL = 'https://slash-backend.onrender.com/';
const kHomeScreen = 'home_screen';
const kProductDetailsScreen = 'product_details_screen';
const kBrandLogo = 'assets/images/logo.png';
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
