# evreka app

This is the repository of **evreka** mobile app.


## Some handy commands

### Generate all `xxx.g.dart` files:

```shell
derry build
```

The `build` script resides in the `derry.yaml` file. See https://pub.dev/packages/derry to learn more about _derry_ (script manager).


### Generate only `localization.g.dart` file:

```shell
derry run localization
```

The `localization` script resides in the `derry.yaml` file.


### Generate launcher icons:

```shell
derry run icons
```

The `icons` script resides in the `derry.yaml` file. The configuration resides in the `flutter_launcher_icons.yaml` file. See https://pub.dev/packages/flutter_launcher_icons to learn more about the generator.


### Run `flutter pub get` for all modules:

```shell
derry run pubget
```


### Run `flutter pub upgrade` for all modules:

```shell
derry run pubgrade
```
