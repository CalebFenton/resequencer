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
    .locals 13
    .parameter "data"

    .prologue
    const/4 v12, 0x4

    const/4 v11, 0x3

    const/4 v10, 0x2

    const/4 v9, 0x1

    const/4 v8, -0x1

    .line 51
    const/16 v6, 0xff

    new-array v5, v6, [I

    const/4 v6, 0x0

    aput v8, v5, v6

    aput v8, v5, v9

    aput v8, v5, v10

    aput v8, v5, v11

    aput v8, v5, v12

    const/4 v6, 0x5

    aput v8, v5, v6

    const/4 v6, 0x6

    aput v8, v5, v6

    const/4 v6, 0x7

    aput v8, v5, v6

    const/16 v6, 0x8

    aput v8, v5, v6

    const/16 v6, 0x9

    aput v8, v5, v6

    const/16 v6, 0xa

    aput v8, v5, v6

    const/16 v6, 0xb

    aput v8, v5, v6

    const/16 v6, 0xc

    aput v8, v5, v6

    const/16 v6, 0xd

    aput v8, v5, v6

    const/16 v6, 0xe

    aput v8, v5, v6

    const/16 v6, 0xf

    aput v8, v5, v6

    const/16 v6, 0x10

    aput v8, v5, v6

    const/16 v6, 0x11

    aput v8, v5, v6

    const/16 v6, 0x12

    aput v8, v5, v6

    const/16 v6, 0x13

    aput v8, v5, v6

    const/16 v6, 0x14

    aput v8, v5, v6

    const/16 v6, 0x15

    aput v8, v5, v6

    const/16 v6, 0x16

    aput v8, v5, v6

    const/16 v6, 0x17

    aput v8, v5, v6

    const/16 v6, 0x18

    .line 52
    aput v8, v5, v6

    const/16 v6, 0x19

    aput v8, v5, v6

    const/16 v6, 0x1a

    aput v8, v5, v6

    const/16 v6, 0x1b

    aput v8, v5, v6

    const/16 v6, 0x1c

    aput v8, v5, v6

    const/16 v6, 0x1d

    aput v8, v5, v6

    const/16 v6, 0x1e

    aput v8, v5, v6

    const/16 v6, 0x1f

    aput v8, v5, v6

    const/16 v6, 0x20

    aput v8, v5, v6

    const/16 v6, 0x21

    aput v8, v5, v6

    const/16 v6, 0x22

    aput v8, v5, v6

    const/16 v6, 0x23

    aput v8, v5, v6

    const/16 v6, 0x24

    aput v8, v5, v6

    const/16 v6, 0x25

    aput v8, v5, v6

    const/16 v6, 0x26

    aput v8, v5, v6

    const/16 v6, 0x27

    aput v8, v5, v6

    const/16 v6, 0x28

    aput v8, v5, v6

    const/16 v6, 0x29

    aput v8, v5, v6

    const/16 v6, 0x2a

    aput v8, v5, v6

    const/16 v6, 0x2b

    const/16 v7, 0x3e

    aput v7, v5, v6

    const/16 v6, 0x2c

    aput v8, v5, v6

    const/16 v6, 0x2d

    aput v8, v5, v6

    const/16 v6, 0x2e

    aput v8, v5, v6

    const/16 v6, 0x2f

    const/16 v7, 0x3f

    aput v7, v5, v6

    const/16 v6, 0x30

    .line 53
    const/16 v7, 0x34

    aput v7, v5, v6

    const/16 v6, 0x31

    const/16 v7, 0x35

    aput v7, v5, v6

    const/16 v6, 0x32

    const/16 v7, 0x36

    aput v7, v5, v6

    const/16 v6, 0x33

    const/16 v7, 0x37

    aput v7, v5, v6

    const/16 v6, 0x34

    const/16 v7, 0x38

    aput v7, v5, v6

    const/16 v6, 0x35

    const/16 v7, 0x39

    aput v7, v5, v6

    const/16 v6, 0x36

    const/16 v7, 0x3a

    aput v7, v5, v6

    const/16 v6, 0x37

    const/16 v7, 0x3b

    aput v7, v5, v6

    const/16 v6, 0x38

    const/16 v7, 0x3c

    aput v7, v5, v6

    const/16 v6, 0x39

    const/16 v7, 0x3d

    aput v7, v5, v6

    const/16 v6, 0x3a

    aput v8, v5, v6

    const/16 v6, 0x3b

    aput v8, v5, v6

    const/16 v6, 0x3c

    aput v8, v5, v6

    const/16 v6, 0x3d

    aput v8, v5, v6

    const/16 v6, 0x3e

    aput v8, v5, v6

    const/16 v6, 0x3f

    aput v8, v5, v6

    const/16 v6, 0x40

    aput v8, v5, v6

    const/16 v6, 0x42

    aput v9, v5, v6

    const/16 v6, 0x43

    aput v10, v5, v6

    const/16 v6, 0x44

    aput v11, v5, v6

    const/16 v6, 0x45

    aput v12, v5, v6

    const/16 v6, 0x46

    const/4 v7, 0x5

    aput v7, v5, v6

    const/16 v6, 0x47

    const/4 v7, 0x6

    aput v7, v5, v6

    const/16 v6, 0x48

    const/4 v7, 0x7

    aput v7, v5, v6

    const/16 v6, 0x49

    const/16 v7, 0x8

    aput v7, v5, v6

    const/16 v6, 0x4a

    .line 54
    const/16 v7, 0x9

    aput v7, v5, v6

    const/16 v6, 0x4b

    const/16 v7, 0xa

    aput v7, v5, v6

    const/16 v6, 0x4c

    const/16 v7, 0xb

    aput v7, v5, v6

    const/16 v6, 0x4d

    const/16 v7, 0xc

    aput v7, v5, v6

    const/16 v6, 0x4e

    const/16 v7, 0xd

    aput v7, v5, v6

    const/16 v6, 0x4f

    const/16 v7, 0xe

    aput v7, v5, v6

    const/16 v6, 0x50

    const/16 v7, 0xf

    aput v7, v5, v6

    const/16 v6, 0x51

    const/16 v7, 0x10

    aput v7, v5, v6

    const/16 v6, 0x52

    const/16 v7, 0x11

    aput v7, v5, v6

    const/16 v6, 0x53

    const/16 v7, 0x12

    aput v7, v5, v6

    const/16 v6, 0x54

    const/16 v7, 0x13

    aput v7, v5, v6

    const/16 v6, 0x55

    const/16 v7, 0x14

    aput v7, v5, v6

    const/16 v6, 0x56

    const/16 v7, 0x15

    aput v7, v5, v6

    const/16 v6, 0x57

    const/16 v7, 0x16

    aput v7, v5, v6

    const/16 v6, 0x58

    const/16 v7, 0x17

    aput v7, v5, v6

    const/16 v6, 0x59

    const/16 v7, 0x18

    aput v7, v5, v6

    const/16 v6, 0x5a

    const/16 v7, 0x19

    aput v7, v5, v6

    const/16 v6, 0x5b

    aput v8, v5, v6

    const/16 v6, 0x5c

    aput v8, v5, v6

    const/16 v6, 0x5d

    aput v8, v5, v6

    const/16 v6, 0x5e

    aput v8, v5, v6

    const/16 v6, 0x5f

    aput v8, v5, v6

    const/16 v6, 0x60

    aput v8, v5, v6

    const/16 v6, 0x61

    const/16 v7, 0x1a

    aput v7, v5, v6

    const/16 v6, 0x62

    .line 55
    const/16 v7, 0x1b

    aput v7, v5, v6

    const/16 v6, 0x63

    const/16 v7, 0x1c

    aput v7, v5, v6

    const/16 v6, 0x64

    const/16 v7, 0x1d

    aput v7, v5, v6

    const/16 v6, 0x65

    const/16 v7, 0x1e

    aput v7, v5, v6

    const/16 v6, 0x66

    const/16 v7, 0x1f

    aput v7, v5, v6

    const/16 v6, 0x67

    const/16 v7, 0x20

    aput v7, v5, v6

    const/16 v6, 0x68

    const/16 v7, 0x21

    aput v7, v5, v6

    const/16 v6, 0x69

    const/16 v7, 0x22

    aput v7, v5, v6

    const/16 v6, 0x6a

    const/16 v7, 0x23

    aput v7, v5, v6

    const/16 v6, 0x6b

    const/16 v7, 0x24

    aput v7, v5, v6

    const/16 v6, 0x6c

    const/16 v7, 0x25

    aput v7, v5, v6

    const/16 v6, 0x6d

    const/16 v7, 0x26

    aput v7, v5, v6

    const/16 v6, 0x6e

    const/16 v7, 0x27

    aput v7, v5, v6

    const/16 v6, 0x6f

    const/16 v7, 0x28

    aput v7, v5, v6

    const/16 v6, 0x70

    const/16 v7, 0x29

    aput v7, v5, v6

    const/16 v6, 0x71

    const/16 v7, 0x2a

    aput v7, v5, v6

    const/16 v6, 0x72

    const/16 v7, 0x2b

    aput v7, v5, v6

    const/16 v6, 0x73

    const/16 v7, 0x2c

    aput v7, v5, v6

    const/16 v6, 0x74

    const/16 v7, 0x2d

    aput v7, v5, v6

    const/16 v6, 0x75

    const/16 v7, 0x2e

    aput v7, v5, v6

    const/16 v6, 0x76

    const/16 v7, 0x2f

    aput v7, v5, v6

    const/16 v6, 0x77

    const/16 v7, 0x30

    aput v7, v5, v6

    const/16 v6, 0x78

    const/16 v7, 0x31

    aput v7, v5, v6

    const/16 v6, 0x79

    const/16 v7, 0x32

    aput v7, v5, v6

    const/16 v6, 0x7a

    .line 56
    const/16 v7, 0x33

    aput v7, v5, v6

    const/16 v6, 0x7b

    aput v8, v5, v6

    const/16 v6, 0x7c

    aput v8, v5, v6

    const/16 v6, 0x7d

    aput v8, v5, v6

    const/16 v6, 0x7e

    aput v8, v5, v6

    const/16 v6, 0x7f

    aput v8, v5, v6

    const/16 v6, 0x80

    aput v8, v5, v6

    const/16 v6, 0x81

    aput v8, v5, v6

    const/16 v6, 0x82

    aput v8, v5, v6

    const/16 v6, 0x83

    aput v8, v5, v6

    const/16 v6, 0x84

    aput v8, v5, v6

    const/16 v6, 0x85

    aput v8, v5, v6

    const/16 v6, 0x86

    aput v8, v5, v6

    const/16 v6, 0x87

    aput v8, v5, v6

    const/16 v6, 0x88

    aput v8, v5, v6

    const/16 v6, 0x89

    aput v8, v5, v6

    const/16 v6, 0x8a

    aput v8, v5, v6

    const/16 v6, 0x8b

    aput v8, v5, v6

    const/16 v6, 0x8c

    aput v8, v5, v6

    const/16 v6, 0x8d

    aput v8, v5, v6

    const/16 v6, 0x8e

    aput v8, v5, v6

    const/16 v6, 0x8f

    aput v8, v5, v6

    const/16 v6, 0x90

    aput v8, v5, v6

    const/16 v6, 0x91

    aput v8, v5, v6

    const/16 v6, 0x92

    .line 57
    aput v8, v5, v6

    const/16 v6, 0x93

    aput v8, v5, v6

    const/16 v6, 0x94

    aput v8, v5, v6

    const/16 v6, 0x95

    aput v8, v5, v6

    const/16 v6, 0x96

    aput v8, v5, v6

    const/16 v6, 0x97

    aput v8, v5, v6

    const/16 v6, 0x98

    aput v8, v5, v6

    const/16 v6, 0x99

    aput v8, v5, v6

    const/16 v6, 0x9a

    aput v8, v5, v6

    const/16 v6, 0x9b

    aput v8, v5, v6

    const/16 v6, 0x9c

    aput v8, v5, v6

    const/16 v6, 0x9d

    aput v8, v5, v6

    const/16 v6, 0x9e

    aput v8, v5, v6

    const/16 v6, 0x9f

    aput v8, v5, v6

    const/16 v6, 0xa0

    aput v8, v5, v6

    const/16 v6, 0xa1

    aput v8, v5, v6

    const/16 v6, 0xa2

    aput v8, v5, v6

    const/16 v6, 0xa3

    aput v8, v5, v6

    const/16 v6, 0xa4

    aput v8, v5, v6

    const/16 v6, 0xa5

    aput v8, v5, v6

    const/16 v6, 0xa6

    aput v8, v5, v6

    const/16 v6, 0xa7

    aput v8, v5, v6

    const/16 v6, 0xa8

    aput v8, v5, v6

    const/16 v6, 0xa9

    aput v8, v5, v6

    const/16 v6, 0xaa

    .line 58
    aput v8, v5, v6

    const/16 v6, 0xab

    aput v8, v5, v6

    const/16 v6, 0xac

    aput v8, v5, v6

    const/16 v6, 0xad

    aput v8, v5, v6

    const/16 v6, 0xae

    aput v8, v5, v6

    const/16 v6, 0xaf

    aput v8, v5, v6

    const/16 v6, 0xb0

    aput v8, v5, v6

    const/16 v6, 0xb1

    aput v8, v5, v6

    const/16 v6, 0xb2

    aput v8, v5, v6

    const/16 v6, 0xb3

    aput v8, v5, v6

    const/16 v6, 0xb4

    aput v8, v5, v6

    const/16 v6, 0xb5

    aput v8, v5, v6

    const/16 v6, 0xb6

    aput v8, v5, v6

    const/16 v6, 0xb7

    aput v8, v5, v6

    const/16 v6, 0xb8

    aput v8, v5, v6

    const/16 v6, 0xb9

    aput v8, v5, v6

    const/16 v6, 0xba

    aput v8, v5, v6

    const/16 v6, 0xbb

    aput v8, v5, v6

    const/16 v6, 0xbc

    aput v8, v5, v6

    const/16 v6, 0xbd

    aput v8, v5, v6

    const/16 v6, 0xbe

    aput v8, v5, v6

    const/16 v6, 0xbf

    aput v8, v5, v6

    const/16 v6, 0xc0

    aput v8, v5, v6

    const/16 v6, 0xc1

    aput v8, v5, v6

    const/16 v6, 0xc2

    .line 59
    aput v8, v5, v6

    const/16 v6, 0xc3

    aput v8, v5, v6

    const/16 v6, 0xc4

    aput v8, v5, v6

    const/16 v6, 0xc5

    aput v8, v5, v6

    const/16 v6, 0xc6

    aput v8, v5, v6

    const/16 v6, 0xc7

    aput v8, v5, v6

    const/16 v6, 0xc8

    aput v8, v5, v6

    const/16 v6, 0xc9

    aput v8, v5, v6

    const/16 v6, 0xca

    aput v8, v5, v6

    const/16 v6, 0xcb

    aput v8, v5, v6

    const/16 v6, 0xcc

    aput v8, v5, v6

    const/16 v6, 0xcd

    aput v8, v5, v6

    const/16 v6, 0xce

    aput v8, v5, v6

    const/16 v6, 0xcf

    aput v8, v5, v6

    const/16 v6, 0xd0

    aput v8, v5, v6

    const/16 v6, 0xd1

    aput v8, v5, v6

    const/16 v6, 0xd2

    aput v8, v5, v6

    const/16 v6, 0xd3

    aput v8, v5, v6

    const/16 v6, 0xd4

    aput v8, v5, v6

    const/16 v6, 0xd5

    aput v8, v5, v6

    const/16 v6, 0xd6

    aput v8, v5, v6

    const/16 v6, 0xd7

    aput v8, v5, v6

    const/16 v6, 0xd8

    aput v8, v5, v6

    const/16 v6, 0xd9

    aput v8, v5, v6

    const/16 v6, 0xda

    .line 60
    aput v8, v5, v6

    const/16 v6, 0xdb

    aput v8, v5, v6

    const/16 v6, 0xdc

    aput v8, v5, v6

    const/16 v6, 0xdd

    aput v8, v5, v6

    const/16 v6, 0xde

    aput v8, v5, v6

    const/16 v6, 0xdf

    aput v8, v5, v6

    const/16 v6, 0xe0

    aput v8, v5, v6

    const/16 v6, 0xe1

    aput v8, v5, v6

    const/16 v6, 0xe2

    aput v8, v5, v6

    const/16 v6, 0xe3

    aput v8, v5, v6

    const/16 v6, 0xe4

    aput v8, v5, v6

    const/16 v6, 0xe5

    aput v8, v5, v6

    const/16 v6, 0xe6

    aput v8, v5, v6

    const/16 v6, 0xe7

    aput v8, v5, v6

    const/16 v6, 0xe8

    aput v8, v5, v6

    const/16 v6, 0xe9

    aput v8, v5, v6

    const/16 v6, 0xea

    aput v8, v5, v6

    const/16 v6, 0xeb

    aput v8, v5, v6

    const/16 v6, 0xec

    aput v8, v5, v6

    const/16 v6, 0xed

    aput v8, v5, v6

    const/16 v6, 0xee

    aput v8, v5, v6

    const/16 v6, 0xef

    aput v8, v5, v6

    const/16 v6, 0xf0

    aput v8, v5, v6

    const/16 v6, 0xf1

    aput v8, v5, v6

    const/16 v6, 0xf2

    .line 61
    aput v8, v5, v6

    const/16 v6, 0xf3

    aput v8, v5, v6

    const/16 v6, 0xf4

    aput v8, v5, v6

    const/16 v6, 0xf5

    aput v8, v5, v6

    const/16 v6, 0xf6

    aput v8, v5, v6

    const/16 v6, 0xf7

    aput v8, v5, v6

    const/16 v6, 0xf8

    aput v8, v5, v6

    const/16 v6, 0xf9

    aput v8, v5, v6

    const/16 v6, 0xfa

    aput v8, v5, v6

    const/16 v6, 0xfb

    aput v8, v5, v6

    const/16 v6, 0xfc

    aput v8, v5, v6

    const/16 v6, 0xfd

    aput v8, v5, v6

    const/16 v6, 0xfe

    aput v8, v5, v6

    .line 63
    .local v5, table:[I
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    .line 65
    .local v2, bytes:[B
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 66
    .local v1, buffer:Ljava/lang/StringBuilder;
    const/4 v4, 0x0

    .local v4, i:I
    :goto_0
    array-length v6, v2

    if-lt v4, v6, :cond_0

    .line 95
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->getBytes()[B

    move-result-object v6

    return-object v6

    .line 67
    :cond_0
    const/4 v0, 0x0

    .line 68
    .local v0, b:I
    aget-byte v6, v2, v4

    aget v6, v5, v6

    if-eq v6, v8, :cond_4

    .line 69
    aget-byte v6, v2, v4

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v0, v6, 0x12

    .line 76
    add-int/lit8 v6, v4, 0x1

    array-length v7, v2

    if-ge v6, v7, :cond_1

    add-int/lit8 v6, v4, 0x1

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_1

    .line 77
    add-int/lit8 v6, v4, 0x1

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0xc

    or-int/2addr v0, v6

    .line 79
    :cond_1
    add-int/lit8 v6, v4, 0x2

    array-length v7, v2

    if-ge v6, v7, :cond_2

    add-int/lit8 v6, v4, 0x2

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_2

    .line 80
    add-int/lit8 v6, v4, 0x2

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x6

    or-int/2addr v0, v6

    .line 82
    :cond_2
    add-int/lit8 v6, v4, 0x3

    array-length v7, v2

    if-ge v6, v7, :cond_3

    add-int/lit8 v6, v4, 0x3

    aget-byte v6, v2, v6

    aget v6, v5, v6

    if-eq v6, v8, :cond_3

    .line 83
    add-int/lit8 v6, v4, 0x3

    aget-byte v6, v2, v6

    aget v6, v5, v6

    and-int/lit16 v6, v6, 0xff

    or-int/2addr v0, v6

    .line 86
    :cond_3
    :goto_1
    const v6, 0xffffff

    and-int/2addr v6, v0

    if-nez v6, :cond_5

    .line 92
    add-int/lit8 v4, v4, 0x4

    goto :goto_0

    .line 72
    :cond_4
    add-int/lit8 v4, v4, 0x1

    .line 73
    goto :goto_0

    .line 87
    :cond_5
    const/high16 v6, 0xff

    and-int/2addr v6, v0

    shr-int/lit8 v3, v6, 0x10

    .line 88
    .local v3, c:I
    int-to-char v6, v3

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 89
    shl-int/lit8 v0, v0, 0x8

    goto :goto_1
.end method

.method public static encode([B)Ljava/lang/String;
    .locals 10
    .parameter "data"

    .prologue
    const v9, 0xffffff

    .line 12
    const/16 v7, 0x40

    new-array v6, v7, [C

    fill-array-data v6, :array_0

    .line 17
    .local v6, table:[C
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 18
    .local v1, buffer:Ljava/lang/StringBuilder;
    const/4 v5, 0x0

    .line 19
    .local v5, pad:I
    const/4 v3, 0x0

    .local v3, i:I
    :goto_0
    array-length v7, p0

    if-lt v3, v7, :cond_0

    .line 43
    const/4 v4, 0x0

    .local v4, j:I
    :goto_1
    if-lt v4, v5, :cond_5

    .line 47
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    return-object v7

    .line 20
    .end local v4           #j:I
    :cond_0
    aget-byte v7, p0, v3

    and-int/lit16 v7, v7, 0xff

    shl-int/lit8 v7, v7, 0x10

    and-int v0, v7, v9

    .line 21
    .local v0, b:I
    add-int/lit8 v7, v3, 0x1

    array-length v8, p0

    if-ge v7, v8, :cond_2

    .line 22
    add-int/lit8 v7, v3, 0x1

    aget-byte v7, p0, v7

    and-int/lit16 v7, v7, 0xff

    shl-int/lit8 v7, v7, 0x8

    or-int/2addr v0, v7

    .line 26
    :goto_2
    add-int/lit8 v7, v3, 0x2

    array-length v8, p0

    if-ge v7, v8, :cond_3

    .line 27
    add-int/lit8 v7, v3, 0x2

    aget-byte v7, p0, v7

    and-int/lit16 v7, v7, 0xff

    or-int/2addr v0, v7

    .line 32
    :goto_3
    rem-int/lit8 v7, v3, 0x39

    if-nez v7, :cond_1

    if-lez v3, :cond_1

    .line 33
    const-string v7, "\n"

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 36
    :cond_1
    :goto_4
    and-int v7, v0, v9

    if-nez v7, :cond_4

    .line 19
    add-int/lit8 v3, v3, 0x3

    goto :goto_0

    .line 24
    :cond_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 29
    :cond_3
    add-int/lit8 v5, v5, 0x1

    goto :goto_3

    .line 37
    :cond_4
    const/high16 v7, 0xfc

    and-int/2addr v7, v0

    shr-int/lit8 v2, v7, 0x12

    .line 38
    .local v2, c:I
    aget-char v7, v6, v2

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 39
    shl-int/lit8 v0, v0, 0x6

    goto :goto_4

    .line 44
    .end local v0           #b:I
    .end local v2           #c:I
    .restart local v4       #j:I
    :cond_5
    const-string v7, "="

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 43
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 12
    nop

    :array_0
    .array-data 0x2
        0x41t 0x0t
        0x42t 0x0t
        0x43t 0x0t
        0x44t 0x0t
        0x45t 0x0t
        0x46t 0x0t
        0x47t 0x0t
        0x48t 0x0t
        0x49t 0x0t
        0x4at 0x0t
        0x4bt 0x0t
        0x4ct 0x0t
        0x4dt 0x0t
        0x4et 0x0t
        0x4ft 0x0t
        0x50t 0x0t
        0x51t 0x0t
        0x52t 0x0t
        0x53t 0x0t
        0x54t 0x0t
        0x55t 0x0t
        0x56t 0x0t
        0x57t 0x0t
        0x58t 0x0t
        0x59t 0x0t
        0x5at 0x0t
        0x61t 0x0t
        0x62t 0x0t
        0x63t 0x0t
        0x64t 0x0t
        0x65t 0x0t
        0x66t 0x0t
        0x67t 0x0t
        0x68t 0x0t
        0x69t 0x0t
        0x6at 0x0t
        0x6bt 0x0t
        0x6ct 0x0t
        0x6dt 0x0t
        0x6et 0x0t
        0x6ft 0x0t
        0x70t 0x0t
        0x71t 0x0t
        0x72t 0x0t
        0x73t 0x0t
        0x74t 0x0t
        0x75t 0x0t
        0x76t 0x0t
        0x77t 0x0t
        0x78t 0x0t
        0x79t 0x0t
        0x7at 0x0t
        0x30t 0x0t
        0x31t 0x0t
        0x32t 0x0t
        0x33t 0x0t
        0x34t 0x0t
        0x35t 0x0t
        0x36t 0x0t
        0x37t 0x0t
        0x38t 0x0t
        0x39t 0x0t
        0x2bt 0x0t
        0x2ft 0x0t
    .end array-data
.end method

.method public static md5(Ljava/io/File;)Ljava/lang/String;
    .locals 8
    .parameter "f"

    .prologue
    .line 99
    const/4 v5, 0x0

    .line 100
    .local v5, md:Ljava/security/MessageDigest;
    const/4 v3, 0x0

    .line 102
    .local v3, is:Ljava/io/InputStream;
    :try_start_0
    const-string v6, "MD5"

    invoke-static {v6}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v5

    .line 103
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 104
    .end local v3           #is:Ljava/io/InputStream;
    .local v4, is:Ljava/io/InputStream;
    :try_start_1
    new-instance v3, Ljava/security/DigestInputStream;

    invoke-direct {v3, v4, v5}, Ljava/security/DigestInputStream;-><init>(Ljava/io/InputStream;Ljava/security/MessageDigest;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_4

    .line 105
    .end local v4           #is:Ljava/io/InputStream;
    .restart local v3       #is:Ljava/io/InputStream;
    const/16 v6, 0x2000

    :try_start_2
    new-array v0, v6, [B

    .line 106
    .local v0, buffer:[B
    :cond_0
    invoke-virtual {v3, v0}, Ljava/io/InputStream;->read([B)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    move-result v6

    const/4 v7, -0x1

    if-ne v6, v7, :cond_0

    .line 112
    :try_start_3
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_3

    .line 118
    .end local v0           #buffer:[B
    :goto_0
    invoke-virtual {v5}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v1

    .line 119
    .local v1, digest:[B
    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    return-object v6

    .line 108
    .end local v1           #digest:[B
    :catch_0
    move-exception v2

    .line 109
    .local v2, e:Ljava/lang/Exception;
    :goto_1
    :try_start_4
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 112
    :try_start_5
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_1

    goto :goto_0

    .line 113
    :catch_1
    move-exception v2

    .line 114
    .local v2, e:Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 110
    .end local v2           #e:Ljava/io/IOException;
    :catchall_0
    move-exception v6

    .line 112
    :goto_2
    :try_start_6
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_2

    .line 116
    :goto_3
    throw v6

    .line 113
    :catch_2
    move-exception v2

    .line 114
    .restart local v2       #e:Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_3

    .line 113
    .end local v2           #e:Ljava/io/IOException;
    .restart local v0       #buffer:[B
    :catch_3
    move-exception v2

    .line 114
    .restart local v2       #e:Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 110
    .end local v0           #buffer:[B
    .end local v2           #e:Ljava/io/IOException;
    .end local v3           #is:Ljava/io/InputStream;
    .restart local v4       #is:Ljava/io/InputStream;
    :catchall_1
    move-exception v6

    move-object v3, v4

    .end local v4           #is:Ljava/io/InputStream;
    .restart local v3       #is:Ljava/io/InputStream;
    goto :goto_2

    .line 108
    .end local v3           #is:Ljava/io/InputStream;
    .restart local v4       #is:Ljava/io/InputStream;
    :catch_4
    move-exception v2

    move-object v3, v4

    .end local v4           #is:Ljava/io/InputStream;
    .restart local v3       #is:Ljava/io/InputStream;
    goto :goto_1
.end method
