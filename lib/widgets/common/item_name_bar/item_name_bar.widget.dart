import 'package:bungie_api/enums/item_state_enum.dart';
import 'package:bungie_api/enums/tier_type_enum.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:bungie_api/models/destiny_item_instance_component.dart';
import 'package:flutter/material.dart';
import 'package:little_light/utils/destiny_data.dart';
import 'package:little_light/widgets/common/base/base_destiny_stateless_item.widget.dart';

class ItemNameBarWidget extends BaseDestinyStatelessItemWidget {
  final double fontSize;
  final EdgeInsets padding;
  final bool multiline;
  final FontWeight fontWeight;
  final Widget trailing;
  ItemNameBarWidget(
    DestinyItemComponent item,
    DestinyInventoryItemDefinition definition,
    DestinyItemInstanceComponent instanceInfo, {
    Key key,
    String characterId,
    this.fontSize = 14,
    this.padding = const EdgeInsets.all(8),
    this.multiline = false,
    this.fontWeight = FontWeight.bold,
    this.trailing,
  }) : super(item:item, definition:definition, instanceInfo:instanceInfo,
            key: key, characterId: characterId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      height: fontSize + padding.top * 2,
      alignment: Alignment.centerLeft,
      decoration: nameBarBoxDecoration(),
      child:
          Material(color: Colors.transparent, child: nameBarContent(context)),
    );
  }

  BoxDecoration nameBarBoxDecoration() {
    int state = item?.state ?? 0;
    if (state & ItemState.Masterwork != ItemState.Masterwork) {
      return BoxDecoration(
          color: DestinyData.getTierColor(definition.inventory.tierType));
    }
    return BoxDecoration(
        color: DestinyData.getTierColor(definition.inventory.tierType),
        image: DecorationImage(
            repeat: ImageRepeat.repeatX,
            alignment: Alignment.topCenter,
            image: getMasterWorkTopOverlay()));
  }

  ExactAssetImage getMasterWorkTopOverlay() {
    if (definition.inventory.tierType == TierType.Exotic) {
      return ExactAssetImage("assets/imgs/masterwork-top-exotic.png");
    }
    return ExactAssetImage("assets/imgs/masterwork-top.png");
  }

  Widget nameBarContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: nameBarTextField(context),
        ),
        trailing ?? Container()
      ],
    );
  }

  Widget nameBarTextField(BuildContext context) {
    return Text(definition.displayProperties.name.toUpperCase(),
        overflow: TextOverflow.fade,
        maxLines: multiline ? 2 : 1,
        softWrap: multiline,
        style: TextStyle(
          fontSize: fontSize,
          color: DestinyData.getTierTextColor(definition.inventory.tierType),
          fontWeight: fontWeight,
        ));
  }
}
