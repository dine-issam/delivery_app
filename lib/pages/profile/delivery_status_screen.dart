import 'package:delivery_app/constants/my_colors.dart';
import 'package:delivery_app/pages/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DeliveryStatusType { request, analysis, accepted, rejected }

class DeliveryStatusScreen extends StatelessWidget {
  final DeliveryStatusType status;

  const DeliveryStatusScreen({Key? key, required this.status})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: MyColors.whiteColor,
          ),
        ),
        backgroundColor: MyColors.primaryColor,
        toolbarHeight: 70.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [DeliveryStatusVisualizer(currentStatus: status)],
        ),
      ),
    );
  }
}

class DeliveryStatusVisualizer extends StatelessWidget {
  final DeliveryStatusType currentStatus;

  const DeliveryStatusVisualizer({Key? key, required this.currentStatus})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeliveryStatusStep(
          title: "Request",
          description: "Your request is set",
          status: _getStepStatus('request'),
          image: "assets/images//request.png",
        ),
        StepConnector(
          active: currentStatus.index >= DeliveryStatusType.analysis.index,
        ),
        DeliveryStatusStep(
          title: "Analysis",
          description: "Request is analysed",
          status: _getStepStatus('analysis'),
          image: "assets/images/analysis.png",
        ),
        StepConnector(
          active:
              currentStatus.index >= DeliveryStatusType.accepted.index ||
              currentStatus == DeliveryStatusType.rejected,
        ),
        DeliveryStatusStep(
          title: "Accepted",
          description: "Request is accepted",
          status: _getStepStatus('accepted'),
          image: "assets/images/accepted.png",
        ),
        if (currentStatus == DeliveryStatusType.rejected)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Your files are not accepted",
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _getStepStatus(String step) {
    final steps = ['request', 'analysis', 'accepted'];
    final current = currentStatus.toString().split('.').last;
    final currentIndex = steps.indexOf(current);
    final stepIndex = steps.indexOf(step);

    if (currentStatus == DeliveryStatusType.rejected && step == 'accepted') {
      return 'rejected';
    }

    if (stepIndex < currentIndex) return 'completed';
    if (stepIndex == currentIndex) return 'active';
    return 'pending';
  }
}

class DeliveryStatusStep extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String image;

  const DeliveryStatusStep({
    Key? key,
    required this.title,
    required this.description,
    required this.status,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Indicator Circle
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(child: _getStatusIcon()),
        ),
        const SizedBox(width: 16),

        // Step Info Card
        Container(
          width: 260,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.asset(image),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'completed':
      case 'active':
        return MyColors.primaryColor;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey.shade300;
    }
  }

  Widget _getStatusIcon() {
    switch (status) {
      case 'completed':
      case 'active':
        return const Icon(Icons.check_circle, color: Colors.white, size: 24);
      case 'rejected':
        return const Icon(Icons.cancel, color: Colors.white, size: 24);
      default:
        return const Icon(Icons.circle, color: Colors.white, size: 10);
    }
  }
}

class StepConnector extends StatelessWidget {
  final bool active;

  const StepConnector({Key? key, required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 12),
      height: 30,
      width: 1.5,
      color: active ? MyColors.primaryColor : Colors.grey.shade300,
    );
  }
}