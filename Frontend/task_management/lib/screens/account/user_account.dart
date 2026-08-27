import 'package:flutter/material.dart';
import 'package:task_management/api/auth/api_logout.dart';
import 'package:task_management/api/auth/api_refreshtoken.dart';
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/api/users/api_getuserid.dart';
import 'package:task_management/api/users/api_getuserdata.dart';
import 'package:task_management/models/user_response.dart';
import 'package:task_management/screens/account/update_account.dart';
import 'package:task_management/screens/auth/login.dart';
import 'package:task_management/token/token_storage.dart';
import 'package:task_management/widgets/buildinformationcard.dart';
import 'package:task_management/widgets/buildprofileheader.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();

    _loadProfileData();
  }

  // ============================================================
  // LOAD PROFILE DATA
  // ============================================================

  Future<void> _loadProfileData() async {
    final GetUserIdUsingEmail getUserIdApi = GetUserIdUsingEmail();
    final ApiRefreshToken _apiRefreshToken = ApiRefreshToken();
    final int userId = await getUserIdApi.getUserId(widget.email);
    try {
      final GetUserDataApi userDataApi = GetUserDataApi();

      final UserModel user = await userDataApi.getUserData(userId);

      if (!mounted) return;

      setState(() {
        _user = user;
      });
    } on UnauthorizedException {
      // --------------------------------------------------------
      // REFRESH TOKEN
      // --------------------------------------------------------

      try {
        await _apiRefreshToken.refreshToken(widget.email);

        final GetUserDataApi userDataApi = GetUserDataApi();

        final UserModel user = await userDataApi.getUserData(userId);

        if (!mounted) return;

        setState(() {
          _user = user;
        });
      } catch (e) {
        print('Refresh/Create task failed: $e');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    }
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _editProfile() async {
    final UserModel? UserInfo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateAccountScreen(userData: _user!, password: widget.password),
      ),
    );

    if (UserInfo == null) return;

    if (!mounted) return;

    setState(() {
      _user!.fullName = UserInfo.fullName;
      _user!.userName = UserInfo.userName;
      _user!.emailAddress = UserInfo.emailAddress;
      _user!.password = UserInfo.password;
      _user!.jobTitle = UserInfo.jobTitle;
    });
  }

  Future<void> _logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return;
    }

    final success = await ApiLogout.logout(
      email: widget.email,
      refreshToken: refreshToken,
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================================================
            // PROFILE HEADER
            // ==================================================
            Buildprofileheader(
              fullName: _user!.fullName,
              userName: _user!.userName,
              jobTitle: _user!.jobTitle,
            ),

            const SizedBox(height: 24),

            // ==================================================
            // USER INFORMATION
            // ==================================================
            Buildinformationcard(
              fullName: _user!.fullName,
              userName: _user!.userName,
              email: _user!.emailAddress,
              password: _user!.password,
              jobTitle: _user!.jobTitle,
            ),

            const SizedBox(height: 20),

            // ==================================================
            // EDIT PROFILE
            // ==================================================
            ElevatedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
