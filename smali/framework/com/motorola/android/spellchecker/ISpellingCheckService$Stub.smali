.class public abstract Lcom/motorola/spellchecker/ISpellingCheckService$Stub;
.super Landroid/os/Binder;
.source "ISpellingCheckService.java"

# interfaces
.implements Lcom/motorola/spellchecker/ISpellingCheckService;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/motorola/spellchecker/ISpellingCheckService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Stub"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/motorola/spellchecker/ISpellingCheckService$Stub$Proxy;
    }
.end annotation


# static fields
.field private static final DESCRIPTOR:Ljava/lang/String; = "com.motorola.spellchecker.ISpellingCheckService"

.field static final TRANSACTION_addWord:I = 0x4

.field static final TRANSACTION_afterImeAddWord:I = 0xd

.field static final TRANSACTION_beforeImeAddWord:I = 0xc

.field static final TRANSACTION_checkSug:I = 0x3

.field static final TRANSACTION_checkWord:I = 0x2

.field static final TRANSACTION_closeDict:I = 0x6

.field static final TRANSACTION_deregisterClient:I = 0xb

.field static final TRANSACTION_getDictEncoding:I = 0x5

.field static final TRANSACTION_openDict:I = 0x1

.field static final TRANSACTION_registerClient:I = 0xa

.field static final TRANSACTION_setEnabled:I = 0x7

.field static final TRANSACTION_setFlaggingEnabled:I = 0x8

.field static final TRANSACTION_setInputLanguage:I = 0x9


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 17
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    .line 18
    const-string v0, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p0, p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->attachInterface(Landroid/os/IInterface;Ljava/lang/String;)V

    .line 19
    return-void
.end method

