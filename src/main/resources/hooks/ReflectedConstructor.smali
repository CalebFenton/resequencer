.class public Lhooks/ReflectedConstructor;
.super Ljava/lang/Object;
.source "ReflectedConstructor.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static constructorNewInstance(Ljava/lang/reflect/Constructor;[Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6
    .param p1, "initargs"    # [Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/reflect/Constructor",
            "<*>;[",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;,
            Ljava/lang/InstantiationException;,
            Ljava/lang/IllegalAccessException;,
            Ljava/lang/reflect/InvocationTargetException;
        }
    .end annotation

    .prologue
    .local p0, "c":Ljava/lang/reflect/Constructor;, "Ljava/lang/reflect/Constructor<*>;"
    const/4 v5, 0x0

    .line 13
    invoke-virtual {p0}, Ljava/lang/reflect/Constructor;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 20
    .local v1, "cnstrClassName":Ljava/lang/String;
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "Constructor hook for class: "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    .line 22
    invoke-virtual {p0, p1}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 25
    .local v2, "newObj":Ljava/lang/Object;
    const-string v3, "java.io.FileInputStream"

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 26
    aget-object v3, p1, v5

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    .line 27
    .local v0, "className":Ljava/lang/String;
    const-string v3, "java.io.File"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    move-object v3, v2

    .line 28
    check-cast v3, Ljava/io/InputStream;

    .line 29
    aget-object v4, p1, v5

    check-cast v4, Ljava/io/File;

    .line 28
    invoke-static {v3, v4}, Lhooks/Monolith;->watchInputStream(Ljava/lang/Object;Ljava/io/File;)V

    .line 40
    .end local v0    # "className":Ljava/lang/String;
    :cond_0
    :goto_0
    return-object v2

    .line 31
    .restart local v0    # "className":Ljava/lang/String;
    :cond_1
    const-string v3, "java.lang.String"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    move-object v3, v2

    .line 32
    check-cast v3, Ljava/io/InputStream;

    .line 33
    aget-object v4, p1, v5

    check-cast v4, Ljava/lang/String;

    .line 32
    invoke-static {v3, v4}, Lhooks/Monolith;->watchInputStream(Ljava/lang/Object;Ljava/lang/String;)V

    goto :goto_0

    .line 36
    :cond_2
    const-string v3, "  unable to hook. Maybe using file descriptors."

    invoke-static {v3}, Lhooks/Monolith;->log(Ljava/lang/Object;)V

    goto :goto_0
.end method
