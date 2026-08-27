import 'package:flutter/material.dart';
import 'package:task_management/api/auth/api_refreshtoken.dart';
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/api/users/api_updateuser.dart';
import 'package:task_management/models/user_response.dart';
import 'package:task_management/validation/validators.dart';
import 'package:task_management/widgets/buildsectiontitle.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({
    super.key,
    required this.userData,
    required this.password,
  });

  final UserModel userData;
  final String password;

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _jobTitleController;

  bool _isLoading = false;
  UserModel? updatedUser;

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController(text: widget.userData.fullName);

    _userNameController = TextEditingController(text: widget.userData.userName);

    _emailController = TextEditingController(
      text: widget.userData.emailAddress,
    );

    _passwordController = TextEditingController(text: widget.password);

    _jobTitleController = TextEditingController(text: widget.userData.jobTitle);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _jobTitleController.dispose();

    super.dispose();
  }

  // ============================================================
  // VALIDATE & SAVE
  // ============================================================

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ApiUpdateUser updateUser = ApiUpdateUser();

    final ApiRefreshToken refreshTokenApi = ApiRefreshToken();

    setState(() {
      _isLoading = true;
    });

    try {
      // ========================================================
      // FIRST REQUEST
      // ========================================================

      updatedUser = await updateUser.updateUser(
        userId: widget.userData.userId,
        fullName: _fullNameController.text,
        userName: _userNameController.text,
        emailAddress: _emailController.text,
        password: _passwordController.text,
        jobTitle: _jobTitleController.text,
        timeZone: widget.userData.timeZone,
        accountStatus: widget.userData.accountStatus,
        dateCreated: widget.userData.dateCreated,
        lastLoginDate: widget.userData.lastLoginDate,
        role: widget.userData.role,
      );

      Navigator.pop(context, updatedUser);

      print('User updated successfully');

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account information validated successfully'),
        ),
      );
    } on UnauthorizedException {
      try {
        print('Access token expired. Refreshing...');

        // Refresh tokens
        await refreshTokenApi.refreshToken(widget.userData.emailAddress);

        print('Token refreshed successfully');

        // ======================================================
        // RETRY CREATE TASK
        // ======================================================

        updatedUser = await updateUser.updateUser(
          userId: widget.userData.userId,
          fullName: _fullNameController.text,
          userName: _userNameController.text,
          emailAddress: _emailController.text,
          password: _passwordController.text,
          jobTitle: _jobTitleController.text,
          timeZone: widget.userData.timeZone,
          accountStatus: widget.userData.accountStatus,
          dateCreated: widget.userData.dateCreated,
          lastLoginDate: widget.userData.lastLoginDate,
          role: widget.userData.role,
        );

        Navigator.pop(context, updatedUser);

        print('Task created successfully after refresh');
      } catch (e) {
        print('Refresh/Create task failed: $e');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Account')),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 28),

                const Buildsectiontitle(title: 'Personal Information'),

                const SizedBox(height: 16),

                // ==================================================
                // FULL NAME
                // ==================================================
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validators.fullName(value),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // USERNAME
                // ==================================================
                TextFormField(
                  controller: _userNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.userName(value),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EMAIL
                // ==================================================
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.email(value),
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // Password
                // ==================================================
                TextFormField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => Validators.password(value),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your new password',
                    prefixIcon: Icon(Icons.password),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // JOB TITLE
                // ==================================================
                TextFormField(
                  controller: _jobTitleController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,

                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    hintText: 'Enter your job title',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                ),

                const SizedBox(height: 32),

                // ==================================================
                // SAVE BUTTON
                // ==================================================
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // CANCEL BUTTON
                // ==================================================
                OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
