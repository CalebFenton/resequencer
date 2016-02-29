# resequencer

Resequencer is a configurable, flexible, regex-based APK modification tool. It can be used for adding instrumentation or whatever you'd need to automatically modify APKs for. Also, new code (hooks) can be injected and intelligently added.

## Building & Running

Build the jar with `./gradlew fatjar`

You'll also need `zipalign` and `aapt` which can't be included since they're part of the [Android SDK](http://developer.android.com/sdk/index.html#Other). If you already have them on your path, and you probably do if you're cool, and you're cool, right? If so, drop them into the current directory with:
```bash
cp `which zipalign` .
cp `which aapt` .
```

Now you just have to make sense of this impressive usage menu:
```
 java -jar build/libs/resequencer.jar -h
-----------------------------------------------------
 Resequencer 1.1 - Feb 28th, 2016
-----------------------------------------------------


Usage: java -jar resequencer-1.1.0.jar [options] <Apktool/Baksmali dump | Apk file> [Output Apk]
General Options:
  -f, --force       Allow overwriting of any existent file
  -s, --skip-assembly   Decompile and modify but do not rebuild
  -d, --detect-only Detect protection information only
  --sign-only       Sign Apk file then exit
  --info-only       Get App info then exit
  --assemble-only   Assemble dump, update Output Apk, sign, zipalign, exit
  --skip-cleanup    Do not delete dump directory after running
  --skip-protect    Do not protect with anti-dissassembly methods
  --decode-res      Decode XML resources and use them for Smali hints
  --sign-key        PK8 key to sign with (requires --sign-cert)
  --sign-cert       PEM certificate to sign with (reqires --sign-key)
  --sign-pass       Password to use with signature
  --fplist      List installed fingerprints
  --fpexclude       Comma-separated list of fingerprints to exclude
  --fpinclude       Comma-separated list of fingerprints to include
  --trace       Trace all method calls in the logs (noisy!)
  --dbghooks        Use unobfuscated debugging hooks
  -v#, --verbose#   Verbose level (1-3)
  -h, --help        Show this friendly message

Hint Options:
  --skip-hints      Skip Smali hinting

Hook Options:
  --chksigs #       Check signatures behavior
    0 - *default* only match signatures if installed
    1 - always return signature match
  --getpi #     Get PackageInfo behavior
    0 - *default* spoof key/pro/full Apps if not installed
    1 - do not spoof apps not installed
  --sigvfy #        Signature.verify() behavior
    0 - *default* always return true
    1 - return actual result of verify
  --spoof-id # [15 digit device ID]
    Fake the Android / Device ID
    0 - *default* no spoofing, 1 - always random, 2 - session random
    3 - session permute, 4 - emulator (all 0s), 5 - user defined
  --spoof-model <model>
    Fake device model with given string, eg "Galaxy Nexus".
  --spoof-manufacturer <manufacturer>
    Fake device manufacturer with given string, eg "Samsung".
  --spoof-account # [account name]
    Fake the accout name checks (usually Google account)
    0 - *default* no spoofing, 1 - always random
    2 - session random, 3 - user defined
  --spoof-network <string>
    Fake the network operator name, eg. t-mobile, sprint, nextel
  --spoof-btmac # [MAC eg. 11:22:33:AA:BB:CC]
    Fake bluetooth MAC address
    0 - *default* no spoofing, 1 - always random
    2 - session random, 3 - user defined
  --spoof-wifimac # [MAC eg. 11:22:33:AA:BB:CC]
    Fake WiFi MAC address
    0 - *default* no spoofing, 1 - always random
    2 - session random, 3 - user defined
  --key-apk <key apk path> Collect fidelity information for key apk
```

## How it Works

Honestly I wrote this _years_ ago in another life time and it seems to work by magic. Looking back over the code, I see that most of the cool stuff happens due to [fingerprint definitions](src/main/resources/fingerprints). If you wanted to understand more, I'd start by looking there.

This thing is designed to be able to make _any_ change I could imagine to an APK, and I could imagine all kinds of crazy shit back then. If you can't get it working, feel free to make an issue.

## What is that apktool.jar in libs/ ?

There's no Maven lib for Apktool, at least one not up-to-date. Just took a copy of apktool and did this so stuff would compile:
```bash
zip -d apktool.jar "org/jf/baksmali/**"
zip -d apktool.jar "org/jf/smali/**"
zip -d apktool.jar "org/apache/commons/**"
```
