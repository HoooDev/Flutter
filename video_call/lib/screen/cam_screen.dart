import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;

  int? uid = 0;

  int? otherUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder<bool>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      renderMainView(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: renderSubView(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (engine != null) {
                          await engine!.leaveChannel();
                          engine = null;
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('?????? ?????????')),
                )
              ],
            );
          }),
    );
  }

  renderMainView() {
    if (uid == null) {
      return Center(
        child: Text('????????? ??????????????????'),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: VideoCanvas(
            uid: 0,
          ),
        ),
      );
    }
  }

  renderSubView() {
    if (otherUid == null) {
      return Center(
        child: Text('????????? ????????? ????????????.'),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    }
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '????????? ?????? ????????? ????????? ????????????.';
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();

      await engine!.initialize(
        RtcEngineContext(
          appId: APP_ID,
        ),
      );

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          // ?????? ????????? ???????????? ???
          // connection -> ?????? ??????
          // elapsed -> ????????? ?????? (???????????? ????????? ?????????)
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('????????? ??????????????????. uid: ${connection.localUid}');
            setState(
              () {
                uid = connection.localUid;
              },
            );
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print('?????? ??????');
            setState(
              () {
                uid = null;
              },
            );
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('????????? ????????? ??????????????????. otherUid : ${remoteUid}');
            setState(
              () {
                otherUid = remoteUid;
              },
            );
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print('????????? ???????????? ???????????????. otherUid : $remoteUid');
            setState(
              () {
                otherUid = null;
              },
            );
          },
        ),
      );
      await engine!.enableVideo();

      await engine!.startPreview();

      ChannelMediaOptions options = ChannelMediaOptions();

      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        uid: 0,
        options: options,
      );
    }

    return true;
  }
}
