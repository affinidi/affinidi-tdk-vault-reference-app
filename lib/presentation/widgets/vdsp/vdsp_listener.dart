import 'package:flutter/material.dart';
import '../../themes/app_sizing.dart';

Future<bool> showVdspListenerSettings(
  BuildContext context,
  bool currentState,
) async {
  bool vdspState = currentState;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizing.paddingLarge),
      ),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizing.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enable / Disable VDSP',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: AppSizing.paddingMedium),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VDSP Listener Status: ',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),

                  Flexible(
                    child: Switch(
                      value: vdspState,
                      onChanged: (newState) {
                        setState(() {
                          vdspState = newState;
                        });
                        Navigator.of(context).pop(newState);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizing.paddingMedium),
            ],
          ),
        ),
      ),
    ),
  );

  return result ?? currentState;
}
