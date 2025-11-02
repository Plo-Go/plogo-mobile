import 'package:flutter/material.dart';
import 'package:plogo/shared/widgets/top_bar.dart';

class LogScreen extends StatelessWidget {
	const LogScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: Column(
					children: [
						const Padding(
							padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
							child: TopBar(),
						),
						const SizedBox(height: 16),
						// 지도 자리 (아직 구현 전)
						Expanded(
							child: Container(
								color: Color(0xFFF5F5F5),
								child: const Center(
									child: Text(
										'카카오 맵',
										style: TextStyle(color: Colors.grey, fontSize: 16),
									),
								),
							),
						),
					],
				),
			),
		);
	}
}
