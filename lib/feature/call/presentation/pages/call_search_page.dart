import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/call/data/call_permissions.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CallSearchPage extends StatefulWidget {
  const CallSearchPage({super.key});

  @override
  State<CallSearchPage> createState() => _CallSearchPageState();
}

class _CallSearchPageState extends State<CallSearchPage> {
  final _callService = CallService();
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _allCalls = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _callService.currentUserId;
    _loadCalls();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCalls() async {
    final calls = await _callService.getCallHistory();
    setState(() {
      _allCalls = calls;
      _filtered = calls;
      _loading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _allCalls;
      } else {
        _filtered = _allCalls.where((call) {
          final isOutgoing = call['caller_id'] == _currentUserId;
          final other = isOutgoing ? call['callee'] : call['caller'];
          final fullName = (other?['full_name'] ?? '').toLowerCase();
          final username = (other?['username'] ?? '').toLowerCase();
          final email = (other?['email'] ?? '').toLowerCase();
          return fullName.contains(query.toLowerCase()) ||
              username.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _startCall({
    required String calleeId,
    required String calleeName,
    required String calleeAvatar,
    required bool isVideo,
  }) async {
    final hasPermission = await requestCallPermissions(isVideo);
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mikrofon/kamera izni gerekiyor')),
        );
      }
      return;
    }
    try {
      final call = await _callService.initiateCall(
        calleeId: calleeId,
        type: isVideo ? CallType.video : CallType.audio,
      );
      final token = await _callService.getLiveKitToken(
        roomName: call['room_name'],
        callId: call['id'],
      );
      if (mounted) {
        context.push(
          '/call',
          extra: {
            'callId': call['id'],
            'roomName': call['room_name'],
            'token': token,
            'isVideo': isVideo,
            'callerName': calleeName,
            'callerImage': calleeAvatar,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Arama başlatılamadı: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        iconTheme: IconThemeData(color: colors.buttonText),
        title: Text(
          local.t('homeCalls'),
          style: TextStyle(color: colors.buttonText),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: colors.primaryButton,
            child: TextFormField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onSearch,
              decoration: InputDecoration(
                fillColor: colors.buttonText,
                prefixIcon: Icon(Icons.search, color: colors.placeholder),
                hintText: local.t('homeSearch'),
                hintStyle: TextStyle(color: colors.placeholder),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                ? Center(
                    child: Text(
                      'Sonuç bulunamadı',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  )
                : SafeArea(
                    child: ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final call = _filtered[index];
                        final isOutgoing = call['caller_id'] == _currentUserId;
                        final other = isOutgoing
                            ? call['callee']
                            : call['caller'];
                        final fullName =
                            other?['full_name'] ??
                            other?['username'] ??
                            other?['email'] ??
                            'Bilinmeyen';
                        final avatarUrl = other?['avatar_url'] ?? '';

                        return CallHistoryCard(
                          name: fullName,
                          image: avatarUrl.isNotEmpty ? avatarUrl : null,
                          time: _formatTime(call['created_at']),
                          isActive: false,
                          isOutgoingCall: isOutgoing,
                          isVideoCall: call['call_type'] == 'video',
                          press: () => _startCall(
                            calleeId: other?['id'] ?? '',
                            calleeName: fullName,
                            calleeAvatar: avatarUrl,
                            isVideo: call['call_type'] == 'video',
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.parse(isoDate);
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return '${diff.inDays} gün önce';
  }
}

class CallHistoryCard extends StatelessWidget {
  const CallHistoryCard({
    super.key,
    required this.name,
    required this.time,
    required this.isActive,
    required this.isVideoCall,
    required this.isOutgoingCall,
    this.image,
    required this.press,
  });

  final String name, time;
  final String? image;
  final bool isActive, isVideoCall, isOutgoingCall;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      onTap: press,
      leading: CircleAvatarWithActiveIndicator(
        image: image,
        isActive: isActive,
        radius: 28,
      ),
      title: Text(name, style: TextStyle(color: colors.textPrimary)),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
        child: Row(
          children: [
            Icon(
              isOutgoingCall ? Icons.north_east : Icons.south_west,
              size: 16,
              color: isOutgoingCall ? colors.primaryButton : colors.dangerColor,
            ),
            const SizedBox(width: 16.0 / 2),
            Text(time, style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      ),
      trailing: Icon(
        isVideoCall ? Icons.videocam : Icons.call,
        color: colors.primaryButton,
      ),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
    this.isActive,
  });

  final String? image;
  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: (image != null && image!.isNotEmpty)
              ? NetworkImage(image!)
              : null,
          child: (image == null || image!.isEmpty)
              ? Icon(Icons.person, size: radius, color: colors.buttonText)
              : null,
        ),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: colors.primaryButton,
                shape: BoxShape.circle,
                border: Border.all(color: colors.scaffoldBackground, width: 3),
              ),
            ),
          ),
      ],
    );
  }
}

final List<String> demoContactsImage = [
  'https://i.postimg.cc/g25VYN7X/user-1.png',
  'https://i.postimg.cc/cCsYDjvj/user-2.png',
  'https://i.postimg.cc/sXC5W1s3/user-3.png',
  'https://i.postimg.cc/4dvVQZxV/user-4.png',
  'https://i.postimg.cc/FzDSwZcK/user-5.png',
];
