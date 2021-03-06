import 'package:bungie_api/models/destiny_presentation_node_definition.dart';
import 'package:flutter/material.dart';

import 'package:little_light/services/manifest/manifest.service.dart';
import 'package:little_light/services/profile/profile.service.dart';

import 'package:little_light/widgets/presentation_nodes/presentation_node_list.widget.dart';
import 'package:little_light/widgets/presentation_nodes/presentation_node_tabs.widget.dart';

class PresentationNodeBodyWidget extends StatefulWidget {
  final ManifestService manifest = new ManifestService();
  final ProfileService profile = new ProfileService();
  final PresentationNodeItemBuilder itemBuilder;
  final PresentationNodeTileBuilder tileBuilder;
  final int presentationNodeHash;
  final int depth;
  PresentationNodeBodyWidget(
      {this.presentationNodeHash,
      this.itemBuilder,
      this.tileBuilder,
      this.depth = 0});

  @override
  PresentationNodeBodyWidgetState createState() =>
      new PresentationNodeBodyWidgetState();
}

class PresentationNodeBodyWidgetState<T extends PresentationNodeBodyWidget>
    extends State<PresentationNodeBodyWidget> {
  DestinyPresentationNodeDefinition definition;
  @override
  void initState() {
    super.initState();
    if (definition == null && widget.presentationNodeHash != null) {
      loadDefinition();
    }
  }

  loadDefinition() async {
    definition = await widget.manifest
        .getDefinition<DestinyPresentationNodeDefinition>(
            widget.presentationNodeHash);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(definition?.children == null) return Container();
    if((definition?.children?.presentationNodes?.length ?? 0) == 0){
      return listBuilder();
    }
    if((definition?.children?.presentationNodes?.length ?? 0) > 3){
      return listBuilder();
    }
    return tabBuilder();
  }

  Widget tabBuilder() {
    return PresentationNodeTabsWidget(
      presentationNodeHash: widget.presentationNodeHash,
      depth: widget.depth,
      itemBuilder:widget.itemBuilder,
      tileBuilder:widget.tileBuilder,
    );
  }

  Widget listBuilder() {
    return PresentationNodeListWidget(
      presentationNodeHash: widget.presentationNodeHash,
      depth: widget.depth,
      itemBuilder: widget.itemBuilder,
      tileBuilder: widget.tileBuilder,
    );
  }
}
