import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Event.dart';
import '../tema.dart';

Widget locationShow(Event show, BuildContext context) {
  return Row(
    children: [
      show.locationLngLat != null
          ? IconButton(
              onPressed: () async {
                double latitude = show.locationLngLat!.latitude;
                double longitude = show.locationLngLat!.longitude;
                final googleUrl = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                await launchUrl(googleUrl);
              },
              iconSize: 20,
              icon: Container(
                decoration: BoxDecoration(
                  color: Tema.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 0,
                      color: Color(0xFFDBE2E7),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsetsDirectional.all(5),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Tema.of(context).white,
                ),
              ))
          : Container(),
      Text(
        show.location,
        style: Tema.of(context)
            .subtitle1
            .override(fontFamily: 'Nunito', color: Tema.of(context).primaryColor),
      ),
    ],
  );
}

Widget dateShow(Event show, BuildContext context) {
  return Row(
    children: [
      show.time != null
          ? IconButton(
              onPressed: () async {},
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Tema.of(context).primaryColor,
              ),
            )
          : Container(),
      Text(
        DateFormat('dd/MM/yyyy').format(show.time),
        style: Tema.of(context)
            .subtitle2
            .override(fontFamily: 'Nunito', color: Tema.of(context).primaryColor),
      ),
    ],
  );
}

Widget generalInfoShow(Event show, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  show.name,
                  style: Tema.of(context)
                      .title3
                      .override(fontFamily: 'Nunito', color: Tema.of(context).primaryColor),
                ))),
      ),
      Container(
          decoration: BoxDecoration(
            color: Tema.of(context).alternate,
            boxShadow: const [
              BoxShadow(
                blurRadius: 0,
                color: Color(0xFFDBE2E7),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
            child: Text(
              show.type.name,
              style: Tema.of(context).subtitle3,
            ),
          )),
    ],
  );
}