.method public static asInterface(Landroid/os/IBinder;)Lcom/motorola/spellchecker/ISpellingCheckService;
    .locals 2
    .parameter "obj"

    .prologue
    .line 26
    if-nez p0, :cond_0

    .line 27
    const/4 v1, 0x0

    .line 33
    :goto_0
    return-object v1

    .line 29
    :cond_0
    const-string v1, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-interface {p0, v1}, Landroid/os/IBinder;->queryLocalInterface(Ljava/lang/String;)Landroid/os/IInterface;

    move-result-object v0

    .line 30
    .local v0, iin:Landroid/os/IInterface;
    if-eqz v0, :cond_1

    instance-of v1, v0, Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_1

    .line 31
    check-cast v0, Lcom/motorola/spellchecker/ISpellingCheckService;

    .end local v0           #iin:Landroid/os/IInterface;
    move-object v1, v0

    goto :goto_0

    .line 33
    .restart local v0       #iin:Landroid/os/IInterface;
    :cond_1
    new-instance v1, Lcom/motorola/spellchecker/ISpellingCheckService$Stub$Proxy;

    invoke-direct {v1, p0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub$Proxy;-><init>(Landroid/os/IBinder;)V

    goto :goto_0
.end method


# virtual methods
.method public asBinder()Landroid/os/IBinder;
    .locals 0

    .prologue
    .line 37
    return-object p0
.end method

.method public onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 7
    .parameter "code"
    .parameter "data"
    .parameter "reply"
    .parameter "flags"
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .prologue
    const/4 v6, 0x0

    const/4 v4, 0x1

    const-string v5, "com.motorola.spellchecker.ISpellingCheckService"

    .line 41
    sparse-switch p1, :sswitch_data_0

    .line 173
    invoke-super {p0, p1, p2, p3, p4}, Landroid/os/Binder;->onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result v3

    :goto_0
    return v3

    .line 45
    :sswitch_0
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p3, v5}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    move v3, v4

    .line 46
    goto :goto_0

    .line 50
    :sswitch_1
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 52
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    .line 53
    .local v0, _arg0:Ljava/lang/String;
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->openDict(Ljava/lang/String;)I

    move-result v2

    .line 54
    .local v2, _result:I
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 55
    invoke-virtual {p3, v2}, Landroid/os/Parcel;->writeInt(I)V

    move v3, v4

    .line 56
    goto :goto_0

    .line 60
    .end local v0           #_arg0:Ljava/lang/String;
    .end local v2           #_result:I
    :sswitch_2
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 62
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 64
    .local v0, _arg0:I
    invoke-virtual {p2}, Landroid/os/Parcel;->createByteArray()[B

    move-result-object v1

    .line 65
    .local v1, _arg1:[B
    invoke-virtual {p0, v0, v1}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->checkWord(I[B)I

    move-result v2

    .line 66
    .restart local v2       #_result:I
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 67
    invoke-virtual {p3, v2}, Landroid/os/Parcel;->writeInt(I)V

    move v3, v4

    .line 68
    goto :goto_0

    .line 72
    .end local v0           #_arg0:I
    .end local v1           #_arg1:[B
    .end local v2           #_result:I
    :sswitch_3
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 74
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 76
    .restart local v0       #_arg0:I
    invoke-virtual {p2}, Landroid/os/Parcel;->createByteArray()[B

    move-result-object v1

    .line 77
    .restart local v1       #_arg1:[B
    invoke-virtual {p0, v0, v1}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->checkSug(I[B)[B

    move-result-object v2

    .line 78
    .local v2, _result:[B
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 79
    invoke-virtual {p3, v2}, Landroid/os/Parcel;->writeByteArray([B)V

    move v3, v4

    .line 80
    goto :goto_0

    .line 84
    .end local v0           #_arg0:I
    .end local v1           #_arg1:[B
    .end local v2           #_result:[B
    :sswitch_4
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 86
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 88
    .restart local v0       #_arg0:I
    invoke-virtual {p2}, Landroid/os/Parcel;->createByteArray()[B

    move-result-object v1

    .line 89
    .restart local v1       #_arg1:[B
    invoke-virtual {p0, v0, v1}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->addWord(I[B)V

    .line 90
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 91
    goto :goto_0

    .line 95
    .end local v0           #_arg0:I
    .end local v1           #_arg1:[B
    :sswitch_5
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 97
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 98
    .restart local v0       #_arg0:I
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->getDictEncoding(I)Ljava/lang/String;

    move-result-object v2

    .line 99
    .local v2, _result:Ljava/lang/String;
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 100
    invoke-virtual {p3, v2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    move v3, v4

    .line 101
    goto :goto_0

    .line 105
    .end local v0           #_arg0:I
    .end local v2           #_result:Ljava/lang/String;
    :sswitch_6
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 107
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 108
    .restart local v0       #_arg0:I
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->closeDict(I)V

    .line 109
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 110
    goto/16 :goto_0

    .line 114
    .end local v0           #_arg0:I
    :sswitch_7
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 116
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v3

    if-eqz v3, :cond_0

    move v0, v4

    .line 117
    .local v0, _arg0:Z
    :goto_1
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->setEnabled(Z)V

    .line 118
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 119
    goto/16 :goto_0

    .end local v0           #_arg0:Z
    :cond_0
    move v0, v6

    .line 116
    goto :goto_1

    .line 123
    :sswitch_8
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 125
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v3

    if-eqz v3, :cond_1

    move v0, v4

    .line 126
    .restart local v0       #_arg0:Z
    :goto_2
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->setFlaggingEnabled(Z)V

    .line 127
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 128
    goto/16 :goto_0

    .end local v0           #_arg0:Z
    :cond_1
    move v0, v6

    .line 125
    goto :goto_2

    .line 132
    :sswitch_9
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 134
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    .line 135
    .local v0, _arg0:Ljava/lang/String;
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->setInputLanguage(Ljava/lang/String;)V

    .line 136
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 137
    goto/16 :goto_0

    .line 141
    .end local v0           #_arg0:Ljava/lang/String;
    :sswitch_a
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 143
    invoke-virtual {p2}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;

    move-result-object v3

    invoke-static {v3}, Lcom/motorola/spellchecker/ISpellingCheckClient$Stub;->asInterface(Landroid/os/IBinder;)Lcom/motorola/spellchecker/ISpellingCheckClient;

    move-result-object v0

    .line 144
    .local v0, _arg0:Lcom/motorola/spellchecker/ISpellingCheckClient;
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->registerClient(Lcom/motorola/spellchecker/ISpellingCheckClient;)I

    move-result v2

    .line 145
    .local v2, _result:I
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 146
    invoke-virtual {p3, v2}, Landroid/os/Parcel;->writeInt(I)V

    move v3, v4

    .line 147
    goto/16 :goto_0

    .line 151
    .end local v0           #_arg0:Lcom/motorola/spellchecker/ISpellingCheckClient;
    .end local v2           #_result:I
    :sswitch_b
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 153
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v0

    .line 154
    .local v0, _arg0:I
    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->deregisterClient(I)V

    .line 155
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 156
    goto/16 :goto_0

    .line 160
    .end local v0           #_arg0:I
    :sswitch_c
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 161
    invoke-virtual {p0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->beforeImeAddWord()V

    .line 162
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 163
    goto/16 :goto_0

    .line 167
    :sswitch_d
    const-string v3, "com.motorola.spellchecker.ISpellingCheckService"

    invoke-virtual {p2, v5}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 168
    invoke-virtual {p0}, Lcom/motorola/spellchecker/ISpellingCheckService$Stub;->afterImeAddWord()V

    .line 169
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    move v3, v4

    .line 170
    goto/16 :goto_0

    .line 41
    :sswitch_data_0
    .sparse-switch
        0x1 -> :sswitch_1
        0x2 -> :sswitch_2
        0x3 -> :sswitch_3
        0x4 -> :sswitch_4
        0x5 -> :sswitch_5
        0x6 -> :sswitch_6
        0x7 -> :sswitch_7
        0x8 -> :sswitch_8
        0x9 -> :sswitch_9
        0xa -> :sswitch_a
        0xb -> :sswitch_b
        0xc -> :sswitch_c
        0xd -> :sswitch_d
        0x5f4e5446 -> :sswitch_0
    .end sparse-switch
.end method
