import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    return Get.find<SplashController>().configModel.socialLogin.isNotEmpty && (Get.find<SplashController>().configModel.socialLogin[0].status
    || Get.find<SplashController>().configModel.socialLogin[1].status) ? Column(children: [

      Center(child: Text('social_login'.tr, style: robotoMedium)),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

      Row(mainAxisAlignment: MainAxisAlignment.center, children: [

        Get.find<SplashController>().configModel.socialLogin[0].status ? InkWell(
          onTap: () async {
            GoogleSignInAccount _googleAccount = await _googleSignIn.signIn();
            GoogleSignInAuthentication _auth = await _googleAccount.authentication;
            if(_googleAccount != null) {
              Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
                email: _googleAccount.email, token: _auth.idToken, uniqueId: _googleAccount.id, medium: 'google',
              ));
            }
          },
          child: Container(
            height: 40,width: 40,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
            ),
            child: Image.asset(Images.google),
          ),
        ) : SizedBox(),
        SizedBox(width: Get.find<SplashController>().configModel.socialLogin[0].status ? Dimensions.PADDING_SIZE_LARGE : 0),

        Get.find<SplashController>().configModel.socialLogin[1].status ? InkWell(
          onTap: () async{
            LoginResult _result = await FacebookAuth.instance.login(permissions: ["public_profile", "email"]);
            if (_result.status == LoginStatus.success) {
              Map _userData = await FacebookAuth.instance.getUserData();
               if(_userData != null){
                Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
                  email: _userData['email'], token: _result.accessToken.token, uniqueId: _result.accessToken.userId, medium: 'facebook',
                ));
              }
            }

          },
          child: Container(
            height: 40, width: 40,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
            ),
            child: Image.asset(Images.facebook),
          ),
        ) : SizedBox(),
        SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

        Get.find<SplashController>().configModel.appleLogin.isNotEmpty && Get.find<SplashController>().configModel.appleLogin[0].status
        && !GetPlatform.isAndroid && !GetPlatform.isWeb ? InkWell(
          onTap: () async {
            final credential = await SignInWithApple.getAppleIDCredential(scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
              // webAuthenticationOptions: WebAuthenticationOptions(
              //   clientId: Get.find<SplashController>().configModel.appleLogin[0].clientId,
              //   redirectUri: Uri.parse('https://6ammart-web.6amtech.com/apple'),
              // ),
            );
            Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
              email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: 'apple',
            ));
          },
          child: Container(
            height: 40, width: 40,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
            ),
            child: Image.asset(Images.apple_logo),
          ),
        ) : SizedBox(),

      ]),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

    ]) : SizedBox();
  }
}
