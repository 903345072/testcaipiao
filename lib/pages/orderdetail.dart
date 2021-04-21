import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_k_chart/flutter_k_chart.dart';
import 'package:flutter_k_chart/utils/data_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/hangqing/StockRankList.dart';
import 'package:flutterapp2/pages/myorder.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/request.dart';

import 'ChildItemView.dart';
import 'flowUsers.dart';
class orderdetail extends StatefulWidget{
  int id;
  int type = 1;
  String f_or_b;
  orderdetail(this.id,this.type,this.f_or_b);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new hangqing_();
  }

}
class hangqing_ extends State<orderdetail>{
  Map game ={};
  Map order= {};
  int chang;
  Map num_to_cn = {"1":"一","2":"二","3":"三","4":"四","5":"五","6":"六","7":"末"};
  @override
  void initState() {
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.type==1?"普通投注详情":"跟单投注详情",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        backgroundColor: Color(0xfffa2020),

      ),

      body: Column(
        children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(color: Colors.white),
                    child: Wrap(
                      spacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,

                      children: <Widget>[
                        Text(widget.f_or_b == "f"?"竞彩足球":"竞彩篮球",style: TextStyle(fontWeight:FontWeight.bold),),
                        Text(DateTime.now().year.toString()+"期")
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5),
                    decoration: BoxDecoration(color: Colors.white),
                   width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text("订单金额"),
                            Text(order["amount"].toString()+".00元"),
                          ],
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text("订单状态"),
                            Text(order["state"]==0?"未开奖":order["state"]==1?"未中奖":"中奖",style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text("奖金"),
                            Text(order["state"]==2?(order["award_money"]-double.parse(order["jia_jiang"])).toStringAsFixed(2):"--",style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text("加奖"),
                            Text(order["state"]==2?double.parse(order["jia_jiang"]).toStringAsFixed(2):"--",style: TextStyle(color: Colors.red),),
                          ],
                        ),

                      ],
                    ),
                  ),

                  order["mode"] != "1"?Container(
                    margin: EdgeInsets.only(top: 5,left: 5,bottom: 5),
                    decoration: BoxDecoration(color:Colors.white,border: Border(bottom: BorderSide(width: 10,color: Color(0xfff5f5f5)))),

                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5,top: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.mode_edit,color: Colors.grey,),
                              Text("方案信息")
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("彩种:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text(order["type"]=="f"?"竞彩足球":"竞彩篮球",style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("跟单信息:"),
                              ),
                              Text("共"+order["all_amount"].toString()+"元",style: TextStyle(color: Colors.grey),),
                              GestureDetector(
                                onTap: (){
                                  JumpAnimation().jump(flowUsers(order_id: order["id"],), context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(120)),
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Text("跟单列表",style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("状态:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text("开赛后可查看投注详情",style: TextStyle(color: Colors.red),)
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ):Container(),

                  Container(
                    margin: EdgeInsets.only(top: 5,left: 5,bottom: 5),
                    child: Wrap(
                      spacing: 5,
                      children: <Widget>[
                        Text("投注信息: "),
                        Text(getChang(),style: TextStyle(color: Colors.red),),
                        Text(order["bei"].toString()+"倍",style: TextStyle(color: Colors.red),),
                      ],
                    ),
                  ),
                  Container(

                    child: ExpansionTile(

                      backgroundColor:Colors.white,
                      initiallyExpanded:true,
                      title: Text("选号详情",style: TextStyle(fontSize: 12),),
                      children: <Widget>[

                       order["mode"]!="4"?Container(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: 5,bottom: 5),
                          decoration: BoxDecoration(color: Color(0xfffff5f8)),
                          width: ScreenUtil().setWidth(410),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(60),
                              child: Text("场次"),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(95),
                              child: order["type"] =="f"?Text("主队VS客队"):Text("客队VS主队"),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(75),
                              child: Text("玩法"),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(95),
                              child: Text("投注"),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(60),
                              child: Text("彩果"),
                            )
                          ],
                        ),):Container(
                         padding: EdgeInsets.only(top: 5,bottom: 5),
                         decoration: BoxDecoration(color: Color(0xfffff5f8)),
                         width: ScreenUtil().setWidth(410),
                         child: Row(

                           children: <Widget>[
                             Container(
                               alignment: Alignment.center,
                               width: ScreenUtil().setWidth(60),
                               child: Text("串法"),
                             ),
                             Container(
                               alignment: Alignment.center,
                               width: ScreenUtil().setWidth(60),
                               child: Text("注数"),
                             ),
                             Container(
                               alignment: Alignment.center,
                               width: ScreenUtil().setWidth(60),
                               child: Text("玩法"),
                             ),
                             Container(
                               alignment: Alignment.center,
                               width: ScreenUtil().setWidth(150),
                               child: Text("投注"),
                             ),
                             Container(
                               alignment: Alignment.center,
                               width: ScreenUtil().setWidth(80),
                               child: Text("赛果"),
                             ),

                           ],
                         ),),
                        Container(
                          width: ScreenUtil().setWidth(410),
                          child: Column(
                            children: order["mode"]!="4"? getList():getOptList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5,top: 5),
                    child: Wrap(
                      spacing: 5,
                      direction: Axis.vertical,
                      children: <Widget>[
                        Text("下单时间:"+order["dtime"].toString()),
                        Text("订单编号:"+order["order_no"].toString()),
                        order["chuan"]=="1"?Text("过关方式:单关"):order["chuan"].toString() != ""? Text("过关方式:"+order["chuan"].toString()+"串1"):Text("过关方式:单关"),
                        Text("温馨提示:"+"中奖后奖金自动打入您的账户"),
                      ],
                    ),
                  )
                ],
              ),
            ),

        ],
      ),
    );
  }
  getChang(){
    if(order["mode"] != "4"){
      return game.length.toString()+"场";
    }else{
      List s = game["data"];
      List s1 = [];
      s.forEach((element) {
        List s2 = element["bet_content"];
        s2.forEach((element1) {
          s1.add(element1["id"]);
        });
      });
      var dedu = new Set();
      dedu.addAll(s1);
      s1 = dedu.toList();
      return s1.length.toString()+"场";
    }
  }
  List<Container> getOptList(){
    List ls = game["data"];
   return ls.asMap().keys.map((e) {
     List lst = ls[e]["bet_content"];
     return Container(

       alignment: Alignment.center,
       decoration: BoxDecoration(border:Border(top: BorderSide(width: 0.1),right: BorderSide(width: 0.1),left: BorderSide(width: 0.1),bottom:BorderSide(width: 0.1))),

       child: Row(

         crossAxisAlignment: CrossAxisAlignment.center,

         children: <Widget>[

           Container(

             alignment: Alignment.center,
             width: ScreenUtil().setWidth(60),
             child: lst.length==1?Text("单关"):Text(lst.length.toString()+"串1"),
           ),

           Container(
             decoration: BoxDecoration(border:Border(left: BorderSide(width: 0.1))),
             child: Row(
               children: <Widget>[
                 Container(
                   decoration: BoxDecoration(border:Border(right: BorderSide(width: 0.1))),
                   alignment: Alignment.center,
                   width: ScreenUtil().setWidth(60),
                   child: Text(ls[e]["num"].toString()+"注"),
                 ),
                 Column(
                   children: lst.asMap().keys.map((e1){
                     return Row(
                       children: <Widget>[
                         Container(
                           decoration: BoxDecoration(border:Border(right: BorderSide(width: 0.1),left: BorderSide(width: 0.1),bottom: BorderSide(width: 0.1))),
                           alignment: Alignment.center,
                           width: ScreenUtil().setWidth(60),
                           child: Text(lst[e1]["name"].toString()),
                         ),
                         Container(
                           decoration: BoxDecoration(border:Border(right: BorderSide(width: 0.1),left: BorderSide(width: 0.1),bottom: BorderSide(width: 0.1))),
                           alignment: Alignment.center,
                           width: ScreenUtil().setWidth(150),
                           child: Text(lst[e1]["h_name"].toString()+"("+lst[e1]["value"].toString()+")"),
                         ),
                         Container(
                           decoration: BoxDecoration(border:Border(right: BorderSide(width: 0.1),left: BorderSide(width: 0.1),bottom: BorderSide(width: 0.1))),
                           alignment: Alignment.center,
                           width: ScreenUtil().setWidth(79),
                           child: Text(lst[e1]["caiguo"].toString(),style: TextStyle(color: lst[e1]["ret"]==0?Colors.black:Colors.red),),
                         )
                       ],
                     );
                   }).toList(),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }).toList();

    return [];
  }
 List getList(){
    String keys;
    String week ;
    String order_no ;
    String h_name ;
    String a_name ;
    String bifen ;
    int num;
    return game.keys.map((e){
      Map s = game[e];
      num = 0;
      s.forEach((key, value) {
         week = s[key][0]["time"].toString().substring(0,1);
         order_no = s[key][0]["time"].toString().substring(1,4);
         h_name = s[key][0]["h_name"].toString();
         a_name = s[key][0]["a_name"].toString();
         bifen = s[key][0]["bifen"].toString();
         List z = s[key];

         z.forEach((element) {
           num++;
         });

      });
  int height = num*75;

    return  Container(


      decoration: BoxDecoration(border:Border(top: BorderSide(width: 0.1),right: BorderSide(width: 0.1),left: BorderSide(width: 0.1),bottom:BorderSide(width: 0.1))),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[

              Container(
                height: ScreenUtil().setHeight(height),

                alignment: Alignment.center,
                width: ScreenUtil().setWidth(60),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("周"+num_to_cn[week]),
                    Text(order_no),
                  ],
                ),
              ),


          Container(
            height: ScreenUtil().setHeight(height),

            decoration: BoxDecoration(border:Border(left: BorderSide(width: 0.1))),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(95),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Text(order["type"]=="f"?h_name:a_name,style: TextStyle(fontSize: ScreenUtil().setSp(13),height: 1.2),),
                Text(bifen,style: TextStyle(fontSize: ScreenUtil().setSp(13),height: 1.2)),
                Text(order["type"]=="f"?a_name:h_name,style: TextStyle(fontSize: ScreenUtil().setSp(13),height: 1.2)),
              ],
            ),
          ),
          Container(


            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getRow(s,height),
            ),
          ),


        ],
      ),
    );
    }).toList();
  }
 List<Widget> getRow(Map s,int heights){
     String p_goal;
     String rf = "-500";
     bool is_right = false;

     return s.keys.map((e){
       List ls = s[e];

       ls.forEach((element) {
         if(element["ret"] == 1){
          s[e][0]["is_right"] = true;
         }
       });
       p_goal = ls[0]["p_goal"];

       List pg = p_goal.toString().split(",");
       List meth_id = ls[0]["method_id"].toString().split("-");


       if(order["type"] == "f"){
         if(meth_id[0] == "2"){
           if(pg.length == 1){
              rf = pg[0];
           }else{
             rf = pg[1];

           }
         }else{
           rf = "-500";
         }
       }else{
         if(meth_id[0] == "2"){
           rf = pg[1];
         }else if(meth_id[0] == "5"){
           rf = pg[3];
         }else{
           rf = "-500";
         }
       }

      return Container(
        decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 0.1),left: BorderSide(width: 0.1))),
        child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(


              alignment: Alignment.center,
              width: ScreenUtil().setWidth(75),
              child: Column(
                children: <Widget>[
                  Text(e.toString()),
                  rf!="-500"?Text("("+ rf + ")"):Container()
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(95),

              alignment: Alignment.center,
              child: Column(

                children: ls.asMap().keys.map((e2){

                  return Container(
                    decoration: BoxDecoration(border:Border(right: BorderSide(width: 0.1),left: BorderSide(width: 0.1))),
                    height: ScreenUtil().setHeight(75),
                    alignment: Alignment.center,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(ls[e2]["bet_value"].toString()),
                        Text(ls[e2]["pl"].toString()),

                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(84),
              child: Text(ls[0]["caiguo"].toString(),style: TextStyle(color: s[e][0]["is_right"]==true?Colors.red:Colors.grey),),
            ),

          ],
        ),
      );
     }).toList();
  }
  getOrderDetail() async {
    ResultData res = await HttpManager.getInstance().get("getOrderDetail",params: {"id":widget.id},withLoading: false);

    setState(() {
      if(res.data["detail"].length>0){
        game = res.data["detail"];
      }else{
        game = {};
      }

      order = res.data["order"];
    });

  }
}