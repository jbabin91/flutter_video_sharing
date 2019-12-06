import 'package:cloud_firestore/cloud_firestore.dart';

import '../video_info.dart';

class FirebaseProvider {
  static saveVideo(VideoInfo video) async {
    await Firestore.instance.collection('videos').document().setData({
      "videoUrl": video.videoUrl,
      "thumbUrl": video.thumbnailUrl,
      "coverUrl": video.coverUrl,
      "aspectRatio": video.aspectRatio,
    });
  }

  static listenToVideos(callback) async {
    Firestore.instance.collection('videos').snapshots().listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToVideoInfo(QuerySnapshot qs) {
    return qs.documents.map((DocumentSnapshot ds) {
      return VideoInfo(
        videoUrl: ds.data["videoUrl"],
        thumbnailUrl: ds.data["thumbUrl"],
        coverUrl: ds.data["coverUrl"],
        aspectRatio: ds.data["aspectRatio"],
      );
    }).toList();
  }
}
