import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection(
              'Information We Collect',
              [
                'Personal Information: When you create an account, we collect your email address, username, and profile information.',
                'Usage Data: We collect information about how you use Kointos, including your interactions with cryptocurrency data, articles, and community features.',
                'Device Information: We may collect information about your device, including device type, operating system, and app version.',
                'Location Data: With your permission, we may collect location information to provide location-based features.',
              ],
            ),
            _buildSection(
              'How We Use Your Information',
              [
                'To provide and maintain our cryptocurrency tracking and social platform services.',
                'To personalize your experience and provide relevant cryptocurrency insights.',
                'To enable community features and facilitate user interactions.',
                'To send you important updates about your account and our services.',
                'To improve our services and develop new features.',
                'To detect and prevent fraud, abuse, and security issues.',
              ],
            ),
            _buildSection(
              'Information Sharing',
              [
                'We do not sell, trade, or rent your personal information to third parties.',
                'We may share aggregated, non-personally identifiable information for analytics purposes.',
                'We may share information with service providers who assist us in operating our platform.',
                'We may disclose information if required by law or to protect our rights and users.',
              ],
            ),
            _buildSection(
              'Data Security',
              [
                'We implement industry-standard security measures to protect your information.',
                'All data transmission is encrypted using SSL/TLS protocols.',
                'We regularly update our security practices and conduct security audits.',
                'However, no method of transmission over the internet is 100% secure.',
              ],
            ),
            _buildSection(
              'Cryptocurrency Data',
              [
                'Cryptocurrency prices and market data are sourced from third-party providers.',
                'We do not guarantee the accuracy or completeness of cryptocurrency data.',
                'Cryptocurrency investments are subject to market risks and volatility.',
                'Past performance does not guarantee future results.',
              ],
            ),
            _buildSection(
              'Your Rights',
              [
                'Access: You can request access to your personal information.',
                'Correction: You can request correction of inaccurate information.',
                'Deletion: You can request deletion of your account and personal data.',
                'Portability: You can request a copy of your data in a portable format.',
                'Opt-out: You can opt-out of non-essential communications.',
              ],
            ),
            _buildSection(
              'Cookies and Tracking',
              [
                'We use cookies and similar technologies to enhance your experience.',
                'Cookies help us remember your preferences and provide personalized content.',
                'You can control cookie settings through your browser preferences.',
                'Some features may not work properly if cookies are disabled.',
              ],
            ),
            _buildSection(
              'Third-Party Services',
              [
                'We integrate with third-party services for cryptocurrency data and analytics.',
                'These services have their own privacy policies and terms of service.',
                'We are not responsible for the privacy practices of third-party services.',
                'Please review the privacy policies of any third-party services you use.',
              ],
            ),
            _buildSection(
              'Changes to Privacy Policy',
              [
                'We may update this Privacy Policy from time to time.',
                'We will notify you of any material changes via email or in-app notification.',
                'Your continued use of Kointos after changes constitutes acceptance.',
                'We encourage you to review this policy periodically.',
              ],
            ),
            _buildSection(
              'Contact Information',
              [
                'If you have questions about this Privacy Policy, please contact us:',
                'Email: privacy@kointos.com',
                'Address: [Your Company Address]',
                'Phone: [Your Contact Number]',
              ],
            ),
            const SizedBox(height: 32),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kointos ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our cryptocurrency tracking and social platform.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.pureWhite,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.security,
            color: AppTheme.pureWhite,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Your Privacy Matters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We are committed to transparency and protecting your personal information. If you have any questions or concerns about our privacy practices, please don\'t hesitate to contact us.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
