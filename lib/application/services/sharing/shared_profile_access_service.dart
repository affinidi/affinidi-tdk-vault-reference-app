import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../../../infrastructure/db/app_database.dart';

part 'shared_profile_access_service.g.dart';

@riverpod
SharedProfileAccessService sharedProfileAccessService(Ref ref) {
  return SharedProfileAccessService();
}

class SharedProfileAccessService {
  final AppDatabase _db = AppDatabase();

  Future<void> addSharedAccess({
    required String receiverDid,
    required String profileId,
    required String accessLevel,
  }) async {
    await _db.addAccess(
      SharedProfileAccessCompanion(
        receiverDid: Value(receiverDid),
        profileId: Value(profileId),
        accessLevel: Value(accessLevel),
      ),
    );
  }

  Future<List<SharedProfileAccessData>> getSharedAccessesForProfile(
      String profileId) async {
    final all = await _db.getAllAccesses();
    return all.where((entry) => entry.profileId == profileId).toList();
  }

  Stream<List<SharedProfileAccessData>> watchSharedAccessesForProfile(
      String profileId) {
    return _db.watchAllAccesses().map(
          (all) => all.where((entry) => entry.profileId == profileId).toList(),
        );
  }

  Future<void> removeSharedAccess(int id) async {
    await _db.deleteAccess(id);
  }
}
