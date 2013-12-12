.class public Lhooks/ReflectedInvoke;
.super Ljava/lang/Object;
.source "ReflectedInvoke.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 63
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static invokeHook(Ljava/lang/reflect/Method;Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    .locals 18
    .param p0, "method"    # Ljava/lang/reflect/Method;
    .param p1, "receiver"    # Ljava/lang/Object;
    .param p2, "args"    # [Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 67
    const-string v3, "unknown-static"

    .line 68
    .local v3, "className":Ljava/lang/String;
    invoke-virtual/range {p0 .. p0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    .line 69
    .local v7, "methodName":Ljava/lang/String;
    if-eqz p1, :cond_5

    .line 70
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    .line 77
    :goto_0
    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "Invoke hook: "

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v13, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    const-string v14, "."

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    .line 78
    const-string v14, "("

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    .line 77
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 79
    .local v6, "logStr":Ljava/lang/String;
    if-eqz p2, :cond_1

    .line 80
    const-string v2, ""

    .line 81
    .local v2, "argStr":Ljava/lang/String;
    move-object/from16 v0, p2

    array-length v14, v0

    const/4 v13, 0x0

    :goto_1
    if-lt v13, v14, :cond_6

    .line 86
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v13

    const/4 v14, 0x2

    if-lt v13, v14, :cond_0

    .line 87
    const/4 v13, 0x0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v14

    add-int/lit8 v14, v14, -0x2

    invoke-virtual {v2, v13, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 89
    :cond_0
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v13, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 92
    .end local v2    # "argStr":Ljava/lang/String;
    :cond_1
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v14, ")"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 93
    if-eqz p1, :cond_2

    .line 94
    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "  receiver: "

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 99
    :cond_2
    new-instance v11, Ljava/lang/Throwable;

    invoke-direct {v11}, Ljava/lang/Throwable;-><init>()V

    .line 100
    .local v11, "t":Ljava/lang/Throwable;
    invoke-virtual {v11}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v12

    .line 101
    .local v12, "trace":[Ljava/lang/StackTraceElement;
    array-length v13, v12

    add-int/lit8 v13, v13, -0x1

    new-array v8, v13, [Ljava/lang/StackTraceElement;

    .line 102
    .local v8, "newTrace":[Ljava/lang/StackTraceElement;
    const/4 v13, 0x1

    const/4 v14, 0x0

    array-length v15, v8

    invoke-static {v12, v13, v8, v14, v15}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 105
    const-string v13, "android.app.ContextImpl$ApplicationPackageManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_3

    .line 107
    const-string v13, "android.app.ApplicationContext$ApplicationPackageManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_3

    .line 108
    const-string v13, "android.content.pm.PackageManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_3

    .line 109
    const-string v13, "android."

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_d

    .line 110
    const-string v13, "ApplicationPackageManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v13

    if-eqz v13, :cond_d

    .line 111
    :cond_3
    const-string v13, "getInstallerPackageName"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_8

    .line 114
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    .line 113
    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->getInstallerPackageName(Landroid/content/pm/PackageManager;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 314
    :cond_4
    :goto_2
    return-object v9

    .line 73
    .end local v6    # "logStr":Ljava/lang/String;
    .end local v8    # "newTrace":[Ljava/lang/StackTraceElement;
    .end local v11    # "t":Ljava/lang/Throwable;
    .end local v12    # "trace":[Ljava/lang/StackTraceElement;
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_5
    invoke-virtual/range {p0 .. p0}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_0

    .line 81
    .restart local v2    # "argStr":Ljava/lang/String;
    .restart local v6    # "logStr":Ljava/lang/String;
    :cond_6
    aget-object v1, p2, v13

    .line 82
    .local v1, "arg":Ljava/lang/Object;
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v16

    invoke-direct/range {v15 .. v16}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v1, :cond_7

    .line 83
    .end local v1    # "arg":Ljava/lang/Object;
    :goto_3
    invoke-virtual {v15, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v15

    .line 82
    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 81
    add-int/lit8 v13, v13, 0x1

    goto/16 :goto_1

    .line 82
    .restart local v1    # "arg":Ljava/lang/Object;
    :cond_7
    new-instance v16, Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v17

    invoke-static/range {v17 .. v17}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v17

    invoke-direct/range {v16 .. v17}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 83
    const-string v17, ":"

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, ", "

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    invoke-virtual/range {v16 .. v16}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_3

    .line 116
    .end local v1    # "arg":Ljava/lang/Object;
    .end local v2    # "argStr":Ljava/lang/String;
    .restart local v8    # "newTrace":[Ljava/lang/StackTraceElement;
    .restart local v11    # "t":Ljava/lang/Throwable;
    .restart local v12    # "trace":[Ljava/lang/StackTraceElement;
    :cond_8
    const-string v13, "getPackageInfo"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_a

    .line 118
    const/4 v13, 0x1

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/Integer;

    invoke-virtual {v13}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 120
    .local v5, "flags":I
    const-string v13, "android.content.pm.PackageManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_9

    .line 121
    check-cast p1, Landroid/content/pm/PackageManager;

    .line 122
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    .line 121
    move-object/from16 v0, p1

    invoke-static {v0, v13, v5}, Lhooks/Monolith;->getPackageInfo(Landroid/content/pm/PackageManager;Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v9

    goto :goto_2

    .line 128
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_9
    const/4 v9, 0x0

    .line 130
    .local v9, "result":Ljava/lang/Object;
    :try_start_0
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v9

    .line 146
    and-int/lit8 v13, v5, 0x40

    const/16 v14, 0x40

    if-ne v13, v14, :cond_4

    .line 147
    invoke-static {}, Lhooks/Monolith;->spoofSignatures()[Landroid/content/pm/Signature;

    move-result-object v10

    .line 148
    .local v10, "spoofSigs":[Landroid/content/pm/Signature;
    const/4 v14, 0x0

    move-object v13, v9

    .line 149
    check-cast v13, Landroid/content/pm/PackageInfo;

    iget-object v15, v13, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    const/16 v16, 0x0

    move-object v13, v9

    .line 150
    check-cast v13, Landroid/content/pm/PackageInfo;

    iget-object v13, v13, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    array-length v13, v13

    .line 148
    move/from16 v0, v16

    invoke-static {v10, v14, v15, v0, v13}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 151
    new-instance v14, Ljava/lang/StringBuilder;

    const-string v13, "  spoofing "

    invoke-direct {v14, v13}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move-object v13, v9

    .line 152
    check-cast v13, Landroid/content/pm/PackageInfo;

    iget-object v13, v13, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v13

    .line 153
    const-string v14, " signatures for "

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v14

    move-object v13, v9

    .line 154
    check-cast v13, Landroid/content/pm/PackageInfo;

    iget-object v13, v13, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    .line 151
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto/16 :goto_2

    .line 132
    .end local v10    # "spoofSigs":[Landroid/content/pm/Signature;
    :catch_0
    move-exception v4

    .line 140
    .local v4, "e":Ljava/lang/Exception;
    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "  invoke failed with "

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 142
    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "    going to return exception:"

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 143
    throw v4

    .line 159
    .end local v4    # "e":Ljava/lang/Exception;
    .end local v5    # "flags":I
    .end local v9    # "result":Ljava/lang/Object;
    :cond_a
    const-string v13, "getApplicationEnabledSetting"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_b

    .line 161
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    .line 160
    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->getApplicationEnabledSetting(Landroid/content/pm/PackageManager;Ljava/lang/String;)I

    move-result v9

    .line 162
    .local v9, "result":I
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    goto/16 :goto_2

    .line 164
    .end local v9    # "result":I
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_b
    const-string v13, "checkSignatures"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 168
    const/4 v13, 0x0

    aget-object v13, p2, v13

    invoke-virtual {v13}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v13

    const-class v14, Ljava/lang/String;

    invoke-virtual {v13, v14}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_c

    .line 169
    check-cast p1, Landroid/content/pm/PackageManager;

    .line 170
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    const/4 v14, 0x1

    aget-object v14, p2, v14

    check-cast v14, Ljava/lang/String;

    .line 169
    move-object/from16 v0, p1

    invoke-static {v0, v13, v14}, Lhooks/Monolith;->checkSignatures(Landroid/content/pm/PackageManager;Ljava/lang/String;Ljava/lang/String;)I

    move-result v13

    invoke-static {v13}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    goto/16 :goto_2

    .line 173
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_c
    check-cast p1, Landroid/content/pm/PackageManager;

    .line 174
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/Integer;

    invoke-virtual {v13}, Ljava/lang/Integer;->intValue()I

    move-result v14

    .line 175
    const/4 v13, 0x1

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/Integer;

    invoke-virtual {v13}, Ljava/lang/Integer;->intValue()I

    move-result v13

    .line 173
    move-object/from16 v0, p1

    invoke-static {v0, v14, v13}, Lhooks/Monolith;->checkSignatures(Landroid/content/pm/PackageManager;II)I

    move-result v13

    invoke-static {v13}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    goto/16 :goto_2

    .line 180
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_d
    const-string v13, "jce.provider.JDKDigestSignature"

    invoke-virtual {v3, v13}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v13

    if-eqz v13, :cond_10

    .line 183
    const-string v13, "initVerify"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_e

    .line 184
    const/4 v9, 0x0

    goto/16 :goto_2

    .line 186
    :cond_e
    const-string v13, "update"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_f

    .line 187
    const/4 v9, 0x0

    goto/16 :goto_2

    .line 189
    :cond_f
    const-string v13, "verify"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    const/4 v13, 0x1

    invoke-static {v13}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v9

    goto/16 :goto_2

    .line 191
    :cond_10
    const-string v13, "java.io.File"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_12

    move-object/from16 v13, p1

    .line 192
    check-cast v13, Ljava/io/File;

    invoke-static {v13}, Lhooks/Monolith;->isThisApk(Ljava/io/File;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 193
    const-string v13, "length"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_11

    .line 194
    check-cast p1, Ljava/io/File;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->length(Ljava/io/File;)J

    move-result-wide v13

    invoke-static {v13, v14}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v9

    goto/16 :goto_2

    .line 196
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_11
    const-string v13, "lastModified"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 197
    check-cast p1, Ljava/io/File;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->lastModified(Ljava/io/File;)J

    move-result-wide v13

    invoke-static {v13, v14}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v9

    goto/16 :goto_2

    .line 200
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_12
    const-string v13, "android.content.Context"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_13

    .line 201
    const-string v13, "getApplicationInfo"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 202
    check-cast p1, Landroid/content/Context;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->getApplicationInfo(Landroid/content/Context;)Landroid/content/pm/ApplicationInfo;

    move-result-object v9

    goto/16 :goto_2

    .line 204
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_13
    const-string v13, "android.os.Debug"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_14

    .line 205
    const-string v13, "isDebuggerConnected"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 206
    invoke-static {}, Lhooks/Monolith;->isDebuggerConnected()Z

    move-result v13

    invoke-static {v13}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v9

    goto/16 :goto_2

    .line 208
    :cond_14
    const-string v13, "java.security.Signature"

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_1a

    .line 209
    const-string v13, "java.security.Signature"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_16

    .line 210
    const-string v13, "verify"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 211
    move-object/from16 v0, p2

    array-length v13, v0

    const/4 v14, 0x4

    if-ne v13, v14, :cond_15

    .line 213
    check-cast p1, Ljava/security/Signature;

    .line 214
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, [B

    const/4 v14, 0x1

    aget-object v14, p2, v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v15

    .line 215
    const/4 v14, 0x2

    aget-object v14, p2, v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v14

    .line 212
    move-object/from16 v0, p1

    invoke-static {v0, v13, v15, v14}, Lhooks/Monolith;->signatureVerify(Ljava/security/Signature;[BII)Z

    move-result v13

    invoke-static {v13}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v9

    goto/16 :goto_2

    .line 217
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_15
    move-object/from16 v0, p2

    array-length v13, v0

    const/4 v14, 0x1

    if-ne v13, v14, :cond_18

    .line 219
    check-cast p1, Ljava/security/Signature;

    .line 220
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, [B

    .line 218
    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->signatureVerify(Ljava/security/Signature;[B)Z

    move-result v13

    invoke-static {v13}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v9

    goto/16 :goto_2

    .line 223
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_16
    const-string v13, "java.security.MessageDigest"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 224
    const-string v13, "update"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_19

    .line 225
    sget-boolean v13, Lhooks/Monolith;->BuildingDigest:Z

    if-nez v13, :cond_17

    .line 226
    const-string v13, "  building message digest"

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 229
    :cond_17
    const/4 v13, 0x1

    sput-boolean v13, Lhooks/Monolith;->BuildingDigest:Z

    .line 313
    :cond_18
    const-string v13, "  hook not handled, invoke normally."

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 314
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    goto/16 :goto_2

    .line 233
    :cond_19
    const-string v13, "digest"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 234
    check-cast p1, Ljava/security/MessageDigest;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofDigest(Ljava/security/MessageDigest;)[B

    move-result-object v9

    goto/16 :goto_2

    .line 238
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1a
    const-string v13, "org.apache.harmony.xnet.provider.jsse.OpenSSLMessageDigestJDK$"

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_1b

    .line 239
    invoke-static {}, Ljava/lang/Thread;->dumpStack()V

    .line 241
    const-string v13, "digest"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 242
    check-cast p1, Ljava/security/MessageDigest;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofDigest(Ljava/security/MessageDigest;)[B

    move-result-object v9

    goto/16 :goto_2

    .line 244
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1b
    const-string v13, "android.telephony.TelephonyManager"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_1c

    .line 245
    const-string v13, "getDeviceId"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 246
    const-string v13, "  invoking getDeviceId()"

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 247
    invoke-static {}, Lhooks/Monolith;->getDeviceId()Ljava/lang/String;

    move-result-object v9

    goto/16 :goto_2

    .line 250
    :cond_1c
    move-object/from16 v0, p1

    instance-of v13, v0, Ljava/lang/Throwable;

    if-eqz v13, :cond_1e

    .line 251
    const-string v13, "fillInStackTrace"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_1d

    .line 252
    const-string v13, "  invoking fillInStackTrace normally then scrubbing"

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 253
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 254
    check-cast p1, Ljava/lang/Throwable;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->setStackTrace(Ljava/lang/Throwable;)V

    .line 255
    const/4 v9, 0x0

    goto/16 :goto_2

    .line 257
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1d
    const-string v13, "printStackTrace"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 258
    check-cast p1, Ljava/lang/Throwable;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->throwablePrintStackTrace(Ljava/lang/Throwable;)V

    .line 259
    const/4 v9, 0x0

    goto/16 :goto_2

    .line 262
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1e
    const-string v13, "java.lang."

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_22

    .line 263
    const-string v13, "java.lang.Thread"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_20

    .line 264
    const-string v13, "dumpStack"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_1f

    .line 265
    const-string v13, "  running threadDumpStack()"

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 266
    invoke-static {}, Lhooks/Monolith;->threadDumpStack()V

    .line 267
    const/4 v9, 0x0

    goto/16 :goto_2

    .line 269
    :cond_1f
    const-string v13, "getStackTrace"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 270
    check-cast p1, Ljava/lang/Thread;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->threadGetStackTrace(Ljava/lang/Thread;)[Ljava/lang/StackTraceElement;

    move-result-object v9

    goto/16 :goto_2

    .line 272
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_20
    const-string v13, "java.lang.reflect.Method"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_21

    .line 273
    const-string v13, "invoke"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 274
    const-string v13, "  invoking an invoke! sneaky sneaky :D!"

    invoke-static {v13}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 275
    check-cast p1, Ljava/lang/reflect/Method;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v14, p2, v13

    .line 276
    const/4 v13, 0x1

    aget-object v13, p2, v13

    check-cast v13, [Ljava/lang/Object;

    .line 275
    move-object/from16 v0, p1

    invoke-static {v0, v14, v13}, Lhooks/ReflectedInvoke;->invokeHook(Ljava/lang/reflect/Method;Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    goto/16 :goto_2

    .line 279
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_21
    const-string v13, "java.lang.Runtime"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 280
    const-string v13, "exec"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 281
    check-cast p1, Ljava/lang/Runtime;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    .line 280
    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->runtimeExec(Ljava/lang/Runtime;Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v9

    goto/16 :goto_2

    .line 284
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_22
    const-string v13, "java.util."

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_27

    .line 285
    const-string v13, "java.util.zip.ZipFile"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_23

    .line 286
    const-string v13, "getEntry"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 287
    check-cast p1, Ljava/util/zip/ZipFile;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v9

    goto/16 :goto_2

    .line 289
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_23
    const-string v13, "java.util.jar.JarFile"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_25

    .line 290
    const-string v13, "getEntry"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_24

    .line 291
    check-cast p1, Ljava/util/zip/ZipFile;

    .line 292
    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    .line 291
    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v9

    goto/16 :goto_2

    .line 294
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_24
    const-string v13, "getJarEntry"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 295
    check-cast p1, Ljava/util/jar/JarFile;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    move-object/from16 v0, p1

    invoke-static {v0, v13}, Lhooks/Monolith;->getJarEntry(Ljava/util/jar/JarFile;Ljava/lang/String;)Ljava/util/jar/JarEntry;

    move-result-object v9

    goto/16 :goto_2

    .line 297
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_25
    const-string v13, "java.util.zip.Adler32"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_26

    .line 298
    const-string v13, "java.util.zip.CRC32"

    invoke-virtual {v3, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 299
    :cond_26
    const-string v13, "getValue"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 300
    check-cast p1, Ljava/util/zip/Checksum;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofChecksum(Ljava/util/zip/Checksum;)J

    move-result-wide v13

    invoke-static {v13, v14}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v9

    goto/16 :goto_2

    .line 303
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_27
    const-string v13, "java.lang.reflect.Constructor"

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_28

    .line 304
    const-string v13, "newInstance"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 305
    check-cast p1, Ljava/lang/reflect/Constructor;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p2}, Lhooks/ReflectedConstructor;->constructorNewInstance(Ljava/lang/reflect/Constructor;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    goto/16 :goto_2

    .line 307
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_28
    const-string v13, "dalvik.system.DexFile"

    invoke-virtual {v3, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 308
    const-string v13, "loadDex"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_18

    .line 309
    const/4 v13, 0x0

    aget-object v13, p2, v13

    check-cast v13, Ljava/lang/String;

    const/4 v14, 0x1

    aget-object v14, p2, v14

    check-cast v14, Ljava/lang/String;

    const/4 v15, 0x2

    aget-object v15, p2, v15

    check-cast v15, Ljava/lang/Integer;

    invoke-virtual {v15}, Ljava/lang/Integer;->intValue()I

    move-result v15

    .line 308
    invoke-static {v13, v14, v15}, Lhooks/Monolith;->loadDex(Ljava/lang/String;Ljava/lang/String;I)Ldalvik/system/DexFile;

    move-result-object v9

    goto/16 :goto_2
.end method
