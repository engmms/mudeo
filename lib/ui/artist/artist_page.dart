import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/app/LinkText.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage({this.artist, this.showSettings = false});

  final ArtistEntity artist;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    Widget _profileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(140.0),
        child: CachedNetworkImage(
          imageUrl:
              "https://pbs.twimg.com/profile_images/1021821127545573376/TxRT22Ak_400x400.jpg",
          width: 140.0,
          height: 140.0,
        ),
      );
    }

    final localization = AppLocalization.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 18);

    return CupertinoPageScaffold(
        child: Material(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                showSettings
                    ? IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showDialog<SimpleDialog>(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                final ThemeData themeData = Theme.of(context);
                                final TextStyle aboutTextStyle = themeData.textTheme.body2;
                                final TextStyle linkStyle =
                                themeData.textTheme.body2.copyWith(color: themeData.accentColor);

                                return SimpleDialog(
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: Icons.person,
                                          text: localization.editProfile,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        final store =
                                            StoreProvider.of<AppState>(context);
                                        store.dispatch(EditArtist(
                                            context: context, artist: artist));
                                      },
                                    ),
                                    Divider(),
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: FontAwesomeIcons.twitter,
                                          text: kLinkTypeTwitter,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        launch(kTwitterURL,
                                            forceSafariVC: false);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: FontAwesomeIcons.redditAlien,
                                          text: kLinkTypeReddit,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        launch(kRedditURL,
                                            forceSafariVC: false);
                                      },
                                    ),
                                    Divider(),
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: Icons.info_outline,
                                          text: localization.about,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        showAboutDialog(
                                          context: context,
                                          applicationName: 'mudeo',
                                          /*
                                          applicationIcon: Image.asset(
                                            'assets/images/logo.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          */
                                          applicationVersion:
                                              '${localization.version} $kAppVersion',
                                          applicationLegalese:
                                              '© 2019 mudeo',
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 24.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      style: aboutTextStyle,
                                                      text: localization
                                                              .thankYouForUsingOurApp +
                                                          '\n\n' +
                                                          localization
                                                              .ifYouLikeIt,
                                                    ),
                                                    LinkTextSpan(
                                                      style: linkStyle,
                                                      url: getAppStoreURL(context),
                                                      text: ' ' +
                                                          localization
                                                              .clickHere +
                                                          ' ',
                                                    ),
                                                    TextSpan(
                                                      style: aboutTextStyle,
                                                      text:
                                                          localization.toRateIt,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: Icons.lock,
                                          text: localization.logout,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        final store =
                                            StoreProvider.of<AppState>(context);
                                        store.dispatch(UserLogout());
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                LoginScreenBuilder.route);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: IconText(
                                          icon: Icons.warning,
                                          text: localization.deleteAccount,
                                          textStyle: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      )
                    : SizedBox()
              ],
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(artist.fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            FormCard(
              children: <Widget>[
                _profileImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    // TODO remove this
                    artist.handle == null || artist.handle.isEmpty
                        ? 'handle'
                        : artist.handle,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                showSettings
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 18),
                        child: Container(
                          height: 2,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: RaisedButton(
                            child: Text(localization.follow,
                                style: TextStyle(fontSize: 18)),
                            //onPressed: () {},
                            color: Colors.lightBlue,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ),
                artist.description != null && artist.description.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          // TODO remove this null check
                          artist.description ?? '',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    : SizedBox(),
                artist.website != null && artist.website.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 6),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              LinkTextSpan(
                                style: linkStyle,
                                text: artist.website,
                                url: artist.website,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: artist.socialLinks.keys
                          .map((type) => SocialIconButton(
                              type: type, url: artist.socialLinks[type]))
                          .toList()),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class SocialIconButton extends StatelessWidget {
  SocialIconButton({this.type, this.url});

  final String type;
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        launch(url, forceSafariVC: false);
      },
      tooltip: type,
      icon: Icon(socialIcons[type], size: 30),
    );
  }
}
