import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  
 final String cat_img;
  final String cat_name;
 final String cat_id; // Ensure this is a String for consistency

  const CategoryPage({Key? key, required this.cat_img, required this.cat_name, required this.cat_id}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();

  
}

class _CategoryPageState extends State<CategoryPage> {
  final int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    




    return     GestureDetector( 
      onTap: (){

      },
      child: Container(
        child: Row(
          children: [
            Container(
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.cat_img),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        widget.cat_name,
                        style: const TextStyle(fontSize: 19,),
                      ),
                    ),
                  ),


                  Radio(value: int.parse(widget.cat_id), groupValue: _selectedValue, onChanged: (value){
                   // _selectedValue = value.toString();
                    print(value);
                   
                  }),
                        

                
                ],
              ),
            ),


           
          ],
        ),
      ),
    );
  }
}