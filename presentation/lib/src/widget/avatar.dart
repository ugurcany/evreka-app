import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:presentation/src/core/resources.dart';

class Avatar extends StatelessWidget {
  final String url;
  final double radius;

  Avatar({
    @required this.url,
    @required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return (url?.isNotEmpty ?? false)
        ? _avatar(context)
        : _placeholder(context);
  }

  Widget _avatar(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Theme.of(context).canvasColor,
      ),
      child: CircleAvatar(
        radius: radius,
        child: Icon(
          AppIcons.AVATAR,
          size: radius,
        ),
      ),
    );
  }
}
