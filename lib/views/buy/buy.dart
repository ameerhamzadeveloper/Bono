import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/buy/order_summry.dart';
import 'package:bono_gifts/views/buy/select_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pro = Provider.of<BuyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    final wcmp = Provider.of<WooCommerceMarketPlaceProvider>(context);
    int inde = 1000000;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Center(
                child: Text(
              "Buy Gifts",
              style: TextStyle(fontSize: 20),
            )),
            const SizedBox(
              height: 10,
            ),
            pro.userName != null
                ? Container(
                    padding: const EdgeInsets.only(
                        top: 25, bottom: 25, left: 15, right: 15),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("To"),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(pro.userImage!),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pro.userName!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "Birthday ${pro.userDob != null ? form.format(pro.userDob!).toString() : ''} (In ${pro.diffDays} Days)",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              wcmp.clearShops();
                              pro.clearAll();
                            },
                            icon: Icon(Icons.clear))
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectNetwokr()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 25, bottom: 25, left: 15, right: 15),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("To")),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "add a recepient",
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              RotatedBox(
                                quarterTurns: 4,
                                child: Image.asset(
                                  addBtn,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            pro.userName != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Delivery Address : Available"),
                      Text("Location : ${pro.userAddress}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, orderSummry),
                            color: Colors.grey,
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            giftWidget(wcmp,inde),
          ],
        ),
      ),
    );
  }

  Widget giftWidget(WooCommerceMarketPlaceProvider provider,int inde) {

    switch (provider.apiState) {
      case ApiState.none:
        return Container();
      case ApiState.loading:
        return Center(
            child: Column(
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 8.0,
            ),
            Text("Loading gift shops near you."),
          ],
        ));

      case ApiState.completed:
        return Expanded(
          child: Container(
            child: provider.nearbyVendors.isEmpty
                ? const Center(
                    child: Text("No gift shops found near you."),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        provider.categoriesshow.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  provider.categoriesshow[index].name ?? '',
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, prodIndex) => InkWell(
                                  onTap: (){
                                    provider.assignSumery(
                                      provider.filterByCategory(provider.categories[index])[prodIndex].price!,
                                      provider.filterByCategory(provider.categories[index])[prodIndex].weight!,
                                      provider.filterByCategory(provider.categories[index])[prodIndex].name!,
                                        provider.filterByCategory(provider.categories[index])[prodIndex].images!.first.src!,
                                    );
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => OrderSummry()
                                    ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 75,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 3,color: inde == prodIndex ? Colors.blue : Colors.grey)
                                        ),
                                        child: Image.network(provider
                                            .filterByCategory(provider
                                                .categories[index])[prodIndex]
                                            .images!
                                            .first
                                            .src!),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${provider.filterByCategory(provider.categories[index])[prodIndex].name!}",
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                              children: [
                                              Text(
                                                  "Price ${provider.filterByCategory(provider.categories[index])[prodIndex].price!}",
                                                  textAlign: TextAlign.start),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                separatorBuilder: (context, index) => const SizedBox(
                                  width: 8.0,
                                ),
                                itemCount: provider
                                    .filterByCategory(
                                        provider.categories[index])
                                    .length,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      case ApiState.error:
        return Center(
            child: Container(
          child: Text("Error!"),
        ));
    }
  }
}
