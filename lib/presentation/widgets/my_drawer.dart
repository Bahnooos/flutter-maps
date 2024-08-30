import 'dart:core';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps/business_layer/cubit/phone_auth_cubit.dart';
import 'package:maps/constants/colors.dart';
import 'package:maps/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(color: Colors.blue[100]),
            child: DrawerHeader(
              child: buildDrawerHeader(),
            ),
          ),
          buildListItem(leadingIcon: Icons.person, title: 'MyPorfile'),
          buildDivider(),
          buildListItem(
            leadingIcon: Icons.history,
            title: 'PlacesHistory',
            onTap: () {},
          ),
          buildDivider(),
          buildListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDivider(),
          buildListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDivider(),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: buildListItem(
              leadingIcon: Icons.logout,
              title: 'Log out',
              onTap: () {
                phoneAuthCubit.signOut();
                Navigator.of(context).pushReplacementNamed( loginScreen);
              },
              color: MyColors.redLight,
              trailaing: const SizedBox(),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          ListTile(
            leading: Text(
              'Folow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }

  Widget buildListItem({
    required IconData leadingIcon,
    required String title,
    Function()? onTap,
    Widget? trailaing,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
            leadingIcon,
            color: color?? MyColors.redLight,
          ),
       
      title: Text(
        title,
       
      ),
      trailing: trailaing ??
          const Icon(
            Icons.arrow_right,
            color: Colors.blue,
          ),
      onTap: onTap,
    );
  }

  Widget buildDivider() {
    return const Divider(
      indent: 18,
      endIndent: 24,
      height: 0,
      thickness: 1,
    );
  }

  Future<void> _launchUrl(Uri url) async {
    await canLaunchUrl(url)
        ? launchUrl(url)
        : throw 'Could not launch this $url';
  }

  Widget buildIcon(IconData icon, Uri url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Icon(icon,color: Colors.blue,size: 35,),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(
            FontAwesomeIcons.facebook,
            Uri.parse(
                'https://www.facebook.com/profile.php?id=100013359945056'),
          ),
          const SizedBox(
            width: 20,
          ),
          buildIcon(
            FontAwesomeIcons.instagram,
            Uri.parse('https://www.instagram.com/ahm_bahnas/'),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
      decoration:
          BoxDecoration(shape: BoxShape.rectangle, color: Colors.blue[100]),
      child: Column(
        children: [
          Image.asset(
            'lib/assets/images/Bahnooos.jpg',
            fit: BoxFit.cover,
          ),
          const Text(
            'Bahnasawy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            
          ),
          const SizedBox(
            height: 5,
          ),
          BlocProvider(
            create: (context) => phoneAuthCubit,
            child: Text(
              '${phoneAuthCubit.loggedInUser().phoneNumber}',
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
