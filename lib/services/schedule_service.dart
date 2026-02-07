import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/schedule.dart';

class ScheduleService {
  ScheduleService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String> createSchedule(ScheduleCreate data) async {
    final docRef = _firestore.collection('schedules').doc();
    await docRef.set(data.toFirestore(docRef.id));
    return docRef.id;
  }
}
