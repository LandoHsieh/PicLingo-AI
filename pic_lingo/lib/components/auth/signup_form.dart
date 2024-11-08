import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 使用者名稱
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '使用者名稱',
              prefixIcon: Icon(Icons.person),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請輸入使用者名稱';
              }
              if (value.length < 3) {
                return '使用者名稱至少需要3個字元';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 電子郵件
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: '電子郵件',
              prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請輸入電子郵件';
              }
              if (!value.contains('@')) {
                return '請輸入有效的電子郵件格式';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 密碼
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: '密碼',
              helperText: '至少8個字元，包含大小寫字母和數字',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請輸入密碼';
              }
              if (value.length < 8) {
                return '密碼長度至少需要8個字元';
              }
              final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
              final hasLowerCase = value.contains(RegExp(r'[a-z]'));
              final hasNumber = value.contains(RegExp(r'[0-9]'));
              if (!hasUpperCase || !hasLowerCase || !hasNumber) {
                return '密碼必須包含大小寫字母和數字';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 確認密碼
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: '確認密碼',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: _obscureConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請再次輸入密碼';
              }
              if (value != _passwordController.text) {
                return '兩次輸入的密碼不相符';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // 註冊按鈕
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: _isLoading ? null : _handleSignup,
              // onPressed: _isLoading ? null : () {},
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('建立帳號'),
            ),
          ),
          const SizedBox(height: 16),

          // 返回登入
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('已有帳號？返回登入'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dio = Dio();
        final response = await dio.post(
          'http://localhost:3000/api/auth/register',
          data: {
            'email': _emailController.text,
            'password': _passwordController.text,
            'username': _usernameController.text,
          },
        );

        if (response.statusCode == 201) {
          // 儲存 token
          final token = response.data['token'];
          // TODO: 儲存 token 到 local storage

          if (mounted) {
            // 註冊成功後導向首頁
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } on DioException catch (e) {
        if (mounted) {
          String errorMessage = '註冊失敗';

          if (e.response?.data != null && e.response?.data['error'] != null) {
            errorMessage = e.response?.data['error'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('註冊失敗: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
