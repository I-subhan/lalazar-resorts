import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../component/mediaquery.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.04),
                    Text(
                      'What we do',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Expanded(
                      child: PageView(
                        controller: controller,
                        children: [
                          _buildPage(
                            'Comfortable Accomodations',
                            'Experience unparalleled comfort in our inviting rooms. Relax, unwind, and enjoy a stay designed with your peace and relaxation in mind.',
                            Image(
                              image: NetworkImage(
                                'https://img.freepik.com/premium-vector/green-house-icon-circle_620118-24.jpg',
                              ),
                            ),
                          ),
                          _buildPage(

                            'Outdoor Views',
                            'Experience the beauty of nature from your window. Relax amidst stunning landscapes that refresh your mind and soul.',
                            Image(
                              image: NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/016/431/039/non_2x/outdoor-icon-design-free-vector.jpg',
                              ),
                            ),
                          ),
                          _buildPage(
                            'Delicious Cuisine',
                            'Savor mouthwatering dishes crafted with passion. Enjoy delightful flavors that make every meal a memorable experience.',
                            Image(
                              image: NetworkImage(
                                'https://icon-library.com/images/health-food-icon/health-food-icon-17.jpg',
                              ),
                            ),
                          ),
                          _buildPage(
                            'Play Area For Kids',
                            'Rock on with our climbing area! Kids can climb, conquer, and create unforgettable memories in a safe and fun environment.',
                            Image(

                              image: NetworkImage(
                                'https://img.freepik.com/premium-vector/family-with-arms-around-each-other-circle_1246656-3891.jpg',
                              ),
                            ),
                          ),
                          _buildPage(
                            'Hiking & Trekking',
                            'Experience the thrill of adventure on scenic trails. Explore nature’s beauty, breathe in the fresh air, and enjoy moments designed for excitement and discovery.',
                            Image(
                              color: Colors.green[700],
                              image: NetworkImage(
                                'https://img.icons8.com/?size=100&id=9844&format=png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Colors.green.shade700,
                          dotColor: Colors.grey.shade400,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildPage(String title, String desc, Image image) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: mediaquery.screenheight*0.25,
            width: mediaquery.screenwidth*0.7,
            child: image,
          ),
          SizedBox(height:mediaquery.screenheight*0.0195,),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: mediaquery.screenheight*0.0125,),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    ),
  );
}
