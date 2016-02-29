.class public Lhooks/CryptUtils;
.super Ljava/lang/Object;
.source "CryptUtils.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static decode(Ljava/lang/String;)[B
    .locals 9
    .param p0, "data"    # Ljava/lang/String;

    .prologue
    const/4 v8, -0x1

    .line 51
    const/16 v6, 0xff

    new-array v5, v6, [I

    fill-array-data v5, :array_0

    .line 63
    .local v5, "table":[I
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    .line 65
    .local v2, "bytes":[B
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 66
    .local v1, "buffer":Ljava/lang/StringBuilder;
    const/4 v4, 0x0

    .local v4, "i":I
    :goto_0
    array-length v6, v2

    if-ge v4, v6, :cond_5

    .line 67
    const/4 v0, 0x0

    .line 68
    .local v0, "b":I
    aget-byte v6, v2, v4

    aget v6, v5, v6

    if-eq v6, v8, :cond_3

    .line 69
    aget-byte v6, v2, v4

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v0, v6, 0x12

    .line 76
    add-int/lit8 v6, v4, 0x1

    array-length v7, v2

    if-ge v6, v7, :cond_0

    add-int/lit8 v6, v4, 0x1

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_0

    .line 77
    add-int/lit8 v6, v4, 0x1

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0xc

    or-int/2addr v0, v6

    .line 79
    :cond_0
    add-int/lit8 v6, v4, 0x2

    array-length v7, v2

    if-ge v6, v7, :cond_1

    add-int/lit8 v6, v4, 0x2

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_1

    .line 80
    add-int/lit8 v6, v4, 0x2

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x6

    or-int/2addr v0, v6

    .line 82
    :cond_1
    add-int/lit8 v6, v4, 0x3

    array-length v7, v2

    if-ge v6, v7, :cond_2

    add-int/lit8 v6, v4, 0x3

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_2

    .line 83
    add-int/lit8 v6, v4, 0x3

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    or-int/2addr v0, v6

    .line 86
    :cond_2
    :goto_1
    const v6, 0xffffff

    and-int/2addr v6, v0

    if-eqz v6, :cond_4

    .line 87
    const/high16 v6, 0xff0000

    and-int/2addr v6, v0

    shr-int/lit8 v3, v6, 0x10

    .line 88
    .local v3, "c":I
    int-to-char v6, v3

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 89
    shl-int/lit8 v0, v0, 0x8

    .line 90
    goto :goto_1

    .line 72
    .end local v3    # "c":I
    :cond_3
    add-int/lit8 v4, v4, 0x1

    .line 73
    goto :goto_0

    .line 92
    :cond_4
    add-int/lit8 v4, v4, 0x4

    .line 93
    goto :goto_0

    .line 95
    .end local v0    # "b":I
    :cond_5
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->getBytes()[B

    move-result-object v6

    return-object v6

    .line 51
    nop

    :array_0
    .array-data 4
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        0x3e
        -0x1
        -0x1
        -0x1
        0x3f
        0x34
        0x35
        0x36
        0x37
        0x38
        0x39
        0x3a
        0x3b
        0x3c
        0x3d
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        0x0
        0x1
        0x2
        0x3
        0x4
        0x5
        0x6
        0x7
        0x8
        0x9
        0xa
        0xb
        0xc
        0xd
        0xe
        0xf
        0x10
        0x11
        0x12
        0x13
        0x14
        0x15
        0x16
        0x17
        0x18
        0x19
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        0x1a
        0x1b
        0x1c
        0x1d
        0x1e
        0x1f
        0x20
        0x21
        0x22
        0x23
        0x24
        0x25
        0x26
        0x27
        0x28
        0x29
        0x2a
        0x2b
        0x2c
        0x2d
        0x2e
        0x2f
        0x30
        0x31
        0x32
        0x33
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
        -0x1
    .end array-data
.end method

.method public static encode([B)Ljava/lang/String;
    .locals 10
    .param p0, "data"    # [B

    .prologue
    const v9, 0xffffff

    .line 12
    const/16 v7, 0x40

    new-array v6, v7, [C

    fill-array-data v6, :array_0

    .line 17
    .local v6, "table":[C
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 18
    .local v1, "buffer":Ljava/lang/StringBuilder;
    const/4 v5, 0x0

    .line 19
    .local v5, "pad":I
    const/4 v3, 0x0

    .local v3, "i":I
    :goto_0
    array-length v7, p0

    if-ge v3, v7, :cond_4

    .line 20
    aget-byte v7, p0, v3

    and-int/lit16 v7, v7, 0xff

    shl-int/lit8 v7, v7, 0x10

    and-int v0, v7, v9

    .line 21
    .local v0, "b":I
    add-int/lit8 v7, v3, 0x1

    array-length v8, p0

    if-ge v7, v8, :cond_1

    .line 22
    add-int/lit8 v7, v3, 0x1

    aget-byte v7, p0, v7

    and-int/lit16 v7, v7, 0xff

    shl-int/lit8 v7, v7, 0x8

    or-int/2addr v0, v7

    .line 26
    :goto_1
    add-int/lit8 v7, v3, 0x2

    array-length v8, p0

    if-ge v7, v8, :cond_2

    .line 27
    add-int/lit8 v7, v3, 0x2

    aget-byte v7, p0, v7

    and-int/lit16 v7, v7, 0xff

    or-int/2addr v0, v7

    .line 32
    :goto_2
    rem-int/lit8 v7, v3, 0x39

    if-nez v7, :cond_0

    if-lez v3, :cond_0

    .line 33
    const-string v7, "\n"

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 36
    :cond_0
    :goto_3
    and-int v7, v0, v9

    if-eqz v7, :cond_3

    .line 37
    const/high16 v7, 0xfc0000

    and-int/2addr v7, v0

    shr-int/lit8 v2, v7, 0x12

    .line 38
    .local v2, "c":I
    aget-char v7, v6, v2

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 39
    shl-int/lit8 v0, v0, 0x6

    .line 40
    goto :goto_3

    .line 24
    .end local v2    # "c":I
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 29
    :cond_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 19
    :cond_3
    add-int/lit8 v3, v3, 0x3

    goto :goto_0

    .line 43
    .end local v0    # "b":I
    :cond_4
    const/4 v4, 0x0

    .local v4, "j":I
    :goto_4
    if-ge v4, v5, :cond_5

    .line 44
    const-string v7, "="

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 43
    add-int/lit8 v4, v4, 0x1

    goto :goto_4

    .line 47
    :cond_5
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    return-object v7

    .line 12
    nop

    :array_0
    .array-data 2
        0x41s
        0x42s
        0x43s
        0x44s
        0x45s
        0x46s
        0x47s
        0x48s
        0x49s
        0x4as
        0x4bs
        0x4cs
        0x4ds
        0x4es
        0x4fs
        0x50s
        0x51s
        0x52s
        0x53s
        0x54s
        0x55s
        0x56s
        0x57s
        0x58s
        0x59s
        0x5as
        0x61s
        0x62s
        0x63s
        0x64s
        0x65s
        0x66s
        0x67s
        0x68s
        0x69s
        0x6as
        0x6bs
        0x6cs
        0x6ds
        0x6es
        0x6fs
        0x70s
        0x71s
        0x72s
        0x73s
        0x74s
        0x75s
        0x76s
        0x77s
        0x78s
        0x79s
        0x7as
        0x30s
        0x31s
        0x32s
        0x33s
        0x34s
        0x35s
        0x36s
        0x37s
        0x38s
        0x39s
        0x2bs
        0x2fs
    .end array-data
.end method

.method public static md5(Ljava/io/File;)Ljava/lang/String;
    .locals 8
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 99
    const/4 v5, 0x0

    .line 100
    .local v5, "md":Ljava/security/MessageDigest;
    const/4 v3, 0x0

    .line 102
    .local v3, "is":Ljava/io/InputStream;
    :try_start_0
    const-string v6, "MD5"

    invoke-static {v6}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v5

    .line 103
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 104
    .end local v3    # "is":Ljava/io/InputStream;
    .local v4, "is":Ljava/io/InputStream;
    :try_start_1
    new-instance v3, Ljava/security/DigestInputStream;

    invoke-direct {v3, v4, v5}, Ljava/security/DigestInputStream;-><init>(Ljava/io/InputStream;Ljava/security/MessageDigest;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_4
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 105
    .end local v4    # "is":Ljava/io/InputStream;
    .restart local v3    # "is":Ljava/io/InputStream;
    const/16 v6, 0x2000

    :try_start_2
    new-array v0, v6, [B

    .line 106
    .local v0, "buffer":[B
    :cond_0
    invoke-virtual {v3, v0}, Ljava/io/InputStream;->read([B)I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-result v6

    const/4 v7, -0x1

    if-ne v6, v7, :cond_0

    .line 112
    :try_start_3
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_0

    .line 118
    .end local v0    # "buffer":[B
    :goto_0
    invoke-virtual {v5}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v1

    .line 119
    .local v1, "digest":[B
    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    return-object v6

    .line 113
    .end local v1    # "digest":[B
    .restart local v0    # "buffer":[B
    :catch_0
    move-exception v2

    .line 114
    .local v2, "e":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 108
    .end local v0    # "buffer":[B
    .end local v2    # "e":Ljava/io/IOException;
    :catch_1
    move-exception v2

    .line 109
    .local v2, "e":Ljava/lang/Exception;
    :goto_1
    :try_start_4
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 112
    :try_start_5
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_2

    goto :goto_0

    .line 113
    :catch_2
    move-exception v2

    .line 114
    .local v2, "e":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 111
    .end local v2    # "e":Ljava/io/IOException;
    :catchall_0
    move-exception v6

    .line 112
    :goto_2
    :try_start_6
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_3

    .line 115
    :goto_3
    throw v6

    .line 113
    :catch_3
    move-exception v2

    .line 114
    .restart local v2    # "e":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_3

    .line 111
    .end local v2    # "e":Ljava/io/IOException;
    .end local v3    # "is":Ljava/io/InputStream;
    .restart local v4    # "is":Ljava/io/InputStream;
    :catchall_1
    move-exception v6

    move-object v3, v4

    .end local v4    # "is":Ljava/io/InputStream;
    .restart local v3    # "is":Ljava/io/InputStream;
    goto :goto_2

    .line 108
    .end local v3    # "is":Ljava/io/InputStream;
    .restart local v4    # "is":Ljava/io/InputStream;
    :catch_4
    move-exception v2

    move-object v3, v4

    .end local v4    # "is":Ljava/io/InputStream;
    .restart local v3    # "is":Ljava/io/InputStream;
    goto :goto_1
.end method
