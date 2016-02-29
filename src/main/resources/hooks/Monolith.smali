.class public Lhooks/Monolith;
.super Ljava/lang/Object;
.source "Monolith.java"


# annotations
.annotation build Landroid/annotation/TargetApi;
    value = 0x5
.end annotation


# static fields
.field private static final AccountNameSpoof:Ljava/lang/String; = "%!AccountNameSpoof%"

.field private static final AccountNameSpoofType:I

.field public static AppContext:Landroid/content/Context; = null

.field private static final BTMacSpoof:Ljava/lang/String; = "%!BTMacSpoof%"

.field private static final BTMacSpoofType:I

.field protected static BuildingDigest:Z = false

.field private static CHKSUM_ADLER32_App:Ljava/lang/Long; = null

.field private static CHKSUM_ADLER32_DEX:Ljava/lang/Long; = null

.field private static CHKSUM_CRC32_App:Ljava/lang/Long; = null

.field private static CHKSUM_CRC32_DEX:Ljava/lang/Long; = null

.field private static CHKSUM_MD5_App:[B = null

.field private static CHKSUM_MD5_DEX:[B = null

.field private static CHKSUM_SHA1_App:[B = null

.field private static CHKSUM_SHA1_DEX:[B = null

.field protected static final DEBUG:Z = true

.field protected static final DUMP_STACK:I = 0x2

.field private static final DeviceIDSpoof:Ljava/lang/String; = "%!DeviceIDSpoof%"

.field private static final DeviceIDSpoofType:I

.field private static LastReadInputStream:Ljava/io/InputStream; = null

.field protected static MethodTraceFOS:Ljava/io/FileOutputStream; = null

.field protected static final MyAppName:Ljava/lang/String; = "%!AppPackage%"

.field protected static final MyAppVersionCode:Ljava/lang/String; = "%!AppVersionCode%"

.field protected static final MyAppVersionName:Ljava/lang/String; = "%!AppVersionName%"

.field private static final MyCheckSigsBehavior:I

.field private static MyChecksumInputStreams:Ljava/util/HashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/io/InputStream;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final MyGetPIBehavior:I

.field protected static final MyPrefsFile:Ljava/lang/String; = "%!RndAlpha%"

.field private static final MySigVerifyBehavior:I

.field private static MyWatchedChecksumsOrDigests:Ljava/util/HashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static MyWatchedProcess:Ljava/lang/Process; = null

.field private static final NetworkOperatorSpoof:Ljava/lang/String; = "%!NetworkOperatorSpoof%"

.field private static final WifiMacSpoof:Ljava/lang/String; = "%!WifiMacSpoof%"

.field private static final WifiMacSpoofType:I


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .prologue
    const/4 v2, 0x0

    .line 70
    sput-object v2, Lhooks/Monolith;->MethodTraceFOS:Ljava/io/FileOutputStream;

    .line 72
    sput-object v2, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    .line 86
    const-string v0, "%!CheckSigsBehavior%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->MyCheckSigsBehavior:I

    .line 92
    const-string v0, "%!GetPIBehavior%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->MyGetPIBehavior:I

    .line 98
    const-string v0, "%!SigVerifyBehavior%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->MySigVerifyBehavior:I

    .line 105
    sput-object v2, Lhooks/Monolith;->MyWatchedProcess:Ljava/lang/Process;

    .line 108
    const-string v0, "%!ChksumCRC32App%"

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    sput-object v0, Lhooks/Monolith;->CHKSUM_CRC32_App:Ljava/lang/Long;

    .line 109
    const-string v0, "%!ChksumAdler32App%"

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    sput-object v0, Lhooks/Monolith;->CHKSUM_ADLER32_App:Ljava/lang/Long;

    .line 111
    const-string v0, "%!ChksumCRC32DEX%"

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    sput-object v0, Lhooks/Monolith;->CHKSUM_CRC32_DEX:Ljava/lang/Long;

    .line 112
    const-string v0, "%!ChksumAdler32DEX%"

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    sput-object v0, Lhooks/Monolith;->CHKSUM_ADLER32_DEX:Ljava/lang/Long;

    .line 120
    sput-object v2, Lhooks/Monolith;->CHKSUM_MD5_App:[B

    .line 121
    sput-object v2, Lhooks/Monolith;->CHKSUM_SHA1_App:[B

    .line 122
    sput-object v2, Lhooks/Monolith;->CHKSUM_MD5_DEX:[B

    .line 123
    sput-object v2, Lhooks/Monolith;->CHKSUM_SHA1_DEX:[B

    .line 130
    const/4 v0, 0x0

    sput-boolean v0, Lhooks/Monolith;->BuildingDigest:Z

    .line 136
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    .line 137
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lhooks/Monolith;->MyChecksumInputStreams:Ljava/util/HashMap;

    .line 138
    sput-object v2, Lhooks/Monolith;->LastReadInputStream:Ljava/io/InputStream;

    .line 148
    const-string v0, "%!DeviceIDSpoofType%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->DeviceIDSpoofType:I

    .line 157
    const-string v0, "%!AccountNameSpoofType%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->AccountNameSpoofType:I

    .line 169
    const-string v0, "%!WifiMacSpoofType%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->WifiMacSpoofType:I

    .line 178
    const-string v0, "%!BTMacSpoofType%"

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lhooks/Monolith;->BTMacSpoofType:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 66
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static checkSignatures(Landroid/content/pm/PackageManager;II)I
    .locals 5
    .param p0, "pm"    # Landroid/content/pm/PackageManager;
    .param p1, "uid1"    # I
    .param p2, "uid2"    # I

    .prologue
    const/4 v4, 0x0

    .line 254
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "checkSignatures("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "), calling string version"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 256
    invoke-virtual {p0, p1}, Landroid/content/pm/PackageManager;->getPackagesForUid(I)[Ljava/lang/String;

    move-result-object v2

    aget-object v0, v2, v4

    .line 257
    .local v0, "pkg1":Ljava/lang/String;
    invoke-virtual {p0, p2}, Landroid/content/pm/PackageManager;->getPackagesForUid(I)[Ljava/lang/String;

    move-result-object v2

    aget-object v1, v2, v4

    .line 258
    .local v1, "pkg2":Ljava/lang/String;
    invoke-static {p0, v0, v1}, Lhooks/Monolith;->checkSignatures(Landroid/content/pm/PackageManager;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    return v2
.end method

.method public static checkSignatures(Landroid/content/pm/PackageManager;Ljava/lang/String;Ljava/lang/String;)I
    .locals 4
    .param p0, "pm"    # Landroid/content/pm/PackageManager;
    .param p1, "pkg1"    # Ljava/lang/String;
    .param p2, "pkg2"    # Ljava/lang/String;

    .prologue
    .line 227
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "checkSignatures("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 228
    invoke-virtual {p0, p1, p2}, Landroid/content/pm/PackageManager;->checkSignatures(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    .line 229
    .local v0, "result":I
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "  real result = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 231
    if-nez v0, :cond_0

    move v1, v0

    .line 250
    .end local v0    # "result":I
    .local v1, "result":I
    :goto_0
    return v1

    .line 233
    .end local v1    # "result":I
    .restart local v0    # "result":I
    :cond_0
    sget v2, Lhooks/Monolith;->MyCheckSigsBehavior:I

    if-nez v2, :cond_2

    .line 234
    const-string v2, "%!AppPackage%"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 235
    const/4 v0, 0x0

    .line 249
    :cond_1
    :goto_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "  returning: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    move v1, v0

    .line 250
    .end local v0    # "result":I
    .restart local v1    # "result":I
    goto :goto_0

    .line 238
    .end local v1    # "result":I
    .restart local v0    # "result":I
    :cond_2
    sget v2, Lhooks/Monolith;->MyCheckSigsBehavior:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_3

    .line 240
    const/4 v2, -0x4

    if-eq v0, v2, :cond_1

    if-eqz v0, :cond_1

    .line 242
    const/4 v0, 0x0

    goto :goto_1

    .line 245
    :cond_3
    sget v2, Lhooks/Monolith;->MyCheckSigsBehavior:I

    const/4 v3, 0x2

    if-ne v2, v3, :cond_1

    .line 246
    const/4 v0, 0x0

    goto :goto_1
.end method

.method public static contextOpenFileInput(Landroid/content/Context;Ljava/lang/String;)Ljava/io/FileInputStream;
    .locals 1
    .param p0, "c"    # Landroid/content/Context;
    .param p1, "s"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/FileNotFoundException;
        }
    .end annotation

    .prologue
    .line 900
    invoke-virtual {p0, p1}, Landroid/content/Context;->openFileInput(Ljava/lang/String;)Ljava/io/FileInputStream;

    move-result-object v0

    .line 901
    .local v0, "fis":Ljava/io/FileInputStream;
    invoke-static {v0, p1}, Lhooks/Monolith;->watchInputStream(Ljava/lang/Object;Ljava/lang/String;)V

    .line 902
    return-object v0
.end method

.method private static fixSysCmd(Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p0, "cmd"    # Ljava/lang/String;

    .prologue
    const/4 v4, 0x1

    .line 1036
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "fixSysCmd("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 1038
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    const-string v3, " "

    invoke-virtual {v2, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 1039
    .local v0, "args":[Ljava/lang/String;
    move-object v1, p0

    .line 1041
    .local v1, "newCmd":Ljava/lang/String;
    array-length v2, v0

    const/4 v3, 0x2

    if-lt v2, v3, :cond_0

    .line 1042
    const/4 v2, 0x0

    aget-object v2, v0, v2

    const-string v3, "md5sum"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1044
    aget-object v2, v0, v4

    const-string v3, ".apk"

    invoke-virtual {v2, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1045
    const-string v1, "echo "

    .line 1046
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "%!MD5Sum%\t"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    aget-object v3, v0, v4

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1051
    :cond_0
    return-object v1
.end method

.method private static generateRandomDeviceID()Ljava/lang/String;
    .locals 2

    .prologue
    .line 1100
    const-string v0, "0123456789"

    const/16 v1, 0xf

    invoke-static {v0, v1}, Lhooks/Monolith;->generateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static generateRandomMac()Ljava/lang/String;
    .locals 5

    .prologue
    .line 1106
    const-string v1, ""

    .line 1107
    .local v1, "mac":Ljava/lang/String;
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    const/4 v2, 0x6

    if-ge v0, v2, :cond_0

    .line 1108
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "0123456789ABCDEF"

    const/4 v4, 0x2

    invoke-static {v3, v4}, Lhooks/Monolith;->generateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ":"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1107
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1110
    :cond_0
    const/4 v2, 0x0

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    add-int/lit8 v3, v3, -0x1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method protected static generateString(I)Ljava/lang/String;
    .locals 1
    .param p0, "length"    # I

    .prologue
    .line 1164
    const-string v0, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()_+-=[]{}\\|;\':\",./<>?~`"

    invoke-static {v0, p0}, Lhooks/Monolith;->generateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method protected static generateString(Ljava/lang/String;I)Ljava/lang/String;
    .locals 4
    .param p0, "charSet"    # Ljava/lang/String;
    .param p1, "length"    # I

    .prologue
    .line 1170
    new-instance v1, Ljava/util/Random;

    invoke-direct {v1}, Ljava/util/Random;-><init>()V

    .line 1171
    .local v1, "rng":Ljava/util/Random;
    new-array v2, p1, [C

    .line 1172
    .local v2, "text":[C
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    if-ge v0, p1, :cond_0

    .line 1173
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/util/Random;->nextInt(I)I

    move-result v3

    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v3

    aput-char v3, v2, v0

    .line 1172
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1176
    :cond_0
    new-instance v3, Ljava/lang/String;

    invoke-direct {v3, v2}, Ljava/lang/String;-><init>([C)V

    return-object v3
.end method

.method public static getAccountName(Landroid/accounts/Account;)Ljava/lang/String;
    .locals 9
    .param p0, "act"    # Landroid/accounts/Account;

    .prologue
    const/16 v8, 0xa

    .line 671
    const-string v3, "jrhacker"

    .line 672
    .local v3, "spoofActName":Ljava/lang/String;
    iget-object v1, p0, Landroid/accounts/Account;->name:Ljava/lang/String;

    .line 675
    .local v1, "realActName":Ljava/lang/String;
    const/4 v2, 0x0

    .line 676
    .local v2, "settings":Landroid/content/SharedPreferences;
    const-string v4, ""

    .line 677
    .local v4, "storedID":Ljava/lang/String;
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_1

    .line 678
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v6, "%!RndAlpha%"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 680
    const-string v5, "act_nm"

    const-string v6, ""

    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 686
    :goto_0
    sget v5, Lhooks/Monolith;->AccountNameSpoofType:I

    packed-switch v5, :pswitch_data_0

    .line 718
    :cond_0
    :goto_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getAccountName("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget v6, Lhooks/Monolith;->AccountNameSpoofType:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ") - using: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  real: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 721
    return-object v3

    .line 683
    :cond_1
    const-string v5, "getAccountName() has no context. can\'t use session storage. using fallback if necessary."

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 688
    :pswitch_0
    move-object v3, v1

    .line 689
    goto :goto_1

    .line 691
    :pswitch_1
    const-string v5, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890."

    invoke-static {v5, v8}, Lhooks/Monolith;->generateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 694
    goto :goto_1

    .line 696
    :pswitch_2
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_0

    .line 697
    const-string v5, ""

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_2

    .line 699
    move-object v3, v4

    goto :goto_1

    .line 702
    :cond_2
    const-string v5, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890."

    invoke-static {v5, v8}, Lhooks/Monolith;->generateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 706
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 707
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    const-string v5, "act_nm"

    invoke-interface {v0, v5, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 708
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    goto :goto_1

    .line 714
    .end local v0    # "editor":Landroid/content/SharedPreferences$Editor;
    :pswitch_3
    const-string v3, "%!AccountNameSpoof%"

    goto :goto_1

    .line 686
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
    .end packed-switch
.end method

.method public static getApplicationEnabledSetting(Landroid/content/pm/PackageManager;Ljava/lang/String;)I
    .locals 4
    .param p0, "pm"    # Landroid/content/pm/PackageManager;
    .param p1, "packageName"    # Ljava/lang/String;

    .prologue
    .line 286
    :try_start_0
    invoke-virtual {p0, p1}, Landroid/content/pm/PackageManager;->getApplicationEnabledSetting(Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 293
    .local v1, "result":I
    :goto_0
    const/4 v2, 0x2

    if-ne v1, v2, :cond_0

    .line 294
    const/4 v1, 0x0

    .line 297
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getApplicationEnabledSetting("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ") = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 298
    return v1

    .line 288
    .end local v1    # "result":I
    :catch_0
    move-exception v0

    .line 289
    .local v0, "ex":Ljava/lang/IllegalArgumentException;
    const/4 v1, 0x0

    .restart local v1    # "result":I
    goto :goto_0
.end method

.method public static getApplicationInfo(Landroid/content/Context;)Landroid/content/pm/ApplicationInfo;
    .locals 3
    .param p0, "c"    # Landroid/content/Context;
    .annotation build Landroid/annotation/TargetApi;
        value = 0x4
    .end annotation

    .prologue
    .line 303
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    .line 304
    .local v0, "ai":Landroid/content/pm/ApplicationInfo;
    const/4 v1, 0x2

    .line 305
    .local v1, "flag":I
    iget v2, v0, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/2addr v2, v1

    if-ne v2, v1, :cond_0

    .line 306
    const-string v2, "application is debuggable, lying and saying it isn\'t"

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 309
    iget v2, v0, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit8 v2, v2, -0x3

    iput v2, v0, Landroid/content/pm/ApplicationInfo;->flags:I

    .line 312
    :cond_0
    return-object v0
.end method

.method public static getBTMac(Landroid/bluetooth/BluetoothAdapter;)Ljava/lang/String;
    .locals 8
    .param p0, "bta"    # Landroid/bluetooth/BluetoothAdapter;

    .prologue
    .line 787
    const-string v3, "90:31:B3:62:44:17"

    .line 788
    .local v3, "spoofMac":Ljava/lang/String;
    invoke-virtual {p0}, Landroid/bluetooth/BluetoothAdapter;->getAddress()Ljava/lang/String;

    move-result-object v1

    .line 791
    .local v1, "realMac":Ljava/lang/String;
    const/4 v2, 0x0

    .line 792
    .local v2, "settings":Landroid/content/SharedPreferences;
    const-string v4, ""

    .line 793
    .local v4, "storedID":Ljava/lang/String;
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_1

    .line 794
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v6, "%!RndAlpha%"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 796
    const-string v5, "bt_mac"

    const-string v6, ""

    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 802
    :goto_0
    sget v5, Lhooks/Monolith;->BTMacSpoofType:I

    packed-switch v5, :pswitch_data_0

    .line 830
    :cond_0
    :goto_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getBTMac("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget v6, Lhooks/Monolith;->BTMacSpoofType:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ") - using: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  real: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 833
    return-object v3

    .line 799
    :cond_1
    const-string v5, "getBTMac() has no context. can\'t use session storage. using fallback if necessary."

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 804
    :pswitch_0
    move-object v3, v1

    .line 805
    goto :goto_1

    .line 807
    :pswitch_1
    invoke-static {}, Lhooks/Monolith;->generateRandomMac()Ljava/lang/String;

    move-result-object v3

    .line 808
    goto :goto_1

    .line 810
    :pswitch_2
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_0

    .line 811
    const-string v5, ""

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_2

    .line 813
    move-object v3, v4

    goto :goto_1

    .line 816
    :cond_2
    invoke-static {}, Lhooks/Monolith;->generateRandomMac()Ljava/lang/String;

    move-result-object v3

    .line 818
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 819
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    const-string v5, "wifi_mac"

    invoke-interface {v0, v5, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 820
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    goto :goto_1

    .line 826
    .end local v0    # "editor":Landroid/content/SharedPreferences$Editor;
    :pswitch_3
    const-string v3, "%!BTMacSpoof%"

    goto :goto_1

    .line 802
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
    .end packed-switch
.end method

.method public static getDeviceId()Ljava/lang/String;
    .locals 8

    .prologue
    .line 399
    const-string v3, "319261750826054"

    .line 400
    .local v3, "spoofID":Ljava/lang/String;
    invoke-static {}, Lhooks/Monolith;->getRealDeviceID()Ljava/lang/String;

    move-result-object v1

    .line 403
    .local v1, "realID":Ljava/lang/String;
    const/4 v2, 0x0

    .line 404
    .local v2, "settings":Landroid/content/SharedPreferences;
    const-string v4, ""

    .line 405
    .local v4, "storedID":Ljava/lang/String;
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_1

    .line 406
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v6, "%!RndAlpha%"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 408
    const-string v5, "android_id"

    const-string v6, ""

    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 414
    :goto_0
    sget v5, Lhooks/Monolith;->DeviceIDSpoofType:I

    packed-switch v5, :pswitch_data_0

    .line 451
    :cond_0
    :goto_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getDeviceId("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget v6, Lhooks/Monolith;->DeviceIDSpoofType:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ") - using: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  real: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 454
    return-object v3

    .line 411
    :cond_1
    const-string v5, "getDeviceID() has no context. can\'t use session storage. using fallback if necessary."

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 416
    :pswitch_0
    move-object v3, v1

    .line 417
    goto :goto_1

    .line 419
    :pswitch_1
    invoke-static {}, Lhooks/Monolith;->generateRandomDeviceID()Ljava/lang/String;

    move-result-object v3

    .line 420
    goto :goto_1

    .line 423
    :pswitch_2
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_0

    .line 424
    const-string v5, ""

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_2

    .line 426
    move-object v3, v4

    goto :goto_1

    .line 429
    :cond_2
    sget v5, Lhooks/Monolith;->DeviceIDSpoofType:I

    const/4 v6, 0x2

    if-ne v5, v6, :cond_3

    .line 430
    invoke-static {}, Lhooks/Monolith;->generateRandomDeviceID()Ljava/lang/String;

    move-result-object v3

    .line 436
    :goto_2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 437
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    const-string v5, "android_id"

    invoke-interface {v0, v5, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 438
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    goto :goto_1

    .line 433
    .end local v0    # "editor":Landroid/content/SharedPreferences$Editor;
    :cond_3
    invoke-static {}, Lhooks/Monolith;->getPermutedDeviceID()Ljava/lang/String;

    move-result-object v3

    goto :goto_2

    .line 444
    :pswitch_3
    const-string v3, "000000000000000"

    .line 445
    goto :goto_1

    .line 447
    :pswitch_4
    const-string v3, "%!DeviceIDSpoof%"

    goto :goto_1

    .line 414
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_2
        :pswitch_3
        :pswitch_4
    .end packed-switch
.end method

.method public static getInstallerPackageName(Landroid/content/pm/PackageManager;Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .param p0, "pm"    # Landroid/content/pm/PackageManager;
    .param p1, "packageName"    # Ljava/lang/String;

    .prologue
    .line 270
    invoke-virtual {p0, p1}, Landroid/content/pm/PackageManager;->getInstallerPackageName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 273
    .local v1, "result":Ljava/lang/String;
    if-nez v1, :cond_0

    .line 274
    const-string v1, "com.google.android.feedback"

    .line 276
    :cond_0
    invoke-virtual {p0, p1}, Landroid/content/pm/PackageManager;->getInstallerPackageName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 277
    .local v0, "real":Ljava/lang/String;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getInstallerPackageName("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ") returning "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " but really it\'s: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 279
    return-object v1
.end method

.method public static getJarEntry(Ljava/util/jar/JarFile;Ljava/lang/String;)Ljava/util/jar/JarEntry;
    .locals 2
    .param p0, "jf"    # Ljava/util/jar/JarFile;
    .param p1, "entryName"    # Ljava/lang/String;

    .prologue
    .line 206
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getJarEntry("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "), we call getZipEntry()"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 207
    new-instance v0, Ljava/util/jar/JarEntry;

    invoke-static {p0, p1}, Lhooks/Monolith;->getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/jar/JarEntry;-><init>(Ljava/util/zip/ZipEntry;)V

    return-object v0
.end method

.method public static getNetworkOperator(Landroid/telephony/TelephonyManager;)Ljava/lang/String;
    .locals 3
    .param p0, "tm"    # Landroid/telephony/TelephonyManager;

    .prologue
    .line 725
    const-string v0, "%!NetworkOperatorSpoof%"

    .line 726
    .local v0, "result":Ljava/lang/String;
    const-string v1, "%!NetworkOperatorSpoof%"

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_0

    .line 727
    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getNetworkOperator()Ljava/lang/String;

    move-result-object v0

    .line 730
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getNetworkOperator() - using:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "  real:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getNetworkOperator()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 733
    return-object v0
.end method

.method public static getOurStackDump()Ljava/lang/String;
    .locals 8

    .prologue
    .line 928
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v3

    .line 930
    .local v3, "ste":[Ljava/lang/StackTraceElement;
    const-class v6, Lhooks/Monolith;

    invoke-virtual {v6}, Ljava/lang/Class;->getPackage()Ljava/lang/Package;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Package;->getName()Ljava/lang/String;

    move-result-object v2

    .line 932
    .local v2, "pkg":Ljava/lang/String;
    const-string v4, ""

    .line 933
    .local v4, "trace":Ljava/lang/String;
    const/4 v5, 0x0

    .line 936
    .local v5, "traceCount":I
    const/4 v0, 0x3

    .local v0, "i":I
    :goto_0
    array-length v6, v3

    if-ge v0, v6, :cond_1

    const/4 v6, 0x2

    if-ge v5, v6, :cond_1

    .line 937
    aget-object v6, v3, v0

    invoke-virtual {v6}, Ljava/lang/StackTraceElement;->toString()Ljava/lang/String;

    move-result-object v1

    .line 938
    .local v1, "line":Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_0

    .line 936
    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 941
    :cond_0
    add-int/lit8 v5, v5, 0x1

    .line 942
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "   >"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    aget-object v7, v3, v0

    invoke-virtual {v7}, Ljava/lang/StackTraceElement;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "\n"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    .line 945
    .end local v1    # "line":Ljava/lang/String;
    :cond_1
    return-object v4
.end method

.method public static getPackageInfo(Landroid/content/pm/PackageManager;Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    .locals 6
    .param p0, "pm"    # Landroid/content/pm/PackageManager;
    .param p1, "packageName"    # Ljava/lang/String;
    .param p2, "flags"    # I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/pm/PackageManager$NameNotFoundException;
        }
    .end annotation

    .prologue
    const/4 v5, 0x0

    .line 318
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getPackageInfo("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ") flags="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 321
    const/4 v1, 0x0

    .line 323
    .local v1, "pi":Landroid/content/pm/PackageInfo;
    :try_start_0
    invoke-virtual {p0, p1, p2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v1

    .line 338
    :goto_0
    and-int/lit8 v3, p2, 0x40

    const/16 v4, 0x40

    if-ne v3, v4, :cond_0

    .line 339
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "  spoofing "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, v1, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    array-length v4, v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " signatures for "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 341
    invoke-static {}, Lhooks/Monolith;->spoofSignatures()[Landroid/content/pm/Signature;

    move-result-object v2

    .line 342
    .local v2, "spoofSigs":[Landroid/content/pm/Signature;
    iget-object v3, v1, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    iget-object v4, v1, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    array-length v4, v4

    invoke-static {v2, v5, v3, v5, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 346
    .end local v2    # "spoofSigs":[Landroid/content/pm/Signature;
    :cond_0
    return-object v1

    .line 325
    :catch_0
    move-exception v0

    .line 326
    .local v0, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    sget v3, Lhooks/Monolith;->MyGetPIBehavior:I

    const/4 v4, 0x1

    if-ne v3, v4, :cond_1

    .line 327
    const-string v3, "  app not found, throwing exception"

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 328
    invoke-static {v0}, Lhooks/Monolith;->setStackTrace(Ljava/lang/Throwable;)V

    .line 329
    throw v0

    .line 333
    :cond_1
    const-string v3, "  using package info from %!AppPackage%"

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 334
    const-string v3, "%!AppPackage%"

    invoke-virtual {p0, v3, p2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v1

    goto :goto_0
.end method

.method private static getPermutedDeviceID()Ljava/lang/String;
    .locals 9

    .prologue
    .line 1076
    const/16 v7, 0xf

    new-array v5, v7, [I

    fill-array-data v5, :array_0

    .line 1078
    .local v5, "p":[I
    invoke-static {}, Lhooks/Monolith;->getRealDeviceID()Ljava/lang/String;

    move-result-object v1

    .line 1079
    .local v1, "deviceId":Ljava/lang/String;
    const-string v6, ""

    .line 1080
    .local v6, "result":Ljava/lang/String;
    if-eqz v1, :cond_0

    .line 1081
    move-object v0, v5

    .local v0, "arr$":[I
    array-length v4, v0

    .local v4, "len$":I
    const/4 v3, 0x0

    .local v3, "i$":I
    :goto_0
    if-ge v3, v4, :cond_0

    aget v2, v0, v3

    .line 1082
    .local v2, "i":I
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v1, v2}, Ljava/lang/String;->charAt(I)C

    move-result v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 1081
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1086
    .end local v0    # "arr$":[I
    .end local v2    # "i":I
    .end local v3    # "i$":I
    .end local v4    # "len$":I
    :cond_0
    return-object v6

    .line 1076
    nop

    :array_0
    .array-data 4
        0x8
        0x4
        0xa
        0x0
        0xe
        0xc
        0x3
        0x3
        0xd
        0x2
        0x5
        0x9
        0x6
        0x8
        0xb
    .end array-data
.end method

.method private static getRealDeviceID()Ljava/lang/String;
    .locals 3

    .prologue
    .line 1090
    sget-object v1, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v2, "phone"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 1093
    .local v0, "tm":Landroid/telephony/TelephonyManager;
    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getDeviceId()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method public static getWifiMac(Landroid/net/wifi/WifiInfo;)Ljava/lang/String;
    .locals 8
    .param p0, "wi"    # Landroid/net/wifi/WifiInfo;

    .prologue
    .line 737
    const-string v3, "90:32:A5:75:12:9C"

    .line 738
    .local v3, "spoofMac":Ljava/lang/String;
    invoke-virtual {p0}, Landroid/net/wifi/WifiInfo;->getMacAddress()Ljava/lang/String;

    move-result-object v1

    .line 741
    .local v1, "realMac":Ljava/lang/String;
    const/4 v2, 0x0

    .line 742
    .local v2, "settings":Landroid/content/SharedPreferences;
    const-string v4, ""

    .line 743
    .local v4, "storedID":Ljava/lang/String;
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_1

    .line 744
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v6, "%!RndAlpha%"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 746
    const-string v5, "wifi_mac"

    const-string v6, ""

    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 752
    :goto_0
    sget v5, Lhooks/Monolith;->WifiMacSpoofType:I

    packed-switch v5, :pswitch_data_0

    .line 780
    :cond_0
    :goto_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getWifiMac("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget v6, Lhooks/Monolith;->WifiMacSpoofType:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ") - using: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  real: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 783
    return-object v3

    .line 749
    :cond_1
    const-string v5, "getWifiMac() has no context. can\'t use session storage. using fallback if necessary."

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 754
    :pswitch_0
    move-object v3, v1

    .line 755
    goto :goto_1

    .line 757
    :pswitch_1
    invoke-static {}, Lhooks/Monolith;->generateRandomMac()Ljava/lang/String;

    move-result-object v3

    .line 758
    goto :goto_1

    .line 760
    :pswitch_2
    sget-object v5, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v5, :cond_0

    .line 761
    const-string v5, ""

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_2

    .line 763
    move-object v3, v4

    goto :goto_1

    .line 766
    :cond_2
    invoke-static {}, Lhooks/Monolith;->generateRandomMac()Ljava/lang/String;

    move-result-object v3

    .line 768
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 769
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    const-string v5, "wifi_mac"

    invoke-interface {v0, v5, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 770
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    goto :goto_1

    .line 776
    .end local v0    # "editor":Landroid/content/SharedPreferences$Editor;
    :pswitch_3
    const-string v3, "%!WifiMacSpoof%"

    goto :goto_1

    .line 752
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
    .end packed-switch
.end method

.method public static getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;
    .locals 4
    .param p0, "zf"    # Ljava/util/zip/ZipFile;
    .param p1, "entryName"    # Ljava/lang/String;

    .prologue
    .line 211
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getZipEntry("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 212
    invoke-virtual {p0, p1}, Ljava/util/zip/ZipFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v0

    .line 214
    .local v0, "ze":Ljava/util/zip/ZipEntry;
    const-string v1, "classes.dex"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 215
    const-string v1, "  spoofing entry info"

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 216
    const-string v1, "%!ZipClassesDexCrc%"

    invoke-static {v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Ljava/util/zip/ZipEntry;->setCrc(J)V

    .line 217
    const-string v1, "%!ZipClassesDexSize%"

    invoke-static {v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Ljava/util/zip/ZipEntry;->setSize(J)V

    .line 218
    const-string v1, "%!ZipClassesDexCompressedSize%"

    invoke-static {v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Ljava/util/zip/ZipEntry;->setCompressedSize(J)V

    .line 222
    :cond_0
    return-object v0
.end method

.method private static isChecksumFileName(Ljava/lang/String;)I
    .locals 4
    .param p0, "fileName"    # Ljava/lang/String;

    .prologue
    .line 1011
    const/4 v1, 0x0

    .line 1013
    .local v1, "result":I
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isChecksumFileName("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 1017
    const-string v2, "-"

    invoke-virtual {p0, v2}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v0

    .line 1018
    .local v0, "pos":I
    if-gez v0, :cond_0

    .line 1019
    const-string v2, "."

    invoke-virtual {p0, v2}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v0

    .line 1021
    :cond_0
    const/4 v2, 0x0

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 1023
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "  guessing package = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 1024
    const-string v2, "%!AppPackage%"

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 1025
    const/4 v1, 0x1

    .line 1031
    :cond_1
    :goto_0
    return v1

    .line 1027
    :cond_2
    const-string v2, "classes.dex"

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1028
    const/4 v1, 0x2

    goto :goto_0
.end method

.method public static isDebuggerConnected()Z
    .locals 1

    .prologue
    .line 262
    const-string v0, "isDebuggerConnected()? of course not :D"

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 263
    const/4 v0, 0x0

    return v0
.end method

.method protected static isThisApk(Ljava/io/File;)Z
    .locals 3
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 1055
    const/4 v0, 0x0

    .line 1057
    .local v0, "result":Z
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1058
    const/4 v0, 0x0

    .line 1061
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "%!AppPackage%"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, ".apk"

    invoke-virtual {v1, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1062
    const/4 v0, 0x1

    .line 1065
    :cond_1
    return v0
.end method

.method protected static isThisClassesDex(Ljava/io/File;)Z
    .locals 2
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 1069
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "classes.dex"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static lastModified(Ljava/io/File;)J
    .locals 6
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 370
    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v0

    .line 371
    .local v0, "retVal":J
    invoke-static {p0}, Lhooks/Monolith;->isThisApk(Ljava/io/File;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 372
    const-string v2, "%!OrigApkLastModified%"

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 373
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "lastModified() spoofing of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 386
    :goto_0
    return-wide v0

    .line 376
    :cond_0
    invoke-static {p0}, Lhooks/Monolith;->isThisClassesDex(Ljava/io/File;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 377
    const-string v2, "%!OrigClassesDexLastModified%"

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 378
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "lastModified() spoofing of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 382
    :cond_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "lastModified() NOT spoofing of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0
.end method

.method public static length(Ljava/io/File;)J
    .locals 6
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 350
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v0

    .line 351
    .local v0, "retVal":J
    invoke-static {p0}, Lhooks/Monolith;->isThisApk(Ljava/io/File;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 352
    const-string v2, "%!OrigApkFileSize%"

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 353
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "length() spoofing file length of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 366
    :goto_0
    return-wide v0

    .line 356
    :cond_0
    invoke-static {p0}, Lhooks/Monolith;->isThisClassesDex(Ljava/io/File;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 357
    const-string v2, "%!OrigClassesDexFileSize%"

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 358
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "length() spoofing file length of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 362
    :cond_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "length() NOT spoofing file length of "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " with:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " real:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0
.end method

.method public static loadDex(Ljava/lang/String;Ljava/lang/String;I)Ldalvik/system/DexFile;
    .locals 2
    .param p0, "sourcePathName"    # Ljava/lang/String;
    .param p1, "outputPathName"    # Ljava/lang/String;
    .param p2, "flags"    # I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 199
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "loadDex() src:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " out:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " flags:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 202
    invoke-static {p0, p1, p2}, Ldalvik/system/DexFile;->loadDex(Ljava/lang/String;Ljava/lang/String;I)Ldalvik/system/DexFile;

    move-result-object v0

    return-object v0
.end method

.method public static log(I)V
    .locals 1
    .param p0, "i"    # I

    .prologue
    .line 953
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 955
    return-void
.end method

.method public static log(J)V
    .locals 2
    .param p0, "i"    # J

    .prologue
    .line 959
    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 961
    return-void
.end method

.method public static log(Ljava/lang/Object;)V
    .locals 2
    .param p0, "o"    # Ljava/lang/Object;

    .prologue
    .line 920
    const-string v0, "sequencer"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 921
    const-string v0, "sequencer"

    invoke-static {}, Lhooks/Monolith;->getOurStackDump()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 923
    return-void
.end method

.method public static logmt(Ljava/lang/Object;)V
    .locals 5
    .param p0, "o"    # Ljava/lang/Object;

    .prologue
    .line 964
    sget-object v2, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-eqz v2, :cond_1

    .line 966
    :try_start_0
    sget-object v2, Lhooks/Monolith;->MethodTraceFOS:Ljava/io/FileOutputStream;

    if-nez v2, :cond_0

    .line 967
    sget-object v2, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    const-string v3, "mt.log"

    const v4, 0x8000

    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    move-result-object v2

    sput-object v2, Lhooks/Monolith;->MethodTraceFOS:Ljava/io/FileOutputStream;

    .line 970
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 971
    .local v1, "sb":Ljava/lang/StringBuilder;
    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 972
    invoke-static {}, Lhooks/Monolith;->getOurStackDump()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 973
    sget-object v2, Lhooks/Monolith;->MethodTraceFOS:Ljava/io/FileOutputStream;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 980
    .end local v1    # "sb":Ljava/lang/StringBuilder;
    :cond_1
    :goto_0
    return-void

    .line 975
    :catch_0
    move-exception v0

    .line 976
    .local v0, "e":Ljava/lang/Exception;
    const-string v2, "sequencer"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "logmt() exception: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 977
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private static mentionsOurPackage(Ljava/lang/String;)Z
    .locals 3
    .param p0, "someStr"    # Ljava/lang/String;

    .prologue
    .line 1158
    const-class v1, Lhooks/Monolith;

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    .line 1159
    .local v0, "pkg":Ljava/lang/String;
    const/4 v1, 0x0

    const/16 v2, 0x2e

    invoke-virtual {v0, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 1160
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    return v1
.end method

.method public static osWrite(Ljava/io/OutputStream;Ljava/lang/String;)V
    .locals 1
    .param p0, "os"    # Ljava/io/OutputStream;
    .param p1, "str"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 478
    invoke-virtual {p1}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    invoke-static {p0, v0}, Lhooks/Monolith;->osWrite(Ljava/io/OutputStream;[B)V

    .line 479
    return-void
.end method

.method public static osWrite(Ljava/io/OutputStream;[B)V
    .locals 7
    .param p0, "os"    # Ljava/io/OutputStream;
    .param p1, "barr"    # [B
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 482
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "osWrite("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    new-instance v6, Ljava/lang/String;

    invoke-direct {v6, p1}, Ljava/lang/String;-><init>([B)V

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ")"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 484
    sget-object v5, Lhooks/Monolith;->MyWatchedProcess:Ljava/lang/Process;

    if-eqz v5, :cond_1

    .line 485
    const/4 v3, 0x0

    .line 487
    .local v3, "target":Z
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-class v6, Ljava/io/OutputStream;

    if-ne v5, v6, :cond_2

    sget-object v5, Lhooks/Monolith;->MyWatchedProcess:Ljava/lang/Process;

    invoke-virtual {v5}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v5

    if-ne p0, v5, :cond_2

    .line 489
    const/4 v3, 0x1

    .line 508
    :cond_0
    :goto_0
    if-eqz v3, :cond_1

    .line 509
    new-instance v5, Ljava/lang/String;

    invoke-direct {v5, p1}, Ljava/lang/String;-><init>([B)V

    invoke-static {v5}, Lhooks/Monolith;->fixSysCmd(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 510
    .local v2, "newCmd":Ljava/lang/String;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "osWrite() new cmd = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 511
    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object p1

    .line 515
    .end local v2    # "newCmd":Ljava/lang/String;
    .end local v3    # "target":Z
    :cond_1
    invoke-virtual {p0, p1}, Ljava/io/OutputStream;->write([B)V

    .line 516
    return-void

    .line 491
    .restart local v3    # "target":Z
    :cond_2
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-class v6, Ljava/io/DataOutputStream;

    if-eq v5, v6, :cond_3

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-class v6, Ljava/io/FilterOutputStream;

    if-ne v5, v6, :cond_0

    .line 493
    :cond_3
    const/4 v1, 0x0

    .line 495
    .local v1, "f":Ljava/lang/reflect/Field;
    :try_start_0
    const-class v5, Ljava/io/FilterOutputStream;

    const-string v6, "out"

    invoke-virtual {v5, v6}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    .line 497
    const/4 v5, 0x1

    invoke-virtual {v1, v5}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 498
    invoke-virtual {v1, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/io/OutputStream;

    .line 499
    .local v4, "theOs":Ljava/io/OutputStream;
    sget-object v5, Lhooks/Monolith;->MyWatchedProcess:Ljava/lang/Process;

    invoke-virtual {v5}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v5

    if-ne v4, v5, :cond_0

    .line 500
    const/4 v3, 0x1

    goto :goto_0

    .line 503
    .end local v4    # "theOs":Ljava/io/OutputStream;
    :catch_0
    move-exception v0

    .line 504
    .local v0, "e":Ljava/lang/Exception;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "osWrite() exception: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0
.end method

.method public static runtimeExec(Ljava/lang/Runtime;Ljava/lang/String;)Ljava/lang/Process;
    .locals 3
    .param p0, "rt"    # Ljava/lang/Runtime;
    .param p1, "cmd"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 470
    invoke-static {p1}, Lhooks/Monolith;->fixSysCmd(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 472
    .local v0, "newCmd":Ljava/lang/String;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "runtimeExec("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ") = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 474
    invoke-virtual {p0, v0}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v1

    return-object v1
.end method

.method private static scrubStackTrace(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    .param p0, "stackTrace"    # Ljava/lang/String;

    .prologue
    .line 1145
    const-string v6, "\n"

    invoke-virtual {p0, v6}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 1146
    .local v4, "lines":[Ljava/lang/String;
    const-string v5, ""

    .line 1147
    .local v5, "result":Ljava/lang/String;
    move-object v0, v4

    .local v0, "arr$":[Ljava/lang/String;
    array-length v2, v0

    .local v2, "len$":I
    const/4 v1, 0x0

    .local v1, "i$":I
    :goto_0
    if-ge v1, v2, :cond_1

    aget-object v3, v0, v1

    .line 1148
    .local v3, "line":Ljava/lang/String;
    invoke-static {v3}, Lhooks/Monolith;->mentionsOurPackage(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 1149
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const/16 v7, 0xa

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1147
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1153
    .end local v3    # "line":Ljava/lang/String;
    :cond_1
    return-object v5
.end method

.method private static scrubStackTrace([Ljava/lang/StackTraceElement;)[Ljava/lang/StackTraceElement;
    .locals 7
    .param p0, "ste"    # [Ljava/lang/StackTraceElement;

    .prologue
    .line 1133
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 1134
    .local v5, "newStackList":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/StackTraceElement;>;"
    move-object v0, p0

    .local v0, "arr$":[Ljava/lang/StackTraceElement;
    array-length v3, v0

    .local v3, "len$":I
    const/4 v2, 0x0

    .local v2, "i$":I
    :goto_0
    if-ge v2, v3, :cond_1

    aget-object v1, v0, v2

    .line 1135
    .local v1, "e":Ljava/lang/StackTraceElement;
    invoke-virtual {v1}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lhooks/Monolith;->mentionsOurPackage(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 1136
    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1134
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1139
    .end local v1    # "e":Ljava/lang/StackTraceElement;
    :cond_1
    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v6

    new-array v4, v6, [Ljava/lang/StackTraceElement;

    .line 1141
    .local v4, "newStack":[Ljava/lang/StackTraceElement;
    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v6

    check-cast v6, [Ljava/lang/StackTraceElement;

    return-object v6
.end method

.method public static setAppContext(Landroid/content/Context;)V
    .locals 1
    .param p0, "c"    # Landroid/content/Context;

    .prologue
    .line 913
    sget-object v0, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-nez v0, :cond_0

    .line 914
    sput-object p0, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    .line 916
    :cond_0
    return-void
.end method

.method public static setStackTrace(Ljava/lang/Throwable;)V
    .locals 1
    .param p0, "th"    # Ljava/lang/Throwable;

    .prologue
    .line 546
    const-string v0, "setStackTrace() get ready to lie!"

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 547
    invoke-virtual {p0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->scrubStackTrace([Ljava/lang/StackTraceElement;)[Ljava/lang/StackTraceElement;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->setStackTrace([Ljava/lang/StackTraceElement;)V

    .line 548
    return-void
.end method

.method public static signatureVerify(Ljava/security/Signature;[B)Z
    .locals 3
    .param p0, "s"    # Ljava/security/Signature;
    .param p1, "signature"    # [B
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/security/SignatureException;
        }
    .end annotation

    .prologue
    .line 520
    const/4 v0, 0x1

    .line 522
    .local v0, "result":Z
    sget v1, Lhooks/Monolith;->MySigVerifyBehavior:I

    if-eqz v1, :cond_0

    .line 523
    invoke-virtual {p0, p1}, Ljava/security/Signature;->verify([B)Z

    move-result v0

    .line 526
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "signatureVerify(2) returning "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ". is actually "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0, p1}, Ljava/security/Signature;->verify([B)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 528
    return v0
.end method

.method public static signatureVerify(Ljava/security/Signature;[BII)Z
    .locals 3
    .param p0, "s"    # Ljava/security/Signature;
    .param p1, "signature"    # [B
    .param p2, "offset"    # I
    .param p3, "length"    # I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/security/SignatureException;
        }
    .end annotation

    .prologue
    .line 535
    const/4 v0, 0x1

    .line 536
    .local v0, "result":Z
    sget v1, Lhooks/Monolith;->MySigVerifyBehavior:I

    if-eqz v1, :cond_0

    .line 537
    invoke-virtual {p0, p1, p2, p3}, Ljava/security/Signature;->verify([BII)Z

    move-result v0

    .line 540
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "signatureVerify(4) returning "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 541
    return v0
.end method

.method public static spoofChecksum(Ljava/util/zip/Checksum;)J
    .locals 5
    .param p0, "cs"    # Ljava/util/zip/Checksum;

    .prologue
    .line 637
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "spoofChecksum("

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, ")"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 638
    invoke-interface {p0}, Ljava/util/zip/Checksum;->getValue()J

    move-result-wide v2

    .line 640
    .local v2, "result":J
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 643
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 644
    .local v0, "fileName":Ljava/lang/String;
    invoke-static {v0}, Lhooks/Monolith;->isChecksumFileName(Ljava/lang/String;)I

    move-result v1

    packed-switch v1, :pswitch_data_0

    .line 666
    .end local v0    # "fileName":Ljava/lang/String;
    :cond_0
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "  result = "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 667
    return-wide v2

    .line 646
    .restart local v0    # "fileName":Ljava/lang/String;
    :pswitch_0
    const-string v1, "  giving APP chksum!"

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 647
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-class v4, Ljava/util/zip/Adler32;

    if-ne v1, v4, :cond_1

    .line 648
    sget-object v1, Lhooks/Monolith;->CHKSUM_ADLER32_App:Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    goto :goto_0

    .line 651
    :cond_1
    sget-object v1, Lhooks/Monolith;->CHKSUM_CRC32_App:Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    .line 653
    goto :goto_0

    .line 655
    :pswitch_1
    const-string v1, "  giving classes.dex chksum!"

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 656
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-class v4, Ljava/util/zip/Adler32;

    if-ne v1, v4, :cond_2

    .line 657
    sget-object v1, Lhooks/Monolith;->CHKSUM_ADLER32_DEX:Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    goto :goto_0

    .line 660
    :cond_2
    sget-object v1, Lhooks/Monolith;->CHKSUM_CRC32_DEX:Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    goto :goto_0

    .line 644
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static spoofDigest(Ljava/security/MessageDigest;)[B
    .locals 5
    .param p0, "md"    # Ljava/security/MessageDigest;

    .prologue
    .line 587
    sget-object v3, Lhooks/Monolith;->CHKSUM_MD5_App:[B

    if-nez v3, :cond_0

    .line 589
    :try_start_0
    const-string v3, "%!ChksumMD5App%"

    invoke-static {v3}, Lhooks/CryptUtils;->decode(Ljava/lang/String;)[B

    move-result-object v3

    sput-object v3, Lhooks/Monolith;->CHKSUM_MD5_App:[B

    .line 590
    const-string v3, "%!ChksumSHA1App%"

    invoke-static {v3}, Lhooks/CryptUtils;->decode(Ljava/lang/String;)[B

    move-result-object v3

    sput-object v3, Lhooks/Monolith;->CHKSUM_SHA1_App:[B

    .line 592
    const-string v3, "%!ChksumMD5DEX%"

    invoke-static {v3}, Lhooks/CryptUtils;->decode(Ljava/lang/String;)[B

    move-result-object v3

    sput-object v3, Lhooks/Monolith;->CHKSUM_MD5_DEX:[B

    .line 593
    const-string v3, "%!ChksumSHA1DEX%"

    invoke-static {v3}, Lhooks/CryptUtils;->decode(Ljava/lang/String;)[B

    move-result-object v3

    sput-object v3, Lhooks/Monolith;->CHKSUM_SHA1_DEX:[B
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 600
    :cond_0
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "spoofDigest("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {p0}, Ljava/security/MessageDigest;->getAlgorithm()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ")"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 602
    const/4 v2, 0x0

    .line 604
    .local v2, "result":[B
    sget-object v3, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v3, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 605
    sget-object v3, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v3, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 606
    .local v1, "fileName":Ljava/lang/String;
    invoke-static {v1}, Lhooks/Monolith;->isChecksumFileName(Ljava/lang/String;)I

    move-result v3

    packed-switch v3, :pswitch_data_0

    .line 632
    .end local v1    # "fileName":Ljava/lang/String;
    :goto_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "  result = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static {v2}, Lhooks/CryptUtils;->encode([B)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 633
    return-object v2

    .line 595
    .end local v2    # "result":[B
    :catch_0
    move-exception v0

    .line 596
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0

    .line 608
    .end local v0    # "e":Ljava/lang/Exception;
    .restart local v1    # "fileName":Ljava/lang/String;
    .restart local v2    # "result":[B
    :pswitch_0
    const-string v3, "  giving APP digest!"

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 609
    invoke-virtual {p0}, Ljava/security/MessageDigest;->getAlgorithm()Ljava/lang/String;

    move-result-object v3

    const-string v4, "MD5"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 610
    sget-object v2, Lhooks/Monolith;->CHKSUM_MD5_App:[B

    goto :goto_1

    .line 613
    :cond_1
    sget-object v2, Lhooks/Monolith;->CHKSUM_SHA1_App:[B

    .line 615
    goto :goto_1

    .line 617
    :pswitch_1
    const-string v3, "  giving classes.dex digest!"

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 618
    invoke-virtual {p0}, Ljava/security/MessageDigest;->getAlgorithm()Ljava/lang/String;

    move-result-object v3

    const-string v4, "MD5"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 619
    sget-object v2, Lhooks/Monolith;->CHKSUM_MD5_DEX:[B

    goto :goto_1

    .line 622
    :cond_2
    sget-object v2, Lhooks/Monolith;->CHKSUM_SHA1_DEX:[B

    goto :goto_1

    .line 628
    .end local v1    # "fileName":Ljava/lang/String;
    :cond_3
    const-string v3, "  don\'t really know what we\'re digesting. sending the real thing!"

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 629
    invoke-virtual {p0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v2

    goto :goto_1

    .line 606
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method protected static spoofSignatures()[Landroid/content/pm/Signature;
    .locals 6

    .prologue
    .line 1114
    const-string v4, "spoofSignatures() called!"

    invoke-static {v4}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 1116
    const-string v4, "%!CertCount%"

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    .line 1117
    .local v0, "certCount":I
    new-array v3, v0, [Landroid/content/pm/Signature;

    .line 1122
    .local v3, "result":[Landroid/content/pm/Signature;
    const-string v2, "%!SignatureChars%"

    .line 1124
    .local v2, "replace":Ljava/lang/String;
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_0

    .line 1125
    new-instance v4, Landroid/content/pm/Signature;

    const-string v5, "%!SignatureChars%"

    invoke-direct {v4, v5}, Landroid/content/pm/Signature;-><init>(Ljava/lang/String;)V

    aput-object v4, v3, v1

    .line 1124
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1128
    :cond_0
    return-object v3
.end method

.method public static threadDumpStack()V
    .locals 5

    .prologue
    .line 558
    const-string v4, "threadDumpStack() get ready to lie!"

    invoke-static {v4}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 559
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 560
    .local v0, "baos":Ljava/io/ByteArrayOutputStream;
    new-instance v2, Ljava/io/PrintStream;

    invoke-direct {v2, v0}, Ljava/io/PrintStream;-><init>(Ljava/io/OutputStream;)V

    .line 561
    .local v2, "ps":Ljava/io/PrintStream;
    sget-object v1, Ljava/lang/System;->err:Ljava/io/PrintStream;

    .line 563
    .local v1, "origPS":Ljava/io/PrintStream;
    invoke-static {v2}, Ljava/lang/System;->setErr(Ljava/io/PrintStream;)V

    .line 564
    invoke-static {}, Ljava/lang/Thread;->dumpStack()V

    .line 565
    invoke-static {v1}, Ljava/lang/System;->setErr(Ljava/io/PrintStream;)V

    .line 567
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lhooks/Monolith;->scrubStackTrace(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 568
    .local v3, "trace":Ljava/lang/String;
    sget-object v4, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v4, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 569
    return-void
.end method

.method public static threadGetStackTrace(Ljava/lang/Thread;)[Ljava/lang/StackTraceElement;
    .locals 1
    .param p0, "t"    # Ljava/lang/Thread;

    .prologue
    .line 552
    const-string v0, "threadGetStackTrace() get ready to lie!"

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 553
    invoke-virtual {p0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->scrubStackTrace([Ljava/lang/StackTraceElement;)[Ljava/lang/StackTraceElement;

    move-result-object v0

    return-object v0
.end method

.method public static throwablePrintStackTrace(Ljava/lang/Throwable;)V
    .locals 5
    .param p0, "t"    # Ljava/lang/Throwable;

    .prologue
    .line 573
    const-string v4, "throwablePrintStack() get ready to lie!"

    invoke-static {v4}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 574
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 575
    .local v0, "baos":Ljava/io/ByteArrayOutputStream;
    new-instance v2, Ljava/io/PrintStream;

    invoke-direct {v2, v0}, Ljava/io/PrintStream;-><init>(Ljava/io/OutputStream;)V

    .line 576
    .local v2, "ps":Ljava/io/PrintStream;
    sget-object v1, Ljava/lang/System;->err:Ljava/io/PrintStream;

    .line 578
    .local v1, "origPS":Ljava/io/PrintStream;
    invoke-static {v2}, Ljava/lang/System;->setErr(Ljava/io/PrintStream;)V

    .line 579
    invoke-virtual {p0}, Ljava/lang/Throwable;->printStackTrace()V

    .line 580
    invoke-static {v1}, Ljava/lang/System;->setErr(Ljava/io/PrintStream;)V

    .line 582
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lhooks/Monolith;->scrubStackTrace(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 583
    .local v3, "trace":Ljava/lang/String;
    sget-object v4, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v4, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 584
    return-void
.end method

.method public static toast(Ljava/lang/Object;)V
    .locals 5
    .param p0, "o"    # Ljava/lang/Object;

    .prologue
    const/4 v4, 0x1

    const/4 v3, 0x0

    .line 983
    sget-object v2, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    if-nez v2, :cond_0

    .line 984
    const-string v2, "toast() can\'t happen because no context."

    invoke-static {v2}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 1000
    :goto_0
    return-void

    .line 990
    :cond_0
    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 991
    .local v0, "str":Ljava/lang/String;
    sget-object v2, Lhooks/Monolith;->AppContext:Landroid/content/Context;

    invoke-static {v2, v0, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    .line 994
    .local v1, "t":Landroid/widget/Toast;
    const/16 v2, 0x31

    invoke-virtual {v1, v2, v3, v3}, Landroid/widget/Toast;->setGravity(III)V

    .line 997
    invoke-virtual {v1}, Landroid/widget/Toast;->getView()Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/LinearLayout;

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setGravity(I)V

    .line 999
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    goto :goto_0
.end method

.method public static waitForDebugger()V
    .locals 2

    .prologue
    .line 187
    :goto_0
    :try_start_0
    const-string v0, "  pretending to wait for debugger!"

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 190
    const-wide/16 v0, 0x20eb

    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 193
    :catch_0
    move-exception v0

    .line 195
    return-void
.end method

.method public static watchChecksum(Ljava/io/InputStream;Ljava/util/zip/Checksum;)V
    .locals 2
    .param p0, "is"    # Ljava/io/InputStream;
    .param p1, "chk"    # Ljava/util/zip/Checksum;

    .prologue
    .line 845
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 853
    :goto_0
    return-void

    .line 846
    :cond_0
    sget-object v1, Lhooks/Monolith;->MyChecksumInputStreams:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 847
    .local v0, "fileName":Ljava/lang/String;
    if-nez v0, :cond_1

    .line 848
    const-string v1, "  unable to determine filename of checksum!"

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 851
    :cond_1
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p1, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public static watchDigest(Ljava/security/MessageDigest;)V
    .locals 3
    .param p0, "md"    # Ljava/security/MessageDigest;

    .prologue
    .line 856
    const/4 v1, 0x1

    sput-boolean v1, Lhooks/Monolith;->BuildingDigest:Z

    .line 858
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 873
    :goto_0
    return-void

    .line 860
    :cond_0
    sget-object v1, Lhooks/Monolith;->LastReadInputStream:Ljava/io/InputStream;

    if-nez v1, :cond_1

    .line 861
    const-string v1, "  updating message digest, but don\'t know last read InputStream. should only see this once."

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 865
    :cond_1
    sget-object v1, Lhooks/Monolith;->MyChecksumInputStreams:Ljava/util/HashMap;

    sget-object v2, Lhooks/Monolith;->LastReadInputStream:Ljava/io/InputStream;

    invoke-virtual {v1, v2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 866
    .local v0, "fileName":Ljava/lang/String;
    if-nez v0, :cond_2

    .line 867
    const-string v1, "  unable to determine filename of checksum!"

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0

    .line 870
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "  watching message digest for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 871
    sget-object v1, Lhooks/Monolith;->MyWatchedChecksumsOrDigests:Ljava/util/HashMap;

    invoke-virtual {v1, p0, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public static watchInputStream(Ljava/lang/Object;Ljava/io/File;)V
    .locals 1
    .param p0, "is"    # Ljava/lang/Object;
    .param p1, "f"    # Ljava/io/File;

    .prologue
    .line 883
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lhooks/Monolith;->watchInputStream(Ljava/lang/Object;Ljava/lang/String;)V

    .line 884
    return-void
.end method

.method public static watchInputStream(Ljava/lang/Object;Ljava/lang/String;)V
    .locals 2
    .param p0, "is"    # Ljava/lang/Object;
    .param p1, "fileName"    # Ljava/lang/String;

    .prologue
    .line 889
    sget-object v0, Lhooks/Monolith;->MyChecksumInputStreams:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 896
    .end local p0    # "is":Ljava/lang/Object;
    :goto_0
    return-void

    .line 893
    .restart local p0    # "is":Ljava/lang/Object;
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "watchInputStream("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 894
    sget-object v0, Lhooks/Monolith;->MyChecksumInputStreams:Ljava/util/HashMap;

    check-cast p0, Ljava/io/InputStream;

    .end local p0    # "is":Ljava/lang/Object;
    invoke-virtual {v0, p0, p1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public static watchInputStreamReadForDigest(Ljava/lang/Object;)V
    .locals 1
    .param p0, "is"    # Ljava/lang/Object;

    .prologue
    .line 876
    sget-boolean v0, Lhooks/Monolith;->BuildingDigest:Z

    if-eqz v0, :cond_0

    .line 877
    check-cast p0, Ljava/io/InputStream;

    .end local p0    # "is":Ljava/lang/Object;
    sput-object p0, Lhooks/Monolith;->LastReadInputStream:Ljava/io/InputStream;

    .line 879
    :cond_0
    return-void
.end method

.method public static watchProcess(Ljava/lang/Process;)V
    .locals 0
    .param p0, "p"    # Ljava/lang/Process;

    .prologue
    .line 906
    sput-object p0, Lhooks/Monolith;->MyWatchedProcess:Ljava/lang/Process;

    .line 907
    return-void
.end method


# virtual methods
.method public getSettingsString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p1, "cr"    # Landroid/content/ContentResolver;
    .param p2, "setting"    # Ljava/lang/String;

    .prologue
    .line 458
    const-string v0, "android_id"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 459
    const-string v0, "getSettingString(android_id) returning getDeviceID()"

    invoke-static {v0}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 461
    invoke-static {}, Lhooks/Monolith;->getDeviceId()Ljava/lang/String;

    move-result-object v0

    .line 464
    :goto_0
    return-object v0

    :cond_0
    const-string v0, "android_id"

    invoke-static {p1, v0}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method
