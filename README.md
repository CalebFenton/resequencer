resequencer
===========

Configurable, flexible regex-based APK modification tool.

need aapt and zipalign from android sdk
if already on path, easy
```bash
cp `which zipalign` .
cp `which aapt` .
```

no lib for apktool so had to monkey one up manually
zip -d apktool.jar "org/jf/baksmali/**"
zip -d apktool.jar "org/jf/smali/**"
zip -d apktool.jar "org/apache/commons/**"
