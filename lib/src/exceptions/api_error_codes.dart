/// Documented Kavenegar REST API return codes from the official docs.
///
/// Some codes (for example [invalidSender]) mean different things depending on
/// the endpoint. Use the API message for endpoint-specific context.
abstract final class KavenegarApiErrorCodes {
  /// Returns the documented meaning of [status], or `null` if unknown.
  static String? description(int status) => _descriptions[status];

  /// All documented API return codes and their default descriptions.
  static const Map<int, String> descriptions = _descriptions;

  static const int success = 200;
  static const int incompleteParameters = 400;
  static const int accountInactive = 401;
  static const int operationFailed = 402;
  static const int invalidApiKey = 403;
  static const int methodNotFound = 404;
  static const int invalidHttpMethod = 405;
  static const int mandatoryParametersEmpty = 406;
  static const int accessDenied = 407;
  static const int serverUnavailable = 409;
  static const int invalidReceptor = 411;
  static const int invalidSender = 412;
  static const int invalidMessageLength = 413;
  static const int requestSizeExceeded = 414;
  static const int startIndexTooLarge = 415;
  static const int ipMismatch = 416;
  static const int invalidDate = 417;
  static const int insufficientCredit = 418;
  static const int arraySizeMismatch = 419;
  static const int linkRestricted = 420;
  static const int invalidCharacters = 422;
  static const int templateNotFound = 424;
  static const int advancedServiceRequired = 426;
  static const int lineAccessRequired = 427;
  static const int voiceCallNotAllowed = 428;
  static const int ipRestricted = 429;
  static const int invalidTokenStructure = 431;
  static const int tokenNotInTemplate = 432;
  static const int rateLimited = 451;
  static const int testMessageOnlyToOwner = 501;
  static const int tooManyNumbers = 604;
  static const int invalidTag = 607;
  static const int mediaRequired = 800;
  static const int invalidMedia = 801;
  static const int mediaSizeNotAllowed = 802;
  static const int mediaAspectRatioNotAllowed = 803;
  static const int mediaDurationNotAllowed = 804;
  static const int mediaUploadAccessDenied = 805;
  static const int mediaUploadLimitExceeded = 806;
  static const int duplicateMedia = 807;
  static const int invalidMediaId = 808;
  static const int mediaNotFound = 809;
  static const int mediaPendingReview = 810;
  static const int mediaRejected = 811;
  static const int mediaPolicyNotAllowed = 812;
  static const int mediaInternalLinesOnly = 813;
}

const Map<int, String> _descriptions = {
  200: 'Request approved.',
  400: 'Parameters are incomplete.',
  401: 'Account is inactive.',
  402: 'Operation was unsuccessful.',
  403: 'API key is not valid.',
  404: 'Method was not found.',
  405: 'HTTP method (GET/POST) is not allowed for this call.',
  406: 'Required parameters were sent empty.',
  407: 'Access to the requested information is not allowed.',
  409: 'Server cannot respond; try again later.',
  411: 'Receptor number is not valid.',
  412: 'Sender is not valid (meaning varies by endpoint).',
  413: 'Message is empty or exceeds the maximum length.',
  414: 'Request size exceeds the allowed limit.',
  415: 'Start index is greater than the total number of records.',
  416: 'Source IP does not match security settings.',
  417: 'Send date is invalid or incorrectly formatted.',
  418: 'Account credit is insufficient.',
  419: 'Sender, receptor, and message array lengths do not match.',
  420: 'Using links in the message text is restricted for this account.',
  422: 'Data contains invalid characters and cannot be processed.',
  424: 'Verification template was not found.',
  426: 'This method requires the advanced service.',
  427: 'Using this line requires additional access level.',
  428: 'Sending a code via voice call is not possible.',
  429: 'IP is restricted.',
  431: 'Token structure is not valid.',
  432: 'Token placeholder was not found in the template text.',
  451: 'Too many requests from this IP in the given time window.',
  501: 'Only test messages to the account owner number are allowed.',
  604: 'Too many phone numbers were sent (maximum 200).',
  607: 'Tag name is not valid.',
  800: 'Media file is required.',
  801: 'Media file is invalid or cannot be processed.',
  802: 'Media file size is not allowed.',
  803: 'Media aspect ratio is not allowed.',
  804: 'Media duration is not allowed.',
  805: 'No permission to upload media.',
  806: 'Media upload quota exceeded.',
  807: 'Media was already uploaded.',
  808: 'Media id is invalid.',
  809: 'Media was not found.',
  810: 'Media is pending review.',
  811: 'Media was rejected.',
  812: 'Selected policy does not allow this media.',
  813: 'Media can only be sent on internal messenger lines.',
};
