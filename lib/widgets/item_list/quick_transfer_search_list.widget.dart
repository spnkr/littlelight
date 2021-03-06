import 'package:bungie_api/enums/bucket_scope_enum.dart';
import 'package:bungie_api/enums/destiny_class_enum.dart';
import 'package:flutter/material.dart';
import 'package:little_light/utils/item_with_owner.dart';
import 'package:little_light/widgets/item_list/items/quicktransfer_search_item_wrapper.widget.dart';
import 'package:little_light/widgets/item_list/search_list.widget.dart';
import 'package:little_light/widgets/search/search_filters.widget.dart';

class QuickTransferSearchListWidget extends SearchListWidget {
  final String searchText;
  final int bucketType;
  final int classType;
  final String characterId;
  final int scope;

  QuickTransferSearchListWidget(
      {Key key,
      this.searchText,
      this.bucketType,
      this.classType,
      this.characterId,
      this.scope})
      : super(key: key);

  @override
  QuickTransferSearchListWidgetState createState() =>
      QuickTransferSearchListWidgetState();
}

class QuickTransferSearchListWidgetState
    extends SearchListWidgetState<QuickTransferSearchListWidget> {
  @override
  String get search => widget.searchText;

  @override
  FilterItem get powerLevelFilter => null;

  @override
  FilterItem get damageTypeFilter => null;

  @override
  FilterItem get tierTypeFilter => null;

  @override
  FilterItem get bucketTypeFilter =>
      FilterItem([widget.bucketType], [widget.bucketType]);

  @override
  FilterItem get subtypeFilter => null;

  @override
  FilterItem get typeFilter => null;

  @override
  FilterItem get ammoTypeFilter => null;

  @override
  FilterItem get classTypeFilter => widget.classType != null
      ? FilterItem([widget.classType, DestinyClass.Unknown],
          [widget.classType, DestinyClass.Unknown])
      : null;

  @override
  List<int> get itemTypes => null;

  @override
  List<int> get excludeItemTypes => null;

  @override
  bool get includeUninstanced => widget.scope == BucketScope.Account;

  @override
  List<ItemWithOwner> get filteredItems {
    print(widget.scope);
    var items = super.filteredItems;
    if (widget.characterId != null) {
      items = items.where((i) => i.ownerId != widget.characterId).toList();
    }
    if(widget.scope == BucketScope.Account){
      items = items.where((i) => i.item.bucketHash != widget.bucketType).toList();
    }
    
    return items;
  }

  @override
  Widget getItem(BuildContext context, int index, _items) {
    if (_items == null) return null;
    if (index > _items.length - 1) return null;
    var item = _items[index];
    if (itemDefinitions == null || itemDefinitions[item.item.itemHash] == null)
      return Container();
    return QuickTransferSearchItemWrapper(item.item,
        itemDefinitions[item.item.itemHash]?.inventory?.bucketTypeHash,
        characterId: item.ownerId,
        key: Key("item_${item.item.itemInstanceId}_${item.item.itemHash}"));
  }
}
