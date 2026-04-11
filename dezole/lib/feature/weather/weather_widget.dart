import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Weather',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.yellow, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    '24°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Nairobi, Kenya',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _WeatherStat(
                        icon: Icons.air,
                        label: 'Wind',
                        value: '15 km/h',
                      ),
                      _WeatherStat(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '65%',
                      ),
                      _WeatherStat(
                        icon: Icons.cloud,
                        label: 'UV Index',
                        value: '6',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '5-Day Forecast',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            _ForecastCard(day: 'Today', temp: '24°C', icon: Icons.wb_sunny),
            _ForecastCard(day: 'Tomorrow', temp: '26°C', icon: Icons.wb_cloudy),
            _ForecastCard(day: 'Wednesday', temp: '23°C', icon: Icons.grain),
            _ForecastCard(day: 'Thursday', temp: '25°C', icon: Icons.wb_sunny),
            _ForecastCard(day: 'Friday', temp: '27°C', icon: Icons.wb_sunny),
          ],
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final String day;
  final String temp;
  final IconData icon;

  const _ForecastCard({
    required this.day,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomTheme.lightGray),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Text(
            temp,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
