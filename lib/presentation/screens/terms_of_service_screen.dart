import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Terms of Service',
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
              'Acceptance of Terms',
              [
                'By accessing and using Kointos, you accept and agree to be bound by these Terms of Service.',
                'If you do not agree to these terms, you may not use our services.',
                'These terms apply to all users, including visitors, registered users, and premium subscribers.',
                'Your use of Kointos constitutes acceptance of these terms and any updates.',
              ],
            ),
            
            _buildSection(
              'Description of Service',
              [
                'Kointos is a cryptocurrency tracking and social platform that provides:',
                '• Real-time cryptocurrency prices and market data',
                '• Portfolio tracking and management tools',
                '• Social features including communities and discussions',
                '• Educational content and market analysis',
                '• AI-powered chatbot for cryptocurrency guidance',
                'We reserve the right to modify or discontinue services at any time.',
              ],
            ),
            
            _buildSection(
              'User Accounts and Registration',
              [
                'You must create an account to access certain features of Kointos.',
                'You are responsible for maintaining the confidentiality of your account credentials.',
                'You must provide accurate and complete information during registration.',
                'You are responsible for all activities that occur under your account.',
                'You must notify us immediately of any unauthorized use of your account.',
                'We reserve the right to suspend or terminate accounts that violate our terms.',
              ],
            ),
            
            _buildSection(
              'User Conduct and Prohibited Activities',
              [
                'You agree not to:',
                '• Post false, misleading, or fraudulent content',
                '• Engage in harassment, bullying, or abusive behavior',
                '• Share spam, advertising, or promotional content without permission',
                '• Attempt to manipulate cryptocurrency prices or markets',
                '• Violate any applicable laws or regulations',
                '• Infringe on intellectual property rights of others',
                '• Use automated systems to access our services without permission',
                '• Share inappropriate, offensive, or harmful content',
              ],
            ),
            
            _buildSection(
              'Financial Disclaimer',
              [
                'IMPORTANT: Kointos provides information for educational purposes only.',
                'We do not provide financial, investment, or trading advice.',
                'All cryptocurrency investments involve substantial risk of loss.',
                'Past performance does not guarantee future results.',
                'You should consult with qualified financial advisors before making investment decisions.',
                'We are not responsible for any financial losses resulting from your use of our platform.',
              ],
            ),
            
            _buildSection(
              'Data Accuracy and Reliability',
              [
                'While we strive to provide accurate information, we cannot guarantee:',
                '• The accuracy or completeness of cryptocurrency data',
                '• The reliability of third-party data sources',
                '• The availability of our services at all times',
                '• The accuracy of user-generated content',
                'You should verify information from multiple sources before making decisions.',
              ],
            ),
            
            _buildSection(
              'Intellectual Property Rights',
              [
                'Kointos and its content are protected by intellectual property laws.',
                'You may not reproduce, distribute, or create derivative works without permission.',
                'User-generated content remains owned by the respective users.',
                'By posting content, you grant us a license to use, display, and distribute it.',
                'You represent that you have the right to post any content you share.',
              ],
            ),
            
            _buildSection(
              'Privacy and Data Protection',
              [
                'Your privacy is important to us. Please review our Privacy Policy.',
                'We collect and use information as described in our Privacy Policy.',
                'You consent to the collection and use of your information as outlined.',
                'We implement security measures to protect your personal information.',
                'You have certain rights regarding your personal data.',
              ],
            ),
            
            _buildSection(
              'Limitation of Liability',
              [
                'TO THE MAXIMUM EXTENT PERMITTED BY LAW:',
                '• We provide services "as is" without warranties of any kind',
                '• We are not liable for any indirect, incidental, or consequential damages',
                '• Our total liability is limited to the amount you paid for our services',
                '• We are not responsible for third-party content or services',
                '• You use our services at your own risk',
              ],
            ),
            
            _buildSection(
              'Indemnification',
              [
                'You agree to indemnify and hold harmless Kointos from any claims arising from:',
                '• Your use of our services',
                '• Your violation of these terms',
                '• Your violation of any third-party rights',
                '• Any content you post or share',
                'This indemnification includes reasonable attorney fees and costs.',
              ],
            ),
            
            _buildSection(
              'Termination',
              [
                'Either party may terminate this agreement at any time.',
                'We may suspend or terminate your account for violations of these terms.',
                'Upon termination, your right to use our services ends immediately.',
                'We may retain certain information as required by law or for legitimate business purposes.',
                'Provisions regarding liability and disputes survive termination.',
              ],
            ),
            
            _buildSection(
              'Changes to Terms',
              [
                'We reserve the right to modify these terms at any time.',
                'We will notify users of material changes via email or in-app notification.',
                'Your continued use after changes constitutes acceptance of new terms.',
                'If you disagree with changes, you should discontinue using our services.',
              ],
            ),
            
            _buildSection(
              'Governing Law and Disputes',
              [
                'These terms are governed by the laws of [Your Jurisdiction].',
                'Any disputes will be resolved through binding arbitration.',
                'You waive the right to participate in class action lawsuits.',
                'If arbitration is unavailable, disputes will be resolved in [Your Jurisdiction] courts.',
              ],
            ),
            
            _buildSection(
              'Contact Information',
              [
                'For questions about these Terms of Service, contact us:',
                'Email: legal@kointos.com',
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
            'Terms of Service',
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
            'Welcome to Kointos. These Terms of Service ("Terms") govern your use of our cryptocurrency tracking and social platform. Please read these terms carefully before using our services.',
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
              color: AppTheme.primaryColor,
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
                if (!item.startsWith('•') && !item.startsWith('IMPORTANT:') && !item.startsWith('TO THE MAXIMUM')) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item.startsWith('IMPORTANT:') || item.startsWith('TO THE MAXIMUM')
                          ? Colors.orange[300]
                          : Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: item.startsWith('IMPORTANT:') || item.startsWith('TO THE MAXIMUM')
                          ? FontWeight.bold
                          : FontWeight.normal,
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
      child: Column(
        children: [
          const Icon(
            Icons.gavel,
            color: AppTheme.primaryColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Legal Compliance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'By using Kointos, you acknowledge that you have read, understood, and agree to these Terms of Service. These terms are designed to protect both you and our platform while ensuring a safe and compliant environment for all users.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Remember: Cryptocurrency investments are risky. Never invest more than you can afford to lose.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
