import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BottomSheetResult extends StatelessWidget {
  const BottomSheetResult({
    super.key,
    required List output,
  }) : _output = output;

  final List _output;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white70,
          context: context,
          builder: (BuildContext context) {
            String output_label = '${_output[0]['label']}';

            double conf_score = _output[0]['confidence'] * 100 - 10;

            return SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 2.2,
                      indent: 130,
                      endIndent: 130,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close_outlined),
                        ),
                      ],
                    ),
                    Text(
                      output_label,
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 20),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width - 180,
                      child: SfRadialGauge(
                        axes: [
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 10,
                            ranges: [
                              GaugeRange(
                                startValue: 0,
                                endValue: 30,
                                color: output_label == 'Bengin'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              GaugeRange(
                                startValue: 30,
                                endValue: 75,
                                color: Colors.orange,
                              ),
                              GaugeRange(
                                startValue: 75,
                                endValue: 100,
                                color: output_label == 'Bengin'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                            pointers: [
                              NeedlePointer(
                                value: conf_score,
                                enableAnimation: true,
                                needleLength: 0.6,
                                needleStartWidth: 0.8,
                                needleEndWidth: 0.9,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text(
                      '${conf_score.round()}% is the Confidence of Our Ai that Image is having ${output_label} Skin Cancer',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Center(
                    //   child: ElevatedButton(
                    //     child: Text('Close'),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Material(
        elevation: 1.8,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color.fromARGB(255, 64, 115, 255),
          ),
          child: Text(
            "Result",
            style: GoogleFonts.roboto(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
