import 'package:flutter/material.dart';
import 'package:lalazar_resorts/component/button.dart';
import 'package:lalazar_resorts/component/mediaquery.dart';
import 'package:lalazar_resorts/provider/confirm_provider.dart';
import 'package:lalazar_resorts/screens/rooms/payment_screen.dart';
import 'package:provider/provider.dart';



class ConfirmScreen extends StatefulWidget {
  final int totalRoomsToSelect;
  final String bookingId;

  const ConfirmScreen({super.key,required this.totalRoomsToSelect,required this.bookingId});


  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   final confirmProvider = Provider.of<ConfirmProvider>(context,listen: false);
   confirmProvider.getuser();
   confirmProvider.getTotalAmount(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: mediaquery.screenheight*0.3,
                    width: mediaquery.screenwidth,
                    color: Colors.green[900],
                    child: Column(
                      children: [
                        Container(
                          height: mediaquery.screenheight * 0.15,
                          width: mediaquery.screenwidth* 0.35,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/images/lalazar.jpeg'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
          
                      ],
          
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 160),
                    child: SizedBox(
                      height: mediaquery.screenheight,
                      width: mediaquery.screenwidth,
                      child: Container(
                        height: mediaquery.screenheight * 0.4,
                        width: mediaquery.screenwidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),
                            ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Consumer<ConfirmProvider>(builder: (context,confirmProvider,_){

                            return  Column(
                              children: [
                                reusableRow('Name ','${confirmProvider.name}'),
                                Divider(),
                                reusableRow('Contact','${confirmProvider.number}',),
                                Divider(),
                                reusableRow('Total Rooms','${widget.totalRoomsToSelect??0}'),
                                Divider(),
                                reusableRow('Total Amount','${confirmProvider.totalAmount}'),
                                Divider(),
                                reusableRow('Advance 40%','${confirmProvider.advance}'),
                                Divider(),


                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 110),
                                  child: Button(title: 'Proceed', onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen(bookingId: widget.bookingId,
                                      totalAmount: confirmProvider.totalAmount,
                                      advance: confirmProvider.advance,)));

                                  },width: mediaquery.screenwidth *0.4,),
                                )
                              ],
                            );


                          })



                        ),
                      )
          
                      ),
                    ),
          ]
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget reusableRow(String title,String value,){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Row(
        children: [
          Text(title,style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
          Spacer(),
          Text(value,style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.bold,fontSize: 18),),

        ],
      ),
    );
  }

}
