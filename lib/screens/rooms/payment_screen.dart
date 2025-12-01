import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/provider/payment_provider.dart';
import 'package:lalazar_resorts/screens/rooms/thankyou_screen.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double totalAmount;
  final double advance;

  const PaymentScreen({super.key, required this.bookingId,required this.totalAmount,required this.advance});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      children: [
                        reusableCard('Easy Paisa', 'https://crystalpng.com/wp-content/uploads/2024/10/Easypaisa-logo.png',
                            'EasyPaisa selected'),
                        reusableCard('Jazz Cash', 'https://crystalpng.com/wp-content/uploads/2024/12/new-Jazzcash-logo.png',
                            'Jazz Cash selected'),
                        reusableCard('Card Payment', 'https://logo.svgcdn.com/l/mastercard.png', 'Card Payment selected'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: mediaquery.screenheight * 0.07,),
              
              Consumer<PaymentProvider>(builder: (context,provider,child){
                
                return Button(title: 'Upload', onTap: ()async{
                  await provider.pickImage();
                  final success = await provider.uploadReceipt(
                      bookingId: widget.bookingId, totalAmount: widget.totalAmount, advance: widget.advance);

                  if(success){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ThankyouScreen()));
                  }



                  },width: mediaquery.screenwidth * 0.4,);
                
                
              })
              
              
              
              
              
            ],
          ),
        ),
      ),
    );
  }

  Widget reusableCard(String method,String url,String message){
    return Consumer<PaymentProvider>(builder: (context,provider,child){
      return InkWell(
        onTap: (){
          provider.selected(method);
          Utils().toastSuccess(message);

        },
        child: SizedBox(
          height: mediaquery.screenheight *0.2 ,
          width: mediaquery.screenwidth*0.98,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            color: Colors.green[800],
            elevation: 7,
            shadowColor: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height:  mediaquery.screenheight *0.125,
                          width:  mediaquery.screenwidth *0.280 ,
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              height:  mediaquery.screenheight *0.125,
                              width:  mediaquery.screenwidth *0.125 ,
                              image: NetworkImage(
                                url,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width:  mediaquery.screenwidth *0.0190 ,),
                                Text(
                                  'Account:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width:  mediaquery.screenwidth * 0.0190,),
                                Text(
                                  '03246789327',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaquery.screenheight*0.0125),
                            Row(
                              children: [
                                SizedBox(width: mediaquery.screenwidth*0.0125),
                                Text(
                                  'Name:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: mediaquery.screenwidth*0.0120),
                                Text(
                                  'Lalazar Resorts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      );


    });
      
      
      

  }
}


