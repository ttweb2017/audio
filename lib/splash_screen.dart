
import 'package:flutter/cupertino.dart';
import 'package:vplayer/Karaoke.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, @required this.isIndicating, @required this.bottomText}) : super(key: key);
  final String bottomText;
  final bool isIndicating;

  @override
  _SplashScreenState createState() => _SplashScreenState(isIndicating, bottomText);
}

class _SplashScreenState extends State<SplashScreen> {
  String bottomText;
  bool isIndicating;
  _SplashScreenState(this.isIndicating, this.bottomText);

  @override
  void initState() {
    super.initState();
    //Timer(Duration(seconds: 5), () => MyNavigator.goToIntro(context));
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
      ),
      backgroundColor: Color(0xFFFFFFFF),//0x805C6BC0
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFFFFFFF)),//0x805C6BC0
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          Karaoke.APP_LOGO_ASSET_NAME,
                          package: Karaoke.APP_LOGO_ASSET_PACKAGE,
                          fit: BoxFit.cover,
                          width: 300.0,
                          height: 300.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        Karaoke.APP_TITLE,
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isIndicating
                        ? CupertinoActivityIndicator(radius: 15.0)
                        : null,
                    Padding(
                      padding: EdgeInsets.only(top: isIndicating ? 20.0 : 35.0),
                    ),
                    Text(
                      bottomText,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Color(0xFF000000)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }


}