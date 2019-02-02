library flutter_collapsible_toolbar;

import 'package:flutter/material.dart';
import 'package:carousel_hero/carousel_hero.dart';

class CollapsibleToolbar extends StatefulWidget {
  final double statusBarHeight;
  final double screenWidth;
  final String appBarLabel;
  final boxFit;
  final List<Widget> listWidgets;
  final List<Map> carouselImages;

  CollapsibleToolbar({
    Key key,
    @required this.statusBarHeight,
    @required this.screenWidth,
    @required this.listWidgets,
    @required this.carouselImages,
    @required this.appBarLabel,
	  this.boxFit
  }) : super(key: key);

  @override
  _CollapsibleToolbarState createState() => _CollapsibleToolbarState();
}

double expandedHeight = 250.0;

class _CollapsibleToolbarState extends State<CollapsibleToolbar> {
  double opacity = 0.0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: expandedHeight,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: opacity,
                        child: Container(
                          margin: EdgeInsets.only(left: 55.0, right: 10.0),
                          child: Text(
                            widget.appBarLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0
                            ),
                          ),
                        ),
                      ),
                      background: SizedBox(
                        height: expandedHeight,
                        width: widget.screenWidth,
                        child: Carousel(
                          dotBgColor: Colors.transparent,
                          images: widget.carouselImages,
	                        boxFit: widget.boxFit,
                        )
                      ),
                    );
                  })),
              SliverList(
                delegate: SliverChildListDelegate(widget.listWidgets),
              ),
            ],
          ),
          _buildFab(),
        ],
      )
    );
  }

  Widget _buildFab() {
    //starting fab position 250 - 10 = 240 = 270.0 - 30
    //starting fab position 250 + 14 = 264 = 294.0 - 30
    final double defaultTopMargin = expandedHeight + widget.statusBarHeight;
    //pixels from top where scaling should start
    final double scaleStart = 76.0 + widget.statusBarHeight;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double topMargin = defaultTopMargin;
    double scale = 1.0;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      topMargin -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        setState(() => opacity = 0.0);
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        setState(() => opacity = 1.0);
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: topMargin - 30,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          onPressed: () => {},
          child: Icon(Icons.share),
        ),
      ),
    );
  }
}