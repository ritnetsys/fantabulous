import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: calculateHeight(isPotrait? 5: 10 ), horizontal: calculateWidth(isPotrait? 4: 20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ABOUT US',
              style: GoogleFonts.sourceSerifPro(
                  color: Colors.green[800], fontSize: 30)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Fantabulous Flowers & Fruit Trees was established by Pradipta Majumder, in the year 2016 and is a leading supplier of plants to various NGOs, Horticulturists and nurseries. With our vast experience, we are producing, cultivating and marketing different kinds of plants all over the country and we also undertake projects of landscaping. We own thousands of varieties of plants in the plant kingdom. Our organization is a unique essence of greenery, freshness, immorality and indeed a green revolution. We have come a long way since inception, educating ourselves and learning from experience. We specialize in the cultivation and sale of plants, landscaping, sale of garden accessories, equipment. We’ve been serving all over India. We also offer complete landscaping services. You can always get advice about plant care and maintenance from us. We’re here to answer all your gardening questions.\nHAPPY GARDENING….',
              textAlign: isPotrait? TextAlign.start: TextAlign.center,
              style: TextStyle(fontSize: isPotrait? 13: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text('TREES FOR ALL',
                style: GoogleFonts.sourceSerifPro(
                    color: Colors.green[800], fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Why plant trees? Because they change lives. Trees are a vital part of our planet’s ecosystem. We all rely on trees and their products: oxygen, fruits, wood, water, medicines and soil nutrients to name a few. They not only give life, but they also improve livelihoods. Trees help mitigate human impact on climate change. Simply put, the more trees we plant, and the more we slow down and reverse deforestation, the greater the Earth’s ability to lock carbon out of the atmosphere and slow global warming. Forests and trees provide vital habitats for the majority of the world’s plant and animal species. Rainforests – just one type of forest – cover less than 2% of the Earth’s total surface area and yet are home to 50% of the Earth’s plants and animals. Deforestation is threatening the habitats of millions of species that rely on forests to survive.As well as providing animals with vital habitats, forests hold a huge number of plant species, many of which are unknown or not thoroughly studied. Forests are therefore a huge resource in terms of medicine and botanical knowledge.',
              textAlign: isPotrait? TextAlign.start:  TextAlign.center,
              style: TextStyle(fontSize: isPotrait? 13: 18),
            ),
          )
        ],
      ),
    );
  }
}
