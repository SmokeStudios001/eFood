import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_loader_widget.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';


class PaginatedListWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  const PaginatedListWidget({
    super.key, required this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.itemView, this.enabledPagination = true, this.reverse = false, this.limit = 10,
  });

  @override
  State<PaginatedListWidget> createState() => _PaginatedListWidgetState();
}

class _PaginatedListWidgetState extends State<PaginatedListWidget> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent
          && widget.totalSize != null && !_isLoading && widget.enabledPagination) {
        if(mounted) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();

    if (_offset! < pageSize && !_offsetList.contains(_offset!+1)) {

      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [

      widget.reverse ? const SizedBox() : widget.itemView,

      Center(child: Padding(
        padding: (_isLoading) ?  const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        child: _isLoading ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : const SizedBox(),
      )),

      widget.reverse ? widget.itemView : const SizedBox(),

    ]);
  }
}
