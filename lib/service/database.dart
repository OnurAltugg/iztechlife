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

  Future addFindHouseDetails(Map<String, dynamic> accommodationInfoMap, String id)async{
    return await FirebaseFirestore.instance
        .collection("accommodation")
        .doc(id)
        .set(accommodationInfoMap);
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

  Future updateDetails(Map<String, dynamic> updateInfo, String id, String collectionName)async{
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .update(updateInfo);
  }

  Future updateUserName(Map<String, dynamic> updateInfo, String id)async{
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .update(updateInfo);
  }
}