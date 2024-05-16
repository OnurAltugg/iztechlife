import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addHitchhikingDetails(Map<String, dynamic> hitchhikingInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("hitchhiking")
        .doc(id)
        .set(hitchhikingInfoMap);
  }

  Future addUser(Map<String, dynamic> userInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  Future addFindHouseDetails(Map<String, dynamic> findHouseInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("findHouse")
        .doc(id)
        .set(findHouseInfoMap);
  }

  Future addLostPropertyDetails(Map<String, dynamic> lostPropertyMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("lostProperty")
        .doc(id)
        .set(lostPropertyMap);
  }

  Future addSocialisationDetails(Map<String, dynamic> socialisationMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("socialisation")
        .doc(id)
        .set(socialisationMap);
  }
}