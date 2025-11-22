abstract class UserCollectionNames {
  static const String collectionName = 'users';
  static const String nameFieldName = 'name';
}

abstract class HomesCollectionNames {
  static const String nameFieldName = 'name';
  static const String membersFieldName = 'members';
  static const String collectionName = 'homes';
}

abstract class PermissionsCollectionNames {
  static const String collectionName = 'permissions';
  static const String isOwnerFieldName = 'isOwner';
}

abstract class ChatCollectionNames {
  static const String collectionName = 'chat';
  static const String senderIdFieldName = 'senderId';
  static const String textFieldName = 'text';
  static const String timestampFieldName = 'timestamp';
}

abstract class InvitationsCollectionNames {
  static const String collectionName = 'invitations';
  static const String homeIdFieldName = 'homeId';
  static const String createdByFieldName = 'createbBy';
  static const String expiresAtFieldName = 'expiresAt';
  static const String usedByFieldName = 'usedBy';
}
