import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/not_found_page.dart';
import 'package:bono_gifts/views/profile/profile.dart';
import 'package:bono_gifts/views/signup/create_profile.dart';
import 'package:bono_gifts/views/signup/delivery_address.dart';
import 'package:bono_gifts/views/signup/phone_auth.dart';
import 'package:bono_gifts/views/signup/select_dob.dart';
import 'package:bono_gifts/views/signup/veify_otp.dart';
import 'package:bono_gifts/views/signup/welcome_page.dart';
import 'package:flutter/material.dart';

class CustomRoutes {
  static Route<dynamic> allRoutes(RouteSettings setting) {
    switch (setting.name) {
      case welcomePage:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case phoneAuth:
        return MaterialPageRoute(builder: (_) => const PhoneAuthentication());
      case verifyOTP:
        return MaterialPageRoute(builder: (_) => const VerifyOTP());
      case dobPage:
        return MaterialPageRoute(builder: (_) => SelectDOB());
      case createProfile:
        return MaterialPageRoute(builder: (_) => const CreateProfile());
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
    }
    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}