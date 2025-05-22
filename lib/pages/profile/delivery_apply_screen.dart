import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery_app/constants/my_colors.dart';
import 'package:delivery_app/pages/profile/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DeliveryApplyScreen extends StatefulWidget {
  const DeliveryApplyScreen({super.key, required this.onApply});
  final VoidCallback onApply;

  @override
  State<DeliveryApplyScreen> createState() => _DeliveryApplyScreenState();
}

class _DeliveryApplyScreenState extends State<DeliveryApplyScreen> {
  bool _acceptTerms = false;
  File? _nationalCardImage;
  File? _vehiclePapersImage;
  bool _isSubmitting = false;
  bool _isLoadingNationalCard = false;
  bool _isLoadingVehiclePapers = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isNationalCard) async {
    setState(() {
      if (isNationalCard) {
        _isLoadingNationalCard = true;
      } else {
        _isLoadingVehiclePapers = true;
      }
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          if (isNationalCard) {
            _nationalCardImage = File(pickedFile.path);
          } else {
            _vehiclePapersImage = File(pickedFile.path);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    } finally {
      setState(() {
        if (isNationalCard) {
          _isLoadingNationalCard = false;
        } else {
          _isLoadingVehiclePapers = false;
        }
      });
    }
  }

  void _showImageSourceModal(bool isNationalCard) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: MyColors.primaryColor),
                title: const Text("Import from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isNationalCard);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: MyColors.primaryColor),
                title: const Text("Take a Picture"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isNationalCard);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFullImage(File imageFile) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to click continue
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 60, color: MyColors.primaryColor),
              const SizedBox(height: 20),
              Text(
                "Your Request is Passed Successfully",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                "Wait to analyze your request and get an answer in a short time.",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  "Continue",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isConfirmEnabled =
        _nationalCardImage != null && _vehiclePapersImage != null && _acceptTerms;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          // Use Navigator.pop instead of pushReplacement to go back naturally
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: MyColors.primaryColor,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: true,
        title: Text(
          "Delivery Apply",
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Text(
              "Take pictures of your Documents to Confirm\nyour Identity",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            _documentUploadTile(
              title: "National Card",
              icon: Icons.credit_card_outlined,
              image: _nationalCardImage,
              isNationalCard: true,
              isLoading: _isLoadingNationalCard,
            ),
            const SizedBox(height: 15),
            _documentUploadTile(
              title: "Vehicle Papers",
              icon: Icons.directions_car_outlined,
              image: _vehiclePapersImage,
              isNationalCard: false,
              isLoading: _isLoadingVehiclePapers,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: MyColors.primaryColor,
                  onChanged: (bool? value) {
                    setState(() => _acceptTerms = value ?? false);
                  },
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Accept our terms and conditions included in the app",
                    style: GoogleFonts.nunitoSans(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isConfirmEnabled && !_isSubmitting
                    ? () async {
                        setState(() {
                          _isSubmitting = true;
                        });

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        // Fixed: Use the same key as in ProfileScreen
                        await prefs.setBool('hasAppliedForDelivery', true);

                        await Future.delayed(const Duration(milliseconds: 800));
                        
                        // Call the callback to update parent
                        widget.onApply();
                        
                        _showSuccessPopup();

                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isConfirmEnabled ? MyColors.primaryColor : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        "Confirm",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentUploadTile({
    required String title,
    required IconData icon,
    required File? image,
    required bool isNationalCard,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (image != null)
                GestureDetector(
                  onTap: () => _showFullImage(image),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: () => _showImageSourceModal(isNationalCard),
                  icon: Icon(Icons.file_upload_outlined, color: MyColors.primaryColor),
                ),
              if (image != null)
                Icon(Icons.check_circle, color: MyColors.primaryColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}