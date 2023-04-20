import 'package:card_memory_game/styles/color_styles.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      appBar: AppBar(
        title: Text("설정"),
        backgroundColor: ColorStyles.bgPrimaryColor,
        foregroundColor: ColorStyles.borderColor,
      ),
      body: FutureBuilder(
        future: _getPackageInfo(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          if (!snapshot.hasData) return Text("loading...");

          final data = snapshot.data!;
          return ListView(
            children: [
              Card(
                color: ColorStyles.bgSecondaryColor,
                child: ListTile(
                  leading: Text(
                    '앱 이름',
                    style: TextStyles.cardText,
                  ),
                  title: Text(
                    data.appName,
                    style: TextStyles.plainText,
                  ),
                ),
              ),
              Card(
                color: ColorStyles.bgSecondaryColor,
                child: ListTile(
                  leading: Text(
                    '앱 버전',
                    style: TextStyles.cardText,
                  ),
                  title: Text(
                    data.version,
                    style: TextStyles.plainText,
                  ),
                ),
              ),
              Card(
                color: ColorStyles.bgSecondaryColor,
                child: GestureDetector(
                  onTap: () async {
                    const privacyUrl = 'https://dolphin-pc.github.io/memory_game';
                    launchUrlString(privacyUrl);
                  },
                  child: ListTile(
                    leading: Text(
                      '개인정보처리방침',
                      style: TextStyles.cardText,
                    ),
                    title: Text(
                      '[외부링크]',
                      style: TextStyles.plainText,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
