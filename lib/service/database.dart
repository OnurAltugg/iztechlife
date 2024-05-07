import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addHitchhikingDetails(Map<String, dynamic> hitchhikingInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("Hitchhiking")
        .doc(id)
        .set(hitchhikingInfoMap);
  }

  Future addFindHouseDetails(Map<String, dynamic> findHouseInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("FindHouse")
        .doc(id)
        .set(findHouseInfoMap);
  }

  Future addLostPropertyDetails(Map<String, dynamic> lostPropertyMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("LostProperty")
        .doc(id)
        .set(lostPropertyMap);
  }

  Future addSocialisationDetails(Map<String, dynamic> socialisationMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("Socialisation")
        .doc(id)
        .set(socialisationMap);
  }
}