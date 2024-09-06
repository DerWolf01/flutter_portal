import 'dart:io';

import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/list_of.dart';

@convertable
class Job {
  Job({
    required this.id,
    required this.title,
    required this.titleKeywords,
    required this.descriptionKeywords,
    required this.excludeSellers,
    required this.location,
    required this.smsNotifications,
    required this.emailNotifications,
    required this.scheduleMask,
    required this.createdBy,
    required this.active,
  });

  final int id;
  final int createdBy;
  final String title;

  final List<String> titleKeywords;

  final List<String> descriptionKeywords;

  final List<String> excludeSellers;
  final EbayGlobalId location;
  final bool smsNotifications;
  final bool emailNotifications;
  final ScheduleMask scheduleMask;
  final bool active;

  // String get scheduleCronString => Shedule()
}

@convertable
class JobsListsWithUserProfile {
  JobsListsWithUserProfile(
      {@ListOf(type: Jobs) required this.jobsWithUserPorfiles});
  @ListOf(type: Jobs)
  final List<dynamic> jobsWithUserPorfiles;
}

@convertable
class Jobs {
  Jobs({@ListOf(type: Job) required this.jobs, required this.userProfile});
  @ListOf(type: Job)
  final List<dynamic> jobs;
  final UserProfile userProfile;
}

@convertable
class ScheduleMask {
  late final int id;

  /// The minutes a Task should be started.
  final int? minutes;

  /// The hours a Task should be started.
  final int? hours;

  /// The weekdays a Task should be started.
  final List<int>? weekdays;
  ScheduleMask({this.minutes, this.hours, this.weekdays, this.id = -1});
}

@convertable
class UserProfile {
  UserProfile(
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.username,
    this.role,
    this.profilePicture,
  );
  UserProfile.named({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.lastname,
    required this.role,
    this.profilePicture,
  });
  final int id;
  final String email;
  final String name;
  final String lastname;
  final String username;
  final File? profilePicture;
  final Role role;

  String get fullName => "$name $lastname";
}

enum Roles { boss, admin, user }

extension RolesExtension on Roles {
  Role get role {
    switch (this) {
      case Roles.admin:
        return const Role.namedParams(id: 0, name: "admin");
      case Roles.user:
        return const Role.namedParams(id: 1, name: "user");

      case Roles.boss:
        return const Role.namedParams(id: 2, name: "boss");
    }
  }
}

@convertable
class Role {
  const Role.namedParams({required this.id, required this.name});

  const Role(this.id, this.name);

  final int id;

  final String name;
}

enum EbayGlobalIds {
  ebayUs,
  ebayCanada,
  ebayUK,
  ebayAustralia,
  ebayAustria,
  ebayBelgiumFrench,
  ebayFrance,
  ebayGermany,
  ebayMotors,
  ebayItaly,
  ebayBelgiumDutch,
  ebayNetherlands,
  ebaySpain,
  ebaySwitzerland,
  ebayHongKong,
  ebayIndia,
  ebayIreland,
  ebayMalaysia,
  ebayCanadaFrench,
  ebayPhilippines,
  ebayPoland,
  ebaySingapore,
}

extension EbayGlobalIdExtension on EbayGlobalIds {
  EbayGlobalId get value {
    switch (this) {
      case EbayGlobalIds.ebayUs:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-US",
          siteId: "0",
          siteName: "ebay United States",
        );
      case EbayGlobalIds.ebayCanada:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-ENCA",
          siteId: "2",
          siteName: "ebay Canada (English)",
        );
      case EbayGlobalIds.ebayUK:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-GB",
          siteId: "3",
          siteName: "ebay UK",
        );
      case EbayGlobalIds.ebayAustralia:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-AU",
          siteId: "15",
          siteName: "ebay Australia",
        );
      case EbayGlobalIds.ebayAustria:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-AT",
          siteId: "16",
          siteName: "ebay Austria",
        );
      case EbayGlobalIds.ebayBelgiumFrench:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-FRBE",
          siteId: "23",
          siteName: "ebay Belgium (French)",
        );
      case EbayGlobalIds.ebayFrance:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-FR",
          siteId: "71",
          siteName: "ebay France",
        );
      case EbayGlobalIds.ebayGermany:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-DE",
          siteId: "77",
          siteName: "ebay Germany",
        );
      case EbayGlobalIds.ebayMotors:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-MOTOR",
          siteId: "100",
          siteName: "ebay Motors",
        );
      case EbayGlobalIds.ebayItaly:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-IT",
          siteId: "101",
          siteName: "ebay Italy",
        );
      case EbayGlobalIds.ebayBelgiumDutch:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-NLBE",
          siteId: "123",
          siteName: "ebay Belgium (Dutch)",
        );
      case EbayGlobalIds.ebayNetherlands:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-NL",
          siteId: "146",
          siteName: "ebay Netherlands",
        );
      case EbayGlobalIds.ebaySpain:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-ES",
          siteId: "186",
          siteName: "ebay Spain",
        );
      case EbayGlobalIds.ebaySwitzerland:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-CH",
          siteId: "193",
          siteName: "ebay Switzerland",
        );
      case EbayGlobalIds.ebayHongKong:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-HK",
          siteId: "201",
          siteName: "ebay Hong Kong",
        );
      case EbayGlobalIds.ebayIndia:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-IN",
          siteId: "203",
          siteName: "ebay India",
        );
      case EbayGlobalIds.ebayIreland:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-IE",
          siteId: "205",
          siteName: "ebay Ireland",
        );
      case EbayGlobalIds.ebayMalaysia:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-MY",
          siteId: "207",
          siteName: "ebay Malaysia",
        );
      case EbayGlobalIds.ebayCanadaFrench:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-FRCA",
          siteId: "210",
          siteName: "ebay Canada (French)",
        );
      case EbayGlobalIds.ebayPhilippines:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-PH",
          siteId: "211",
          siteName: "ebay Philippines",
        );
      case EbayGlobalIds.ebayPoland:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-PL",
          siteId: "212",
          siteName: "ebay Poland",
        );
      case EbayGlobalIds.ebaySingapore:
        return EbayGlobalId.init(
          id: index,
          globalId: "EBAY-SG",
          siteId: "216",
          siteName: "ebay Singapore",
        );

      default:
        return EbayGlobalIds.ebayUs.value;
    }
  }
}

class EbayGlobalId {
  EbayGlobalId();
  EbayGlobalId.init({
    required this.id,
    required this.siteId,
    required this.globalId,
    required this.siteName,
  });

  late final int id;

  late final String siteId;

  late final String globalId;

  late final String siteName;

  String get query => "GLOBAL-ID=$globalId";
}
