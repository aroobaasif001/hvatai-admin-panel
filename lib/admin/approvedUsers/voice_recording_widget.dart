// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';


// class VoiceRecordingWidget extends StatefulWidget {
//   final String audioUrl;

//   VoiceRecordingWidget({required this.audioUrl});

//   @override
//   _VoiceRecordingWidgetState createState() => _VoiceRecordingWidgetState();
// }

// class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget> {
//   late AudioPlayer _audioPlayer;
//   bool isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();

//     _audioPlayer.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         setState(() {
//           isPlaying = false;
//         });
//         _stopAudio();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _playAudio() async {
//     try {
//       await _audioPlayer.setUrl(widget.audioUrl);
//       _audioPlayer.play();
//       setState(() {
//         isPlaying = true;
//       });
//     } catch (e) {
//       print("Error playing audio: $e");
//     }
//   }

//   Future<void> _pauseAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       isPlaying = false;
//     });
//   }

//   Future<void> _stopAudio() async {
//     await _audioPlayer.stop();
//     await _audioPlayer.seek(Duration.zero);
//     setState(() {
//       isPlaying = false;
//     });
//   }

//   // Future<void> _downloadAudio() async {
//   //   try {
//   //     html.AnchorElement anchorElement =
//   //         html.AnchorElement(href: widget.audioUrl)
//   //           ..setAttribute("download", "voice_recording.mp3")
//   //           ..click();
//   //     Get.snackbar("Download Complete", "The audio has been downloaded.",
//   //         snackPosition: SnackPosition.BOTTOM);
//   //   } catch (e) {
//   //     print("Error downloading audio: $e");
//   //     Get.snackbar(
//   //         "Download Failed", "There was an error downloading the file.",
//   //         snackPosition: SnackPosition.BOTTOM);
//   //   }
//   // }
//   Future<void> _downloadAudio() async {
//     try {
//       html.AnchorElement anchorElement =
//           html.AnchorElement(href: widget.audioUrl)
//             ..setAttribute("download", "voice_recording.mp3")
//             ..target = "_self"
//             ..click();
//       Get.snackbar(
//         "Download Complete",
//         "The audio has been downloaded.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       print("Error downloading audio: $e");
//       Get.snackbar(
//         "Download Failed",
//         "There was an error downloading the file.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (!isPlaying)
//           ElevatedButton(
//             onPressed: _playAudio,
//             child: Icon(Icons.play_arrow),
//           ),
//         if (isPlaying)
//           Row(
//             children: [
//               IconButton(
//                 onPressed: _pauseAudio,
//                 icon: Icon(Icons.pause),
//               ),
//               IconButton(
//                 onPressed: _stopAudio,
//                 icon: Icon(Icons.stop),
//               ),
//             ],
//           ),
//         ElevatedButton(
//           onPressed: _downloadAudio,
//           child: Icon(Icons.download),
//         ),
//       ],
//     );
//   }
// }
