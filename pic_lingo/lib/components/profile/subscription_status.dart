import 'package:flutter/material.dart';

class SubscriptionStatus extends StatelessWidget {
  final String tier;
  final int creditLimit;
  final int currentCredits;

  const SubscriptionStatus({
    super.key,
    required this.tier,
    required this.creditLimit,
    required this.currentCredits,
  });

  String get tierName {
    return tier == 'free' ? '免費方案' : '進階方案';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '方案資訊',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(tierName),
                  backgroundColor: Theme.of(context).primaryColor,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('每日點數上限', '$creditLimit 點'),
            const SizedBox(height: 8),
            _buildInfoRow('剩餘點數', '$currentCredits 點'),
            const SizedBox(height: 24),
            if (tier == 'free')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 實作升級方案的功能
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('升級方案'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 