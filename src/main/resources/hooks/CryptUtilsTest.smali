.class public Lhooks/CryptUtilsTest;
.super Ljunit/framework/TestCase;
.source "CryptUtilsTest.java"


# static fields
.field static final synthetic $assertionsDisabled:Z

.field private static final Encoded:Ljava/lang/String; = "SXQgaXMgYnkgd2lsbCBhbG9uZSBJIHNldCBteSBtaW5kIGluIG1vdGlvbi4hQCMkJV4mKigpXys8\nPjoie307Oic="

.field private static final Plaintext:Ljava/lang/String; = "It is by will alone I set my mind in motion.!@#$%^&*()_+<>:\"{};:\'"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 7
    const-class v0, Lhooks/CryptUtilsTest;

    invoke-virtual {v0}, Ljava/lang/Class;->desiredAssertionStatus()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    sput-boolean v0, Lhooks/CryptUtilsTest;->$assertionsDisabled:Z

    .line 10
    return-void

    .line 7
    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljunit/framework/TestCase;-><init>()V

    return-void
.end method


# virtual methods
.method public testDecode()V
    .locals 2

    .prologue
    .line 19
    const-string v1, "SXQgaXMgYnkgd2lsbCBhbG9uZSBJIHNldCBteSBtaW5kIGluIG1vdGlvbi4hQCMkJV4mKigpXys8\nPjoie307Oic="

    invoke-static {v1}, Lhooks/CryptUtils;->decode(Ljava/lang/String;)[B

    move-result-object v0

    .line 21
    .local v0, "decoded":[B
    sget-boolean v1, Lhooks/CryptUtilsTest;->$assertionsDisabled:Z

    if-nez v1, :cond_0

    const-string v1, "It is by will alone I set my mind in motion.!@#$%^&*()_+<>:\"{};:\'"

    invoke-virtual {v1}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v1

    if-nez v1, :cond_0

    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1

    .line 22
    :cond_0
    return-void
.end method

.method public testEncode()V
    .locals 2

    .prologue
    .line 13
    const-string v1, "It is by will alone I set my mind in motion.!@#$%^&*()_+<>:\"{};:\'"

    invoke-virtual {v1}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-static {v1}, Lhooks/CryptUtils;->encode([B)Ljava/lang/String;

    move-result-object v0

    .line 15
    .local v0, "encoded":Ljava/lang/String;
    sget-boolean v1, Lhooks/CryptUtilsTest;->$assertionsDisabled:Z

    if-nez v1, :cond_0

    const-string v1, "SXQgaXMgYnkgd2lsbCBhbG9uZSBJIHNldCBteSBtaW5kIGluIG1vdGlvbi4hQCMkJV4mKigpXys8\nPjoie307Oic="

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1

    .line 16
    :cond_0
    return-void
.end method
