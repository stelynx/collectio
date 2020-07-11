import 'package:flutter/material.dart';

import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';

class CollectioDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback primaryAction;

  const CollectioDeleteDialog({
    @required this.title,
    @required this.content,
    @required this.primaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return _CollectioDialog(
      title: title,
      content: content,
      actions: [
        _CollectioDialogAction(
          text: Translation.cancel,
          onTap: () => Navigator.of(context).pop(false),
        ),
        _CollectioDialogAction(
          text: Translation.delete,
          onTap: () {
            primaryAction();
            Navigator.of(context).pop(true);
          },
          isDanger: true,
        ),
      ],
    );
  }
}

class CollectioInfoDialog extends StatelessWidget {
  final String title;
  final String content;

  const CollectioInfoDialog({
    @required this.title,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return _CollectioDialog(
      title: title,
      content: content,
    );
  }
}

class _CollectioDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<_CollectioDialogAction> actions;

  const _CollectioDialog({
    @required this.title,
    @required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: Padding(
          padding: CollectioStyle.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).dialogTheme.titleTextStyle,
                textAlign: TextAlign.center,
              ),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              Text(
                content,
                style: Theme.of(context).dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
              if (actions != null) ...[
                CollectioStyle.itemSplitter,
                Divider(),
                CollectioStyle.itemSplitter,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectioDialogAction extends StatelessWidget {
  final Translation text;
  final VoidCallback onTap;
  final bool isDanger;

  _CollectioDialogAction({
    @required this.text,
    @required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        AppLocalizations.of(context).translate(text),
        textAlign: TextAlign.center,
        style: isDanger
            ? TextStyle(
                color: Theme.of(context).errorColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )
            : TextStyle(fontSize: 16),
      ),
    );
  }
}
