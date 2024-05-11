
class RequestUrls {
  // static String baseUrl = 'https://deep-truth-backend.onrender.com';
  static String baseUrl = 'https://precise-albacore-simply.ngrok-free.app';

  static String login = '$baseUrl/auth/login';
  static String signup = '$baseUrl/auth/signup';
  static String refreshAccessToken = '$baseUrl/auth/refresh_access_token';

  static String checkFile = '$baseUrl/image/check_file';

  static String historyData = '$baseUrl/history/history_data';
  static String getFile = '$baseUrl/history/file';
  static String deleteFile = '$baseUrl/history/file';
  static String clearHistory = '$baseUrl/history/clear_history';

  static String updateName = '$baseUrl/profile/update_name';
  static String updatePicture = '$baseUrl/profile/update_picture';
  static String deletePicture = '$baseUrl/profile/delete_picture';
  static String updatePassword = '$baseUrl/profile/update_password';
  static String deleteAccount = '$baseUrl/profile/delete_account';

  static String profilePicture = '$baseUrl/interact/profile_picture';

  static String searchUsers = '$baseUrl/interact/users';
  static String anotherUserHistory = '$baseUrl/interact/history';

  static String sendRequest = '$baseUrl/connect/send_request';
  static String acceptRequest = '$baseUrl/connect/accept_request';
  static String removeRequest = '$baseUrl/connect/remove_request';
  static String undoRequest = '$baseUrl/connect/undo_request';
  static String outboundRequests = '$baseUrl/connect/outbound_requests';
  static String inboundRequests = '$baseUrl/connect/inbound_requests';
  static String connections = '$baseUrl/connect/connections';
  static String relation = '$baseUrl/connect/relation';
}

/// munir.dev@deep.com
