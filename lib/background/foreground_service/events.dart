/// This file contains helper classes to carry different events from/to services

// Note: if we, some day, for some reason, want to start other services
// from other services (one gets the job done, but wants the other to finish it)
// (idk why we would want this), it seems like the current plugin supports
// something like this - we would need to change this class a bit...
// Tho I think, running multiple services *inside* other big daddy service
// - they are plugin independent! we can just pipe their streams into
// each other! - would be a better idea...
/// Just a little class to hold info for notification
class FServiceNotificationData {
  final String title;
  final String text;

  FServiceNotificationData(this.title, this.text);
}
