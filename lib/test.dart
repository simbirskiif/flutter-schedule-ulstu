import 'package:flutter/material.dart';



class LiquidGlassRegularMedium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 445,
          height: 160,
          child: Stack(
            children: [
              Positioned(
                left: -26,
                top: -26,
                child: Container(
                  width: 497,
                  height: 212,
                  child: Stack(
                    children: [
                      Positioned(
                        left: -50,
                        top: -50,
                        child: Container(
                          width: 597,
                          height: 312,
                          padding: const EdgeInsets.all(76),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 445,
                                height: 160,
                                decoration: ShapeDecoration(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 26,
                        top: 31,
                        child: Container(
                          width: 445,
                          height: 160,
                          decoration: ShapeDecoration(
                            color: Colors.black.withOpacity(
                              0.07999999821186066,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 445,
                  height: 160,
                  decoration: ShapeDecoration(
                    color: Color(0x99F5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 445,
                  height: 160,
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.0010000000474974513),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
