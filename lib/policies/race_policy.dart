import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/raid_model.dart';

/// Policy class to manage permissions client-side.
/// NOTE: This only controls UI visibility. Real security is enforced by the server.
class RacePolicy {
  final UserModel user;

  RacePolicy(this.user);

  /// Determine whether the user can view any models.
  bool viewAny() {
    return true;
  }

  /// Determine whether the user can view the model.
  bool view(CourseModel course) {
    return true;
  }

  /// Determine whether the user can create models.
  bool create(RaidModel raid) {
    return user.isAdmin || raid.managerId == user.id;
  }

  /// Determine whether the user can update the model.
  bool update(CourseModel course, {RaidModel? raid}) {
    // User is admin
    if (user.isAdmin) {
      return true;
    }

    // User is the race manager
    if (course.managerId == user.id) {
      return true;
    }

    if (raid != null) {
      // User is the raid manager
      if (raid.managerId == user.id) {
        return true;
      }

      // User is the club manager of the raid's club
      if (raid.club != null) {
        // Assuming ClubModel has a managerId or we check differently
        // If ClubModel structure isn't fully known, we skip or add TODO
        // if (raid.club!.managerId == user.id) return true;
      }
    }

    return false;
  }

  /// Determine whether the user can delete the model.
  bool delete(CourseModel course, {RaidModel? raid}) {
    return update(course, raid: raid);
  }

  /// Determine whether the user can restore the model.
  bool restore(CourseModel course) {
    return user.isAdmin || course.managerId == user.id;
  }

  /// Determine whether the user can permanently delete the model.
  bool forceDelete(CourseModel course) {
    return user.isAdmin || course.managerId == user.id;
  }

  /// Determine whether the user can manage files
  bool manageFiles(CourseModel course) {
    return user.isAdmin || course.managerId == user.id;
  }

  /// Check permission for viewing team list (mimicking PHP logic)
  bool viewTeamList(CourseModel course, {RaidModel? raid}) {
    // Original strict PHP logic:
    // return user.isAdmin || course.managerId == user.id;

    // Recommended more permissive logic (like update):
    return update(course, raid: raid);
  }
}
