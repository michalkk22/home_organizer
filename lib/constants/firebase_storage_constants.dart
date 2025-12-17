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
  static const String createdByFieldName = 'createdBy';
  static const String expiresAtFieldName = 'expiresAt';
  static const String usedByFieldName = 'usedBy';
  static const String statusFieldName = 'status';
  static const String acceptedStatus = 'accepted';
  static const String pendingStatus = 'pending';
  static const String failedStatus = 'failed';
}

abstract class ExpensesCollectionNames {
  static const collectionName = 'expenses';
  static const userIdFieldName = 'userId';
  static const titleFieldName = 'title';
  static const amountFieldName = 'amount';
  static const dateFieldName = 'date';
  static const categoryIdFieldName = 'category';
}

abstract class ExpenditureCategoriesCollectionNames {
  static const collectionName = 'expenditureCategories';
  static const defaultsCollectionName = 'defaultExpenditureCategories';
  static const nameFieldName = 'name';
}

abstract class ShoppingListCollectionNames {
  static const collectionName = 'shoppingList';
  static const nameFieldName = 'name';
  static const quantityFieldName = 'quantity';
  static const unitFieldName = 'unit';
  static const inCartFieldName = 'inCart';
}
