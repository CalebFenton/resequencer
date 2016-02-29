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
    .locals 25
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
    const-string v9, "unknown-static"

    .line 68
    .local v9, "className":Ljava/lang/String;
    invoke-virtual/range {p0 .. p0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v15

    .line 69
    .local v15, "methodName":Ljava/lang/String;
    if-eqz p1, :cond_0

    .line 70
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v9

    .line 77
    :goto_0
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    const-string v22, "Invoke hook: "

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    move-object/from16 v0, v21

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    const-string v22, "."

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    move-object/from16 v0, v21

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    const-string v22, "("

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    .line 79
    .local v14, "logStr":Ljava/lang/String;
    if-eqz p2, :cond_4

    .line 80
    const-string v7, ""

    .line 81
    .local v7, "argStr":Ljava/lang/String;
    move-object/from16 v8, p2

    .local v8, "arr$":[Ljava/lang/Object;
    array-length v13, v8

    .local v13, "len$":I
    const/4 v12, 0x0

    .local v12, "i$":I
    :goto_1
    if-ge v12, v13, :cond_2

    aget-object v6, v8, v12

    .line 82
    .local v6, "arg":Ljava/lang/Object;
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v21

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    if-nez v6, :cond_1

    .end local v6    # "arg":Ljava/lang/Object;
    :goto_2
    move-object/from16 v0, v21

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 81
    add-int/lit8 v12, v12, 0x1

    goto :goto_1

    .line 73
    .end local v7    # "argStr":Ljava/lang/String;
    .end local v8    # "arr$":[Ljava/lang/Object;
    .end local v12    # "i$":I
    .end local v13    # "len$":I
    .end local v14    # "logStr":Ljava/lang/String;
    :cond_0
    invoke-virtual/range {p0 .. p0}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v9

    goto :goto_0

    .line 82
    .restart local v6    # "arg":Ljava/lang/Object;
    .restart local v7    # "argStr":Ljava/lang/String;
    .restart local v8    # "arr$":[Ljava/lang/Object;
    .restart local v12    # "i$":I
    .restart local v13    # "len$":I
    .restart local v14    # "logStr":Ljava/lang/String;
    :cond_1
    new-instance v22, Ljava/lang/StringBuilder;

    invoke-direct/range {v22 .. v22}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v23

    invoke-virtual/range {v22 .. v23}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v22

    const-string v23, ":"

    invoke-virtual/range {v22 .. v23}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v22

    move-object/from16 v0, v22

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v22

    const-string v23, ", "

    invoke-virtual/range {v22 .. v23}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v22

    invoke-virtual/range {v22 .. v22}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    goto :goto_2

    .line 86
    .end local v6    # "arg":Ljava/lang/Object;
    :cond_2
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v21

    const/16 v22, 0x2

    move/from16 v0, v21

    move/from16 v1, v22

    if-lt v0, v1, :cond_3

    .line 87
    const/16 v21, 0x0

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v22

    add-int/lit8 v22, v22, -0x2

    move/from16 v0, v21

    move/from16 v1, v22

    invoke-virtual {v7, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    .line 89
    :cond_3
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v21

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    move-object/from16 v0, v21

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    .line 92
    .end local v7    # "argStr":Ljava/lang/String;
    .end local v8    # "arr$":[Ljava/lang/Object;
    .end local v12    # "i$":I
    .end local v13    # "len$":I
    :cond_4
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v21

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    const-string v22, ")"

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v21

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 93
    if-eqz p1, :cond_5

    .line 94
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    const-string v22, "  receiver: "

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v22

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v21

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 99
    :cond_5
    new-instance v19, Ljava/lang/Throwable;

    invoke-direct/range {v19 .. v19}, Ljava/lang/Throwable;-><init>()V

    .line 100
    .local v19, "t":Ljava/lang/Throwable;
    invoke-virtual/range {v19 .. v19}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v20

    .line 101
    .local v20, "trace":[Ljava/lang/StackTraceElement;
    move-object/from16 v0, v20

    array-length v0, v0

    move/from16 v21, v0

    add-int/lit8 v21, v21, -0x1

    move/from16 v0, v21

    new-array v0, v0, [Ljava/lang/StackTraceElement;

    move-object/from16 v16, v0

    .line 102
    .local v16, "newTrace":[Ljava/lang/StackTraceElement;
    const/16 v21, 0x1

    const/16 v22, 0x0

    move-object/from16 v0, v16

    array-length v0, v0

    move/from16 v23, v0

    move-object/from16 v0, v20

    move/from16 v1, v21

    move-object/from16 v2, v16

    move/from16 v3, v22

    move/from16 v4, v23

    invoke-static {v0, v1, v2, v3, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 104
    const-string v21, "android.app.ContextImpl$ApplicationPackageManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-nez v21, :cond_6

    const-string v21, "android.app.ApplicationContext$ApplicationPackageManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-nez v21, :cond_6

    const-string v21, "android.content.pm.PackageManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-nez v21, :cond_6

    const-string v21, "android."

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_d

    const-string v21, "ApplicationPackageManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v21

    if-eqz v21, :cond_d

    .line 111
    :cond_6
    const-string v21, "getInstallerPackageName"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_8

    .line 113
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->getInstallerPackageName(Landroid/content/pm/PackageManager;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v17

    .line 314
    :cond_7
    :goto_3
    return-object v17

    .line 116
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_8
    const-string v21, "getPackageInfo"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_a

    .line 118
    const/16 v21, 0x1

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/Integer;

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Integer;->intValue()I

    move-result v11

    .line 120
    .local v11, "flags":I
    const-string v21, "android.content.pm.PackageManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_9

    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1, v11}, Lhooks/Monolith;->getPackageInfo(Landroid/content/pm/PackageManager;Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v17

    goto :goto_3

    .line 128
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_9
    const/16 v17, 0x0

    .line 130
    .local v17, "result":Ljava/lang/Object;
    :try_start_0
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v17

    .line 146
    and-int/lit8 v21, v11, 0x40

    const/16 v22, 0x40

    move/from16 v0, v21

    move/from16 v1, v22

    if-ne v0, v1, :cond_7

    .line 147
    invoke-static {}, Lhooks/Monolith;->spoofSignatures()[Landroid/content/pm/Signature;

    move-result-object v18

    .line 148
    .local v18, "spoofSigs":[Landroid/content/pm/Signature;
    const/16 v22, 0x0

    move-object/from16 v21, v17

    check-cast v21, Landroid/content/pm/PackageInfo;

    move-object/from16 v0, v21

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    move-object/from16 v23, v0

    const/16 v24, 0x0

    move-object/from16 v21, v17

    check-cast v21, Landroid/content/pm/PackageInfo;

    move-object/from16 v0, v21

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    move-object/from16 v21, v0

    move-object/from16 v0, v21

    array-length v0, v0

    move/from16 v21, v0

    move-object/from16 v0, v18

    move/from16 v1, v22

    move-object/from16 v2, v23

    move/from16 v3, v24

    move/from16 v4, v21

    invoke-static {v0, v1, v2, v3, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 151
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    const-string v22, "  spoofing "

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v22

    move-object/from16 v21, v17

    check-cast v21, Landroid/content/pm/PackageInfo;

    move-object/from16 v0, v21

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    move-object/from16 v21, v0

    move-object/from16 v0, v22

    move-object/from16 v1, v21

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v21

    const-string v22, " signatures for "

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v22

    move-object/from16 v21, v17

    check-cast v21, Landroid/content/pm/PackageInfo;

    move-object/from16 v0, v21

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    move-object/from16 v21, v0

    move-object/from16 v0, v22

    move-object/from16 v1, v21

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v21

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto/16 :goto_3

    .line 132
    .end local v18    # "spoofSigs":[Landroid/content/pm/Signature;
    :catch_0
    move-exception v10

    .line 140
    .local v10, "e":Ljava/lang/Exception;
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    const-string v22, "  invoke failed with "

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    move-object/from16 v0, v21

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v21

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 142
    new-instance v21, Ljava/lang/StringBuilder;

    invoke-direct/range {v21 .. v21}, Ljava/lang/StringBuilder;-><init>()V

    const-string v22, "    going to return exception:"

    invoke-virtual/range {v21 .. v22}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v21

    move-object/from16 v0, v21

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v21

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 143
    throw v10

    .line 159
    .end local v10    # "e":Ljava/lang/Exception;
    .end local v11    # "flags":I
    .end local v17    # "result":Ljava/lang/Object;
    :cond_a
    const-string v21, "getApplicationEnabledSetting"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_b

    .line 160
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->getApplicationEnabledSetting(Landroid/content/pm/PackageManager;Ljava/lang/String;)I

    move-result v17

    .line 162
    .local v17, "result":I
    invoke-static/range {v17 .. v17}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    goto/16 :goto_3

    .line 164
    .end local v17    # "result":I
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_b
    const-string v21, "checkSignatures"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 168
    const/16 v21, 0x0

    aget-object v21, p2, v21

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v21

    const-class v22, Ljava/lang/String;

    invoke-virtual/range {v21 .. v22}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_c

    .line 169
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    const/16 v22, 0x1

    aget-object v22, p2, v22

    check-cast v22, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    move-object/from16 v2, v22

    invoke-static {v0, v1, v2}, Lhooks/Monolith;->checkSignatures(Landroid/content/pm/PackageManager;Ljava/lang/String;Ljava/lang/String;)I

    move-result v21

    invoke-static/range {v21 .. v21}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    goto/16 :goto_3

    .line 173
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_c
    check-cast p1, Landroid/content/pm/PackageManager;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/Integer;

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Integer;->intValue()I

    move-result v22

    const/16 v21, 0x1

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/Integer;

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Integer;->intValue()I

    move-result v21

    move-object/from16 v0, p1

    move/from16 v1, v22

    move/from16 v2, v21

    invoke-static {v0, v1, v2}, Lhooks/Monolith;->checkSignatures(Landroid/content/pm/PackageManager;II)I

    move-result v21

    invoke-static/range {v21 .. v21}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    goto/16 :goto_3

    .line 180
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_d
    const-string v21, "jce.provider.JDKDigestSignature"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v21

    if-eqz v21, :cond_10

    .line 183
    const-string v21, "initVerify"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_e

    .line 184
    const/16 v17, 0x0

    goto/16 :goto_3

    .line 186
    :cond_e
    const-string v21, "update"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_f

    .line 187
    const/16 v17, 0x0

    goto/16 :goto_3

    .line 189
    :cond_f
    const-string v21, "verify"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    const/16 v21, 0x1

    invoke-static/range {v21 .. v21}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v17

    goto/16 :goto_3

    .line 191
    :cond_10
    const-string v21, "java.io.File"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_12

    move-object/from16 v21, p1

    .line 192
    check-cast v21, Ljava/io/File;

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->isThisApk(Ljava/io/File;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 193
    const-string v21, "length"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_11

    .line 194
    check-cast p1, Ljava/io/File;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->length(Ljava/io/File;)J

    move-result-wide v22

    invoke-static/range {v22 .. v23}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v17

    goto/16 :goto_3

    .line 196
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_11
    const-string v21, "lastModified"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/io/File;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->lastModified(Ljava/io/File;)J

    move-result-wide v22

    invoke-static/range {v22 .. v23}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v17

    goto/16 :goto_3

    .line 200
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_12
    const-string v21, "android.content.Context"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_13

    .line 201
    const-string v21, "getApplicationInfo"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Landroid/content/Context;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->getApplicationInfo(Landroid/content/Context;)Landroid/content/pm/ApplicationInfo;

    move-result-object v17

    goto/16 :goto_3

    .line 204
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_13
    const-string v21, "android.os.Debug"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_14

    .line 205
    const-string v21, "isDebuggerConnected"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    invoke-static {}, Lhooks/Monolith;->isDebuggerConnected()Z

    move-result v21

    invoke-static/range {v21 .. v21}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v17

    goto/16 :goto_3

    .line 208
    :cond_14
    const-string v21, "java.security.Signature"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_1a

    .line 209
    const-string v21, "java.security.Signature"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_16

    .line 210
    const-string v21, "verify"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 211
    move-object/from16 v0, p2

    array-length v0, v0

    move/from16 v21, v0

    const/16 v22, 0x4

    move/from16 v0, v21

    move/from16 v1, v22

    if-ne v0, v1, :cond_15

    .line 212
    check-cast p1, Ljava/security/Signature;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, [B

    check-cast v21, [B

    const/16 v22, 0x1

    aget-object v22, p2, v22

    check-cast v22, Ljava/lang/Integer;

    invoke-virtual/range {v22 .. v22}, Ljava/lang/Integer;->intValue()I

    move-result v23

    const/16 v22, 0x2

    aget-object v22, p2, v22

    check-cast v22, Ljava/lang/Integer;

    invoke-virtual/range {v22 .. v22}, Ljava/lang/Integer;->intValue()I

    move-result v22

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    move/from16 v2, v23

    move/from16 v3, v22

    invoke-static {v0, v1, v2, v3}, Lhooks/Monolith;->signatureVerify(Ljava/security/Signature;[BII)Z

    move-result v21

    invoke-static/range {v21 .. v21}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v17

    goto/16 :goto_3

    .line 217
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_15
    move-object/from16 v0, p2

    array-length v0, v0

    move/from16 v21, v0

    const/16 v22, 0x1

    move/from16 v0, v21

    move/from16 v1, v22

    if-ne v0, v1, :cond_18

    check-cast p1, Ljava/security/Signature;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, [B

    check-cast v21, [B

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->signatureVerify(Ljava/security/Signature;[B)Z

    move-result v21

    invoke-static/range {v21 .. v21}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v17

    goto/16 :goto_3

    .line 223
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_16
    const-string v21, "java.security.MessageDigest"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 224
    const-string v21, "update"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_19

    .line 225
    sget-boolean v21, Lhooks/Monolith;->BuildingDigest:Z

    if-nez v21, :cond_17

    .line 226
    const-string v21, "  building message digest"

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 229
    :cond_17
    const/16 v21, 0x1

    sput-boolean v21, Lhooks/Monolith;->BuildingDigest:Z

    .line 313
    :cond_18
    const-string v21, "  hook not handled, invoke normally."

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 314
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v17

    goto/16 :goto_3

    .line 233
    :cond_19
    const-string v21, "digest"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/security/MessageDigest;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofDigest(Ljava/security/MessageDigest;)[B

    move-result-object v17

    goto/16 :goto_3

    .line 237
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1a
    const-string v21, "org.apache.harmony.xnet.provider.jsse.OpenSSLMessageDigestJDK$"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_1b

    .line 239
    invoke-static {}, Ljava/lang/Thread;->dumpStack()V

    .line 241
    const-string v21, "digest"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/security/MessageDigest;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofDigest(Ljava/security/MessageDigest;)[B

    move-result-object v17

    goto/16 :goto_3

    .line 244
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1b
    const-string v21, "android.telephony.TelephonyManager"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_1c

    .line 245
    const-string v21, "getDeviceId"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 246
    const-string v21, "  invoking getDeviceId()"

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 247
    invoke-static {}, Lhooks/Monolith;->getDeviceId()Ljava/lang/String;

    move-result-object v17

    goto/16 :goto_3

    .line 250
    :cond_1c
    move-object/from16 v0, p1

    instance-of v0, v0, Ljava/lang/Throwable;

    move/from16 v21, v0

    if-eqz v21, :cond_1e

    .line 251
    const-string v21, "fillInStackTrace"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_1d

    .line 252
    const-string v21, "  invoking fillInStackTrace normally then scrubbing"

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 253
    invoke-virtual/range {p0 .. p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 254
    check-cast p1, Ljava/lang/Throwable;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->setStackTrace(Ljava/lang/Throwable;)V

    .line 255
    const/16 v17, 0x0

    goto/16 :goto_3

    .line 257
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1d
    const-string v21, "printStackTrace"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 258
    check-cast p1, Ljava/lang/Throwable;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->throwablePrintStackTrace(Ljava/lang/Throwable;)V

    .line 259
    const/16 v17, 0x0

    goto/16 :goto_3

    .line 262
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_1e
    const-string v21, "java.lang."

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_22

    .line 263
    const-string v21, "java.lang.Thread"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_20

    .line 264
    const-string v21, "dumpStack"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_1f

    .line 265
    const-string v21, "  running threadDumpStack()"

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 266
    invoke-static {}, Lhooks/Monolith;->threadDumpStack()V

    .line 267
    const/16 v17, 0x0

    goto/16 :goto_3

    .line 269
    :cond_1f
    const-string v21, "getStackTrace"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/lang/Thread;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->threadGetStackTrace(Ljava/lang/Thread;)[Ljava/lang/StackTraceElement;

    move-result-object v17

    goto/16 :goto_3

    .line 272
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_20
    const-string v21, "java.lang.reflect.Method"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_21

    .line 273
    const-string v21, "invoke"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 274
    const-string v21, "  invoking an invoke! sneaky sneaky :D!"

    invoke-static/range {v21 .. v21}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 275
    check-cast p1, Ljava/lang/reflect/Method;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v22, p2, v21

    const/16 v21, 0x1

    aget-object v21, p2, v21

    check-cast v21, [Ljava/lang/Object;

    check-cast v21, [Ljava/lang/Object;

    move-object/from16 v0, p1

    move-object/from16 v1, v22

    move-object/from16 v2, v21

    invoke-static {v0, v1, v2}, Lhooks/ReflectedInvoke;->invokeHook(Ljava/lang/reflect/Method;Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v17

    goto/16 :goto_3

    .line 279
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_21
    const-string v21, "java.lang.Runtime"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 280
    const-string v21, "exec"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/lang/Runtime;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->runtimeExec(Ljava/lang/Runtime;Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v17

    goto/16 :goto_3

    .line 284
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_22
    const-string v21, "java.util."

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_27

    .line 285
    const-string v21, "java.util.zip.ZipFile"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_23

    .line 286
    const-string v21, "getEntry"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/util/zip/ZipFile;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v17

    goto/16 :goto_3

    .line 289
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_23
    const-string v21, "java.util.jar.JarFile"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_25

    .line 290
    const-string v21, "getEntry"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_24

    .line 291
    check-cast p1, Ljava/util/zip/ZipFile;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->getZipEntry(Ljava/util/zip/ZipFile;Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v17

    goto/16 :goto_3

    .line 294
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_24
    const-string v21, "getJarEntry"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/util/jar/JarFile;

    .end local p1    # "receiver":Ljava/lang/Object;
    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    move-object/from16 v0, p1

    move-object/from16 v1, v21

    invoke-static {v0, v1}, Lhooks/Monolith;->getJarEntry(Ljava/util/jar/JarFile;Ljava/lang/String;)Ljava/util/jar/JarEntry;

    move-result-object v17

    goto/16 :goto_3

    .line 297
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_25
    const-string v21, "java.util.zip.Adler32"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-nez v21, :cond_26

    const-string v21, "java.util.zip.CRC32"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 299
    :cond_26
    const-string v21, "getValue"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/util/zip/Checksum;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p1}, Lhooks/Monolith;->spoofChecksum(Ljava/util/zip/Checksum;)J

    move-result-wide v22

    invoke-static/range {v22 .. v23}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v17

    goto/16 :goto_3

    .line 303
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_27
    const-string v21, "java.lang.reflect.Constructor"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_28

    .line 304
    const-string v21, "newInstance"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    check-cast p1, Ljava/lang/reflect/Constructor;

    .end local p1    # "receiver":Ljava/lang/Object;
    invoke-static/range {p1 .. p2}, Lhooks/ReflectedConstructor;->constructorNewInstance(Ljava/lang/reflect/Constructor;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v17

    goto/16 :goto_3

    .line 307
    .restart local p1    # "receiver":Ljava/lang/Object;
    :cond_28
    const-string v21, "dalvik.system.DexFile"

    move-object/from16 v0, v21

    invoke-virtual {v9, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v21

    if-eqz v21, :cond_18

    .line 308
    const-string v21, "loadDex"

    move-object/from16 v0, v21

    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v21

    if-eqz v21, :cond_18

    const/16 v21, 0x0

    aget-object v21, p2, v21

    check-cast v21, Ljava/lang/String;

    const/16 v22, 0x1

    aget-object v22, p2, v22

    check-cast v22, Ljava/lang/String;

    const/16 v23, 0x2

    aget-object v23, p2, v23

    check-cast v23, Ljava/lang/Integer;

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Integer;->intValue()I

    move-result v23

    invoke-static/range {v21 .. v23}, Lhooks/Monolith;->loadDex(Ljava/lang/String;Ljava/lang/String;I)Ldalvik/system/DexFile;

    move-result-object v17

    goto/16 :goto_3
.end method
