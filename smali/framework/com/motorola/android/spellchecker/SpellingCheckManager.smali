.class public Lcom/motorola/spellchecker/SpellingCheckManager;
.super Ljava/lang/Object;
.source "SpellingCheckManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;,
        Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;,
        Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;,
        Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;,
        Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;,
        Lcom/motorola/spellchecker/SpellingCheckManager$OnConnectionEstablishedListener;
    }
.end annotation


# static fields
.field private static final DEBUG:Z = false

.field public static final ENABLED:Z = true

.field private static final LOGTAG:Ljava/lang/String; = "*** SpellingCheckManager ***"

.field static final MAX_WORD_LENGTH:I = 0x20

.field static final MISSPELL_HIGHLIGHT_COLOR:I = -0x7013e3dc

.field private static WORD_SEPARATORS:Ljava/lang/String;

.field private static mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;


# instance fields
.field private mClientCallback:Lcom/motorola/spellchecker/ISpellingCheckClient$Stub;

.field private mClientID:I

.field private mContext:Landroid/content/Context;

.field private mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

.field private mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

.field private mOpenedDicts:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;",
            ">;"
        }
    .end annotation
.end field

.field private mPendingListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lcom/motorola/spellchecker/SpellingCheckManager$OnConnectionEstablishedListener;",
            ">;"
        }
    .end annotation
.end field

.field private mServiceEnabled:Z

.field private mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 463
    const-string v0, ". ,;:!?\n()[]*&@{}/<>_+=|\""

    sput-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->WORD_SEPARATORS:Ljava/lang/String;

    .line 469
    const/4 v0, 0x0

    sput-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 4
    .parameter "context"

    .prologue
    const/4 v3, 0x0

    const/4 v2, 0x0

    .line 1327
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 461
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mPendingListeners:Ljava/util/ArrayList;

    .line 464
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0xa

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    .line 466
    iput-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    .line 467
    iput-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    .line 468
    iput-boolean v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    .line 470
    iput-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    .line 472
    new-instance v0, Lcom/motorola/spellchecker/SpellingCheckManager$1;

    invoke-direct {v0, p0}, Lcom/motorola/spellchecker/SpellingCheckManager$1;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;)V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mClientCallback:Lcom/motorola/spellchecker/ISpellingCheckClient$Stub;

    .line 481
    iput v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mClientID:I

    .line 1328
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    .line 1329
    new-instance v0, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    invoke-direct {v0, p0, v1}, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    .line 1330
    return-void
.end method

.method static synthetic access$000(Lcom/motorola/spellchecker/SpellingCheckManager;C)Z
    .locals 1
    .parameter "x0"
    .parameter "x1"

    .prologue
    .line 50
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isWordSeparator(C)Z

    move-result v0

    return v0
.end method

.method static synthetic access$1000(Lcom/motorola/spellchecker/SpellingCheckManager;)Ljava/util/ArrayList;
    .locals 1
    .parameter "x0"

    .prologue
    .line 50
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mPendingListeners:Ljava/util/ArrayList;

    return-object v0
.end method

.method static synthetic access$1100(Lcom/motorola/spellchecker/SpellingCheckManager;)Ljava/util/ArrayList;
    .locals 1
    .parameter "x0"

    .prologue
    .line 50
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    return-object v0
.end method

.method static synthetic access$1202(Lcom/motorola/spellchecker/SpellingCheckManager;Z)Z
    .locals 0
    .parameter "x0"
    .parameter "x1"

    .prologue
    .line 50
    iput-boolean p1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    return p1
.end method

.method static synthetic access$1300(Lcom/motorola/spellchecker/SpellingCheckManager;Landroid/widget/TextView;II)V
    .locals 0
    .parameter "x0"
    .parameter "x1"
    .parameter "x2"
    .parameter "x3"

    .prologue
    .line 50
    invoke-direct {p0, p1, p2, p3}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(Landroid/widget/TextView;II)V

    return-void
.end method

.method static synthetic access$700(Lcom/motorola/spellchecker/SpellingCheckManager;)Lcom/motorola/spellchecker/ISpellingCheckService;
    .locals 1
    .parameter "x0"

    .prologue
    .line 50
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    return-object v0
.end method

.method static synthetic access$702(Lcom/motorola/spellchecker/SpellingCheckManager;Lcom/motorola/spellchecker/ISpellingCheckService;)Lcom/motorola/spellchecker/ISpellingCheckService;
    .locals 0
    .parameter "x0"
    .parameter "x1"

    .prologue
    .line 50
    iput-object p1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    return-object p1
.end method

.method static synthetic access$802(Lcom/motorola/spellchecker/SpellingCheckManager;I)I
    .locals 0
    .parameter "x0"
    .parameter "x1"

    .prologue
    .line 50
    iput p1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mClientID:I

    return p1
.end method

.method static synthetic access$900(Lcom/motorola/spellchecker/SpellingCheckManager;)Lcom/motorola/spellchecker/ISpellingCheckClient$Stub;
    .locals 1
    .parameter "x0"

    .prologue
    .line 50
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mClientCallback:Lcom/motorola/spellchecker/ISpellingCheckClient$Stub;

    return-object v0
.end method

.method public static attachSpellCheckerFlags(Landroid/text/Spannable;IILjava/lang/String;Ljava/lang/String;Z)V
    .locals 7
    .parameter "sp"
    .parameter "start"
    .parameter "end"
    .parameter "anno_key"
    .parameter "anno_value"
    .parameter "highlight"

    .prologue
    const/16 v6, 0x21

    .line 983
    if-nez p0, :cond_1

    .line 1010
    :cond_0
    :goto_0
    return-void

    .line 987
    :cond_1
    invoke-interface {p0}, Landroid/text/Spannable;->length()I

    move-result v2

    .line 988
    .local v2, length:I
    if-ltz p1, :cond_0

    if-gt p2, v2, :cond_0

    if-ge p1, p2, :cond_0

    .line 997
    invoke-static {p0, p1, p2}, Lcom/motorola/spellchecker/SpellingCheckManager;->getSpellCheckerSpans(Landroid/text/Spanned;II)[Ljava/lang/Object;

    move-result-object v3

    .line 998
    .local v3, spans:[Ljava/lang/Object;
    array-length v0, v3

    .line 999
    .local v0, count:I
    const/4 v1, 0x0

    .local v1, i:I
    :goto_1
    if-ge v1, v0, :cond_2

    .line 1000
    aget-object v4, v3, v1

    invoke-interface {p0, v4}, Landroid/text/Spannable;->removeSpan(Ljava/lang/Object;)V

    .line 999
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 1003
    :cond_2
    if-eqz p3, :cond_3

    if-eqz p4, :cond_3

    .line 1004
    new-instance v4, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-direct {v4, p3, p4}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p0, v4, p1, p2, v6}, Landroid/text/Spannable;->setSpan(Ljava/lang/Object;III)V

    .line 1007
    :cond_3
    if-eqz p5, :cond_0

    .line 1008
    new-instance v4, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    const v5, -0x7013e3dc

    invoke-direct {v4, v5}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;-><init>(I)V

    invoke-interface {p0, v4, p1, p2, v6}, Landroid/text/Spannable;->setSpan(Ljava/lang/Object;III)V

    goto :goto_0
.end method

.method public static checkEditor(Landroid/widget/TextView;II)V
    .locals 2
    .parameter "editor"
    .parameter "start"
    .parameter "end"

    .prologue
    .line 825
    if-eqz p0, :cond_0

    invoke-static {p0}, Lcom/motorola/spellchecker/SpellingCheckManager;->eligableForSpellingCheck(Landroid/widget/TextView;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 843
    :cond_0
    :goto_0
    return-void

    .line 829
    :cond_1
    invoke-virtual {p0}, Landroid/widget/TextView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/motorola/spellchecker/SpellingCheckManager;->getInstance(Landroid/content/Context;)Lcom/motorola/spellchecker/SpellingCheckManager;

    move-result-object v0

    .line 830
    .local v0, instance:Lcom/motorola/spellchecker/SpellingCheckManager;
    if-eqz v0, :cond_0

    .line 834
    invoke-virtual {v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->isConnectionEstablished()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 835
    invoke-direct {v0, p0, p1, p2}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(Landroid/widget/TextView;II)V

    goto :goto_0

    .line 837
    :cond_2
    new-instance v1, Lcom/motorola/spellchecker/SpellingCheckManager$2;

    invoke-direct {v1, v0, p0, p1, p2}, Lcom/motorola/spellchecker/SpellingCheckManager$2;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;Landroid/widget/TextView;II)V

    invoke-virtual {v0, v1}, Lcom/motorola/spellchecker/SpellingCheckManager;->setOnConnectionEstablishedListener(Lcom/motorola/spellchecker/SpellingCheckManager$OnConnectionEstablishedListener;)V

    goto :goto_0
.end method

.method private checkSug(ILjava/lang/String;)[B
    .locals 5
    .parameter "dictID"
    .parameter "wd"

    .prologue
    .line 1357
    const/4 v0, 0x0

    .line 1358
    .local v0, bSuggestion:[B
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v3, :cond_0

    .line 1360
    :try_start_0
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v2

    .line 1361
    .local v2, index:I
    if-ltz v2, :cond_1

    .line 1362
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    invoke-virtual {p2, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v4

    invoke-interface {v3, p1, v4}, Lcom/motorola/spellchecker/ISpellingCheckService;->checkSug(I[B)[B
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    .line 1371
    .end local v2           #index:I
    :cond_0
    :goto_0
    return-object v0

    .line 1364
    .restart local v2       #index:I
    .restart local p0
    :cond_1
    const/4 v0, 0x0

    goto :goto_0

    .line 1366
    .end local v2           #index:I
    .end local p0
    :catch_0
    move-exception v3

    move-object v1, v3

    .line 1367
    .local v1, e:Ljava/lang/Exception;
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private static eligableForSpellingCheck(Landroid/widget/TextView;)Z
    .locals 5
    .parameter "editor"

    .prologue
    const/4 v4, 0x1

    const/4 v3, 0x0

    .line 799
    invoke-virtual {p0}, Landroid/widget/TextView;->getInputType()I

    move-result v0

    .line 800
    .local v0, inputType:I
    and-int/lit8 v2, v0, 0xf

    if-ne v2, v4, :cond_2

    .line 801
    const/high16 v2, 0x8

    and-int/2addr v2, v0

    if-nez v2, :cond_0

    const/high16 v2, 0x1

    and-int/2addr v2, v0

    if-eqz v2, :cond_1

    :cond_0
    move v2, v3

    .line 817
    :goto_0
    return v2

    .line 806
    :cond_1
    and-int/lit16 v1, v0, 0xff0

    .line 807
    .local v1, variation:I
    const/16 v2, 0x10

    if-eq v1, v2, :cond_2

    const/16 v2, 0x20

    if-eq v1, v2, :cond_2

    const/16 v2, 0x60

    if-eq v1, v2, :cond_2

    const/16 v2, 0x80

    if-eq v1, v2, :cond_2

    const/16 v2, 0x90

    if-eq v1, v2, :cond_2

    const/16 v2, 0xb0

    if-eq v1, v2, :cond_2

    move v2, v4

    .line 813
    goto :goto_0

    .end local v1           #variation:I
    :cond_2
    move v2, v3

    .line 817
    goto :goto_0
.end method

.method public static getInstance(Landroid/content/Context;)Lcom/motorola/spellchecker/SpellingCheckManager;
    .locals 1
    .parameter "context"

    .prologue
    .line 489
    if-eqz p0, :cond_0

    .line 490
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    if-nez v0, :cond_1

    .line 491
    new-instance v0, Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-direct {v0, p0}, Lcom/motorola/spellchecker/SpellingCheckManager;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    .line 492
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-direct {v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->startSpellingCheckService()Z

    .line 499
    :cond_0
    :goto_0
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    return-object v0

    .line 493
    :cond_1
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-virtual {v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->isConnectionEstablished()Z

    move-result v0

    if-nez v0, :cond_0

    .line 494
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-direct {v0, p0}, Lcom/motorola/spellchecker/SpellingCheckManager;->updateContext(Landroid/content/Context;)V

    .line 495
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->mCommonInstance:Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-direct {v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->startSpellingCheckService()Z

    goto :goto_0
.end method

.method public static getSpans(Landroid/text/Spanned;IILjava/lang/Class;)[Ljava/lang/Object;
    .locals 11
    .parameter "sp"
    .parameter "start"
    .parameter "end"
    .parameter
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Landroid/text/Spanned;",
            "II",
            "Ljava/lang/Class",
            "<TT;>;)[TT;"
        }
    .end annotation

    .prologue
    .local p3, kind:Ljava/lang/Class;,"Ljava/lang/Class<TT;>;"
    const/4 v9, 0x0

    const-class v10, Landroid/text/style/CharacterStyle;

    .line 1108
    invoke-interface {p0, p1, p2, p3}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v5

    .line 1110
    .local v5, spans:[Ljava/lang/Object;,"[TT;"
    const-class v8, Landroid/text/style/CharacterStyle;

    if-eq p3, v10, :cond_0

    const-class v8, Landroid/text/ParcelableSpan;

    if-eq p3, v8, :cond_0

    const-class v8, Ljava/lang/Object;

    if-ne p3, v8, :cond_5

    .line 1111
    :cond_0
    const-class v8, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    invoke-interface {p0, p1, p2, v8}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v7

    check-cast v7, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    .line 1113
    .local v7, spellCheckerMarkupSpans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    const/4 v6, 0x0

    .line 1115
    .local v6, spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    array-length v3, v7

    .line 1116
    .local v3, len_markup:I
    const/4 v2, 0x0

    .line 1118
    .local v2, len_annotations:I
    const-class v8, Landroid/text/style/CharacterStyle;

    if-eq p3, v10, :cond_1

    .line 1119
    const-class v8, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-interface {p0, p1, p2, v8}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v6

    .end local v6           #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    check-cast v6, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    .line 1120
    .restart local v6       #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    array-length v2, v6

    .line 1123
    :cond_1
    if-gtz v3, :cond_2

    if-lez v2, :cond_5

    .line 1124
    :cond_2
    array-length v4, v5

    .line 1125
    .local v4, len_other:I
    add-int v8, v4, v3

    add-int/2addr v8, v2

    invoke-static {p3, v8}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, [Ljava/lang/Object;

    move-object v0, p0

    check-cast v0, [Ljava/lang/Object;

    move-object v1, v0

    .line 1127
    .local v1, allSpans:[Ljava/lang/Object;,"[TT;"
    invoke-static {v5, v9, v1, v9, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 1128
    if-lez v3, :cond_3

    .line 1129
    invoke-static {v7, v9, v1, v4, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 1132
    :cond_3
    if-lez v2, :cond_4

    .line 1133
    add-int v8, v4, v3

    invoke-static {v6, v9, v1, v8, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 1136
    :cond_4
    move-object v5, v1

    .line 1140
    .end local v1           #allSpans:[Ljava/lang/Object;,"[TT;"
    .end local v2           #len_annotations:I
    .end local v3           #len_markup:I
    .end local v4           #len_other:I
    .end local v6           #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    .end local v7           #spellCheckerMarkupSpans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    :cond_5
    return-object v5
.end method

.method public static getSpellCheckerSpans(Landroid/text/Spanned;II)[Ljava/lang/Object;
    .locals 9
    .parameter "sp"
    .parameter "start"
    .parameter "end"

    .prologue
    const/4 v8, 0x0

    const-class v7, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    .line 1149
    const-class v6, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    invoke-interface {p0, p1, p2, v6}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    .line 1151
    .local v5, spellCheckerMarkupSpans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    array-length v6, v5

    if-lez v6, :cond_3

    .line 1152
    const-class v6, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-interface {p0, p1, p2, v7}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v4

    check-cast v4, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    .line 1154
    .local v4, spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    array-length v6, v4

    if-lez v6, :cond_2

    .line 1155
    array-length v2, v5

    .line 1156
    .local v2, len_markup:I
    array-length v1, v4

    .line 1157
    .local v1, len_annotations:I
    const-class v6, Ljava/lang/Object;

    add-int v7, v2, v1

    invoke-static {v6, v7}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, [Ljava/lang/Object;

    move-object v0, p0

    check-cast v0, [Ljava/lang/Object;

    move-object v3, v0

    .line 1159
    .local v3, spans:[Ljava/lang/Object;
    if-lez v2, :cond_0

    .line 1160
    invoke-static {v5, v8, v3, v8, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 1163
    :cond_0
    if-lez v1, :cond_1

    .line 1164
    invoke-static {v4, v8, v3, v2, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_1
    move-object v6, v3

    .line 1173
    .end local v1           #len_annotations:I
    .end local v2           #len_markup:I
    .end local v3           #spans:[Ljava/lang/Object;
    .end local v4           #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    :goto_0
    return-object v6

    .restart local v4       #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    .restart local p0
    :cond_2
    move-object v6, v5

    .line 1170
    goto :goto_0

    .line 1173
    .end local v4           #spellCheckerAnnotations:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    :cond_3
    const-class v6, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-interface {p0, p1, p2, v7}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v6

    goto :goto_0
.end method

.method private isValidDictID(I)I
    .locals 4
    .parameter "ID"

    .prologue
    .line 1344
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 1345
    .local v2, size:I
    const/4 v1, 0x0

    .line 1346
    .local v1, od:Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;
    const/4 v0, 0x0

    .local v0, i:I
    :goto_0
    if-ge v0, v2, :cond_1

    .line 1347
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v3, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    .end local v1           #od:Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;
    check-cast v1, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    .line 1348
    .restart local v1       #od:Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;
    iget v3, v1, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->id:I

    if-ne v3, p1, :cond_0

    move v3, v0

    .line 1353
    :goto_1
    return v3

    .line 1346
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1353
    :cond_1
    const/4 v3, -0x1

    goto :goto_1
.end method

.method private isWordSeparator(C)Z
    .locals 2
    .parameter "c"

    .prologue
    .line 1375
    sget-object v0, Lcom/motorola/spellchecker/SpellingCheckManager;->WORD_SEPARATORS:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1376
    const/4 v0, 0x1

    .line 1378
    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static removeSpellCheckerFlags(Ljava/lang/CharSequence;II)V
    .locals 6
    .parameter "content"
    .parameter "start"
    .parameter "end"

    .prologue
    .line 954
    if-eqz p0, :cond_1

    instance-of v4, p0, Landroid/text/Spannable;

    if-eqz v4, :cond_1

    .line 955
    move-object v0, p0

    check-cast v0, Landroid/text/Spannable;

    move-object v4, v0

    const-class v5, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    invoke-interface {v4, p1, p2, v5}, Landroid/text/Spannable;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    .line 956
    .local v3, spans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    array-length v1, v3

    .line 957
    .local v1, count:I
    const/4 v2, 0x0

    .local v2, i:I
    :goto_0
    if-ge v2, v1, :cond_1

    .line 958
    aget-object v4, v3, v2

    invoke-virtual {v4}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;->getBackgroundColor()I

    move-result v4

    const v5, -0x7013e3dc

    if-ne v4, v5, :cond_0

    .line 959
    move-object v0, p0

    check-cast v0, Landroid/text/Spannable;

    move-object v4, v0

    aget-object v5, v3, v2

    invoke-interface {v4, v5}, Landroid/text/Spannable;->removeSpan(Ljava/lang/Object;)V

    .line 957
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 963
    .end local v1           #count:I
    .end local v2           #i:I
    .end local v3           #spans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    :cond_1
    return-void
.end method

.method public static replaceWithSpellCheckerSpans(IILandroid/text/Editable;Ljava/lang/CharSequence;)Landroid/text/Editable;
    .locals 17
    .parameter "start"
    .parameter "end"
    .parameter "content"
    .parameter "replacer"

    .prologue
    const/16 v16, 0x0

    const/16 v15, 0x21

    .line 1181
    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    move/from16 v0, p0

    move/from16 v1, p1

    if-le v0, v1, :cond_1

    .line 1248
    :cond_0
    return-object p2

    .line 1185
    :cond_1
    if-gez p0, :cond_2

    .line 1186
    const/16 p0, 0x0

    .line 1189
    :cond_2
    invoke-interface/range {p2 .. p2}, Landroid/text/Editable;->length()I

    move-result v13

    move/from16 v0, p1

    move v1, v13

    if-le v0, v1, :cond_3

    .line 1190
    invoke-interface/range {p2 .. p2}, Landroid/text/Editable;->length()I

    move-result p1

    .line 1193
    :cond_3
    move-object/from16 v0, p2

    move/from16 v1, p0

    move/from16 v2, p1

    invoke-static {v0, v1, v2}, Lcom/motorola/spellchecker/SpellingCheckManager;->getSpellCheckerSpans(Landroid/text/Spanned;II)[Ljava/lang/Object;

    move-result-object v6

    .line 1195
    .local v6, existingSpellCheckerSpans:[Ljava/lang/Object;
    if-nez v6, :cond_4

    array-length v13, v6

    if-lez v13, :cond_9

    .line 1196
    :cond_4
    const/4 v8, 0x0

    .local v8, i:I
    :goto_0
    array-length v13, v6

    if-ge v8, v13, :cond_9

    .line 1197
    aget-object v13, v6, v8

    move-object/from16 v0, p2

    move-object v1, v13

    invoke-interface {v0, v1}, Landroid/text/Editable;->getSpanStart(Ljava/lang/Object;)I

    move-result v13

    move/from16 v0, v16

    move v1, v13

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v12

    .line 1198
    .local v12, st:I
    invoke-interface/range {p2 .. p2}, Landroid/text/Editable;->length()I

    move-result v13

    aget-object v14, v6, v8

    move-object/from16 v0, p2

    move-object v1, v14

    invoke-interface {v0, v1}, Landroid/text/Editable;->getSpanEnd(Ljava/lang/Object;)I

    move-result v14

    invoke-static {v13, v14}, Ljava/lang/Math;->min(II)I

    move-result v5

    .line 1200
    .local v5, en:I
    move v0, v12

    move/from16 v1, p0

    if-lt v0, v1, :cond_6

    move v0, v5

    move/from16 v1, p1

    if-gt v0, v1, :cond_6

    .line 1205
    aget-object v13, v6, v8

    move-object/from16 v0, p2

    move-object v1, v13

    invoke-interface {v0, v1}, Landroid/text/Editable;->removeSpan(Ljava/lang/Object;)V

    .line 1196
    :cond_5
    :goto_1
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 1206
    :cond_6
    move v0, v12

    move/from16 v1, p0

    if-ge v0, v1, :cond_7

    move v0, v5

    move/from16 v1, p1

    if-le v0, v1, :cond_7

    .line 1213
    invoke-interface/range {p3 .. p3}, Ljava/lang/CharSequence;->length()I

    move-result v13

    if-lez v13, :cond_5

    aget-object v13, v6, v8

    instance-of v13, v13, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    if-eqz v13, :cond_5

    .line 1215
    aget-object v13, v6, v8

    move-object/from16 v0, p2

    move-object v1, v13

    move v2, v12

    move/from16 v3, p0

    move v4, v15

    invoke-interface {v0, v1, v2, v3, v4}, Landroid/text/Editable;->setSpan(Ljava/lang/Object;III)V

    .line 1216
    new-instance v9, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    const v13, -0x7013e3dc

    invoke-direct {v9, v13}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;-><init>(I)V

    .line 1217
    .local v9, scms:Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    move-object/from16 v0, p2

    move-object v1, v9

    move/from16 v2, p1

    move v3, v5

    move v4, v15

    invoke-interface {v0, v1, v2, v3, v4}, Landroid/text/Editable;->setSpan(Ljava/lang/Object;III)V

    goto :goto_1

    .line 1219
    .end local v9           #scms:Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    :cond_7
    move v0, v12

    move/from16 v1, p0

    if-ge v0, v1, :cond_8

    move v0, v5

    move/from16 v1, p0

    if-le v0, v1, :cond_8

    .line 1220
    aget-object v13, v6, v8

    move-object/from16 v0, p2

    move-object v1, v13

    move v2, v12

    move/from16 v3, p0

    move v4, v15

    invoke-interface {v0, v1, v2, v3, v4}, Landroid/text/Editable;->setSpan(Ljava/lang/Object;III)V

    goto :goto_1

    .line 1221
    :cond_8
    move v0, v5

    move/from16 v1, p1

    if-le v0, v1, :cond_5

    move v0, v12

    move/from16 v1, p1

    if-ge v0, v1, :cond_5

    .line 1222
    aget-object v13, v6, v8

    move-object/from16 v0, p2

    move-object v1, v13

    move/from16 v2, p1

    move v3, v5

    move v4, v15

    invoke-interface {v0, v1, v2, v3, v4}, Landroid/text/Editable;->setSpan(Ljava/lang/Object;III)V

    goto :goto_1

    .line 1227
    .end local v5           #en:I
    .end local v8           #i:I
    .end local v12           #st:I
    :cond_9
    move-object/from16 v0, p2

    move/from16 v1, p0

    move/from16 v2, p1

    move-object/from16 v3, p3

    invoke-interface {v0, v1, v2, v3}, Landroid/text/Editable;->replace(IILjava/lang/CharSequence;)Landroid/text/Editable;

    .line 1229
    move-object/from16 v0, p3

    instance-of v0, v0, Landroid/text/Spanned;

    move v13, v0

    if-eqz v13, :cond_0

    .line 1230
    move-object/from16 v0, p3

    check-cast v0, Landroid/text/Spanned;

    move-object v10, v0

    .line 1231
    .local v10, sp:Landroid/text/Spanned;
    invoke-interface {v10}, Landroid/text/Spanned;->length()I

    move-result v13

    move-object v0, v10

    move/from16 v1, v16

    move v2, v13

    invoke-static {v0, v1, v2}, Lcom/motorola/spellchecker/SpellingCheckManager;->getSpellCheckerSpans(Landroid/text/Spanned;II)[Ljava/lang/Object;

    move-result-object v11

    .line 1232
    .local v11, spellCheckerSpans:[Ljava/lang/Object;
    if-nez v11, :cond_a

    array-length v13, v11

    if-lez v13, :cond_0

    .line 1233
    :cond_a
    const/4 v8, 0x0

    .restart local v8       #i:I
    :goto_2
    array-length v13, v11

    if-ge v8, v13, :cond_0

    .line 1234
    aget-object v13, v11, v8

    invoke-interface {v10, v13}, Landroid/text/Spanned;->getSpanStart(Ljava/lang/Object;)I

    move-result v13

    move/from16 v0, v16

    move v1, v13

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v13

    add-int v12, v13, p0

    .line 1235
    .restart local v12       #st:I
    invoke-interface/range {p3 .. p3}, Ljava/lang/CharSequence;->length()I

    move-result v13

    aget-object v14, v11, v8

    invoke-interface {v10, v14}, Landroid/text/Spanned;->getSpanEnd(Ljava/lang/Object;)I

    move-result v14

    invoke-static {v13, v14}, Ljava/lang/Math;->min(II)I

    move-result v13

    add-int v5, v13, p0

    .line 1236
    .restart local v5       #en:I
    invoke-interface/range {p2 .. p2}, Landroid/text/Editable;->length()I

    move-result v13

    invoke-static {v13, v5}, Ljava/lang/Math;->min(II)I

    move-result v5

    .line 1237
    aget-object v13, v11, v8

    invoke-interface {v10, v13}, Landroid/text/Spanned;->getSpanFlags(Ljava/lang/Object;)I

    move-result v7

    .line 1243
    .local v7, flags:I
    aget-object v13, v11, v8

    move-object/from16 v0, p2

    move-object v1, v13

    move v2, v12

    move v3, v5

    move v4, v7

    invoke-interface {v0, v1, v2, v3, v4}, Landroid/text/Editable;->setSpan(Ljava/lang/Object;III)V

    .line 1233
    add-int/lit8 v8, v8, 0x1

    goto :goto_2
.end method

.method private spell(Landroid/widget/TextView;II)V
    .locals 6
    .parameter "editor"
    .parameter "start"
    .parameter "end"

    .prologue
    .line 849
    iget-boolean v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    if-eqz v0, :cond_0

    .line 850
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->openDict(Ljava/lang/String;)I

    move-result v1

    .line 851
    .local v1, dict_id:I
    const/4 v5, 0x1

    move-object v0, p0

    move-object v2, p1

    move v3, p2

    move v4, p3

    invoke-virtual/range {v0 .. v5}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(ILandroid/widget/TextView;IIZ)V

    .line 852
    invoke-virtual {p0, v1}, Lcom/motorola/spellchecker/SpellingCheckManager;->closeDict(I)V

    .line 856
    .end local v1           #dict_id:I
    :goto_0
    return-void

    .line 854
    :cond_0
    invoke-virtual {p1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-static {v0, p2, p3}, Lcom/motorola/spellchecker/SpellingCheckManager;->removeSpellCheckerFlags(Ljava/lang/CharSequence;II)V

    goto :goto_0
.end method

.method private startSpellingCheckService()Z
    .locals 4

    .prologue
    const/4 v3, 0x1

    .line 1388
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-nez v0, :cond_2

    .line 1389
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    if-nez v0, :cond_0

    .line 1390
    new-instance v0, Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    invoke-direct {v0, p0}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;)V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    .line 1393
    :cond_0
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    new-instance v1, Landroid/content/Intent;

    const-string v2, "com.motorola.spellingcheckservice.SPELLINGCHECK_SERVICE"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v0

    if-eqz v0, :cond_1

    move v0, v3

    .line 1401
    :goto_0
    return v0

    .line 1398
    :cond_1
    const/4 v0, 0x0

    goto :goto_0

    :cond_2
    move v0, v3

    .line 1401
    goto :goto_0
.end method

.method private updateContext(Landroid/content/Context;)V
    .locals 2
    .parameter "context"

    .prologue
    .line 1333
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    if-eq v0, v1, :cond_0

    .line 1334
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    .line 1335
    new-instance v0, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    invoke-direct {v0, p0, v1}, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    .line 1341
    :cond_0
    return-void
.end method


# virtual methods
.method public addWord(ILjava/lang/String;)V
    .locals 4
    .parameter "dictID"
    .parameter "word"

    .prologue
    .line 661
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v1

    .line 662
    .local v1, index:I
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v2, :cond_0

    if-ltz v1, :cond_0

    if-eqz p2, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v2

    if-gtz v2, :cond_1

    .line 672
    .end local p0
    :cond_0
    :goto_0
    return-void

    .line 668
    .restart local p0
    :cond_1
    :try_start_0
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v3, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    invoke-virtual {p2, v3}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v3

    invoke-interface {v2, p1, v3}, Lcom/motorola/spellchecker/ISpellingCheckService;->addWord(I[B)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 669
    :catch_0
    move-exception v2

    move-object v0, v2

    .line 670
    .local v0, e:Ljava/lang/Exception;
    const-string v2, "*** SpellingCheckManager ***"

    const-string v3, "error when adding word!!!"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public afterImeAddWord()V
    .locals 3

    .prologue
    .line 1281
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_0

    .line 1283
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v1}, Lcom/motorola/spellchecker/ISpellingCheckService;->afterImeAddWord()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1288
    :cond_0
    :goto_0
    return-void

    .line 1284
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 1285
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    invoke-virtual {v0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public attachSpellCheckerFlags(ILjava/lang/CharSequence;Ljava/lang/String;Z)Ljava/lang/CharSequence;
    .locals 9
    .parameter "dictID"
    .parameter "cs"
    .parameter "suggestions"
    .parameter "forcingNoUIFlags"

    .prologue
    const/16 v8, 0x21

    const/4 v7, 0x0

    .line 1027
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v5

    if-gez v5, :cond_0

    .line 1033
    :cond_0
    invoke-virtual {p2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    .line 1034
    .local v3, str:Ljava/lang/String;
    const/4 v2, 0x0

    .line 1035
    .local v2, spannable:Landroid/text/SpannableString;
    iget-boolean v5, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    if-eqz v5, :cond_2

    if-nez p4, :cond_2

    .line 1036
    invoke-virtual {p0, p1, v3}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(ILjava/lang/String;)I

    move-result v5

    if-nez v5, :cond_2

    .line 1041
    const/4 v4, 0x0

    .line 1042
    .local v4, wordWithNumber:Z
    const/4 v1, 0x0

    .local v1, i:I
    :goto_0
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v1, v5, :cond_1

    .line 1043
    invoke-virtual {v3, v1}, Ljava/lang/String;->charAt(I)C

    move-result v0

    .line 1044
    .local v0, c:C
    const/16 v5, 0x30

    if-lt v0, v5, :cond_5

    const/16 v5, 0x39

    if-gt v0, v5, :cond_5

    .line 1045
    const/4 v4, 0x1

    .line 1050
    .end local v0           #c:C
    :cond_1
    if-nez v4, :cond_2

    .line 1051
    new-instance v2, Landroid/text/SpannableString;

    .end local v2           #spannable:Landroid/text/SpannableString;
    invoke-direct {v2, p2}, Landroid/text/SpannableString;-><init>(Ljava/lang/CharSequence;)V

    .line 1052
    .restart local v2       #spannable:Landroid/text/SpannableString;
    new-instance v5, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    const v6, -0x7013e3dc

    invoke-direct {v5, v6}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;-><init>(I)V

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v2, v5, v7, v6, v8}, Landroid/text/SpannableString;->setSpan(Ljava/lang/Object;III)V

    .line 1058
    .end local v1           #i:I
    .end local v4           #wordWithNumber:Z
    :cond_2
    if-eqz p3, :cond_4

    invoke-virtual {p3}, Ljava/lang/String;->length()I

    move-result v5

    if-lez v5, :cond_4

    .line 1059
    if-nez v2, :cond_3

    .line 1060
    new-instance v2, Landroid/text/SpannableString;

    .end local v2           #spannable:Landroid/text/SpannableString;
    invoke-direct {v2, p2}, Landroid/text/SpannableString;-><init>(Ljava/lang/CharSequence;)V

    .line 1062
    .restart local v2       #spannable:Landroid/text/SpannableString;
    :cond_3
    new-instance v5, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-direct {v5, v3, p3}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v2, v5, v7, v6, v8}, Landroid/text/SpannableString;->setSpan(Ljava/lang/Object;III)V

    .line 1065
    :cond_4
    if-nez v2, :cond_6

    move-object v5, p2

    .line 1068
    :goto_1
    return-object v5

    .line 1042
    .restart local v0       #c:C
    .restart local v1       #i:I
    .restart local v4       #wordWithNumber:Z
    :cond_5
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .end local v0           #c:C
    .end local v1           #i:I
    .end local v4           #wordWithNumber:Z
    :cond_6
    move-object v5, v2

    .line 1068
    goto :goto_1
.end method

.method public beforeImeAddWord()V
    .locals 3

    .prologue
    .line 1268
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_0

    .line 1270
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v1}, Lcom/motorola/spellchecker/ISpellingCheckService;->beforeImeAddWord()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1275
    :cond_0
    :goto_0
    return-void

    .line 1271
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 1272
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    invoke-virtual {v0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public closeDict(I)V
    .locals 5
    .parameter "dictID"

    .prologue
    const/4 v4, 0x1

    .line 584
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v1

    .line 585
    .local v1, index:I
    if-gez v1, :cond_1

    .line 606
    :cond_0
    :goto_0
    return-void

    .line 587
    :cond_1
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget v2, v2, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    if-ne v2, v4, :cond_3

    .line 588
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    iget v2, v2, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->mDictID:I

    if-ne v2, p1, :cond_2

    .line 590
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    iput-boolean v4, v2, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->mPendingCloseDictRequest:Z

    goto :goto_0

    .line 593
    :cond_2
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 599
    :goto_1
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v2, :cond_0

    .line 601
    :try_start_0
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v2, p1}, Lcom/motorola/spellchecker/ISpellingCheckService;->closeDict(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 602
    :catch_0
    move-exception v2

    move-object v0, v2

    .line 603
    .local v0, e:Landroid/os/RemoteException;
    const-string v2, "*** SpellingCheckManager ***"

    const-string v3, "error when try to close Dict!!!"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 596
    .end local v0           #e:Landroid/os/RemoteException;
    :cond_3
    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget v3, v2, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    sub-int/2addr v3, v4

    iput v3, v2, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    goto :goto_1
.end method

.method public getSpellCheckerAnnotations(Landroid/text/Spanned;)[Ljava/lang/String;
    .locals 6
    .parameter "text"

    .prologue
    const/4 v5, 0x0

    .line 1092
    invoke-interface {p1}, Landroid/text/Spanned;->length()I

    move-result v3

    const-class v4, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    invoke-interface {p1, v5, v3, v4}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;

    .line 1093
    .local v2, spans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    if-eqz v2, :cond_0

    array-length v3, v2

    if-lez v3, :cond_0

    .line 1094
    aget-object v0, v2, v5

    .line 1095
    .local v0, annotation:Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    const/4 v3, 0x2

    new-array v1, v3, [Ljava/lang/String;

    invoke-virtual {v0}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;->getKey()Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const/4 v3, 0x1

    invoke-virtual {v0}, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;->getValue()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v3

    .local v1, ret:[Ljava/lang/String;
    move-object v3, v1

    .line 1099
    .end local v0           #annotation:Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerAnnotation;
    .end local v1           #ret:[Ljava/lang/String;
    :goto_0
    return-object v3

    :cond_0
    const/4 v3, 0x0

    goto :goto_0
.end method

.method public hasSpellCheckerFlags(Landroid/text/Spanned;)Z
    .locals 4
    .parameter "text"

    .prologue
    const/4 v3, 0x0

    .line 1079
    invoke-interface {p1}, Landroid/text/Spanned;->length()I

    move-result v1

    const-class v2, Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    invoke-interface {p1, v3, v1, v2}, Landroid/text/Spanned;->getSpans(IILjava/lang/Class;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;

    .line 1080
    .local v0, spans:[Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
    if-eqz v0, :cond_0

    array-length v1, v0

    if-lez v1, :cond_0

    const/4 v1, 0x1

    :goto_0
    return v1

    :cond_0
    move v1, v3

    goto :goto_0
.end method

.method public isConnectionEstablished()Z
    .locals 1

    .prologue
    .line 525
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public isServiceEnabled()Z
    .locals 1

    .prologue
    .line 654
    iget-boolean v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    return v0
.end method

.method public openDict(Ljava/lang/String;)I
    .locals 6
    .parameter "localeString"

    .prologue
    .line 538
    const/4 v0, 0x0

    .line 543
    .local v0, dictID:I
    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v4, :cond_1

    .line 549
    if-nez p1, :cond_0

    .line 550
    :try_start_0
    const-string p1, "default"

    .line 553
    :cond_0
    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v4, p1}, Lcom/motorola/spellchecker/ISpellingCheckService;->openDict(Ljava/lang/String;)I

    move-result v0

    .line 554
    if-lez v0, :cond_1

    .line 555
    invoke-direct {p0, v0}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v3

    .line 556
    .local v3, index:I
    if-gez v3, :cond_2

    .line 557
    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v4, v0}, Lcom/motorola/spellchecker/ISpellingCheckService;->getDictEncoding(I)Ljava/lang/String;

    move-result-object v1

    .line 558
    .local v1, dict_encoding:Ljava/lang/String;
    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    new-instance v5, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    invoke-direct {v5, p0, v0, v1}, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;-><init>(Lcom/motorola/spellchecker/SpellingCheckManager;ILjava/lang/String;)V

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 575
    .end local v1           #dict_encoding:Ljava/lang/String;
    .end local v3           #index:I
    .end local p0
    :cond_1
    :goto_0
    return v0

    .line 560
    .restart local v3       #index:I
    .restart local p0
    :cond_2
    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    add-int/lit8 v4, v4, 0x1

    iput v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 571
    .end local v3           #index:I
    :catch_0
    move-exception v4

    move-object v2, v4

    .line 572
    .local v2, e:Landroid/os/RemoteException;
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public removeSpellCheckerFlags(Landroid/widget/TextView;)V
    .locals 3
    .parameter "editor"

    .prologue
    .line 945
    if-eqz p1, :cond_0

    .line 946
    invoke-virtual {p1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {p1}, Landroid/widget/TextView;->length()I

    move-result v2

    invoke-static {v0, v1, v2}, Lcom/motorola/spellchecker/SpellingCheckManager;->removeSpellCheckerFlags(Ljava/lang/CharSequence;II)V

    .line 948
    :cond_0
    return-void
.end method

.method public setFlaggingEnabled(Z)V
    .locals 3
    .parameter "enable"

    .prologue
    .line 641
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_0

    .line 643
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v1, p1}, Lcom/motorola/spellchecker/ISpellingCheckService;->setFlaggingEnabled(Z)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 648
    :cond_0
    :goto_0
    return-void

    .line 644
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 645
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    const-string v2, "error when set flagging enabled!!!"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public setInputLanguage(Ljava/lang/String;)V
    .locals 3
    .parameter "language"

    .prologue
    .line 683
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-gtz v1, :cond_1

    .line 694
    :cond_0
    :goto_0
    return-void

    .line 687
    :cond_1
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_0

    .line 689
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v1, p1}, Lcom/motorola/spellchecker/ISpellingCheckService;->setInputLanguage(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 690
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 691
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    const-string v2, "error when set input language!!!"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public setOnConnectionEstablishedListener(Lcom/motorola/spellchecker/SpellingCheckManager$OnConnectionEstablishedListener;)V
    .locals 1
    .parameter "listener"

    .prologue
    .line 507
    if-nez p1, :cond_1

    .line 518
    :cond_0
    :goto_0
    return-void

    .line 511
    :cond_1
    invoke-virtual {p0}, Lcom/motorola/spellchecker/SpellingCheckManager;->isConnectionEstablished()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 512
    invoke-interface {p1}, Lcom/motorola/spellchecker/SpellingCheckManager$OnConnectionEstablishedListener;->onConnectionEstablished()V

    goto :goto_0

    .line 514
    :cond_2
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mPendingListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 515
    iget-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mPendingListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method public setSpellCheckerServiceEnabled(Z)V
    .locals 3
    .parameter "enable"

    .prologue
    .line 623
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_0

    .line 625
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    invoke-interface {v1, p1}, Lcom/motorola/spellchecker/ISpellingCheckService;->setEnabled(Z)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 630
    :cond_0
    :goto_0
    return-void

    .line 626
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 627
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    const-string v2, "error when set service enabled!!!"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public spell(ILjava/lang/String;)I
    .locals 5
    .parameter "dictID"
    .parameter "wd"

    .prologue
    const/4 v4, 0x1

    .line 703
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v1

    .line 704
    .local v1, index:I
    if-ltz v1, :cond_0

    if-eqz p2, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v3

    if-gt v3, v4, :cond_1

    :cond_0
    move v3, v4

    .line 727
    .end local p0
    :goto_0
    return v3

    .line 710
    .restart local p0
    :cond_1
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v3

    const/16 v4, 0x20

    if-le v3, v4, :cond_2

    .line 714
    const/4 v3, 0x0

    goto :goto_0

    .line 718
    :cond_2
    const/4 v2, -0x1

    .line 719
    .local v2, wordNum:I
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v3, :cond_3

    .line 721
    :try_start_0
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v4, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget-object v4, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    invoke-virtual {p2, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v4

    invoke-interface {v3, p1, v4}, Lcom/motorola/spellchecker/ISpellingCheckService;->checkWord(I[B)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v2

    :cond_3
    :goto_1
    move v3, v2

    .line 727
    goto :goto_0

    .line 722
    :catch_0
    move-exception v3

    move-object v0, v3

    .line 723
    .local v0, e:Ljava/lang/Exception;
    const/4 v2, -0x1

    goto :goto_1
.end method

.method public spell(ILandroid/widget/TextView;)V
    .locals 6
    .parameter "dictID"
    .parameter "editor"

    .prologue
    const/4 v3, 0x0

    .line 785
    if-nez p2, :cond_0

    .line 792
    :goto_0
    return-void

    .line 791
    :cond_0
    invoke-virtual {p2}, Landroid/widget/TextView;->length()I

    move-result v4

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move v5, v3

    invoke-virtual/range {v0 .. v5}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(ILandroid/widget/TextView;IIZ)V

    goto :goto_0
.end method

.method public spell(ILandroid/widget/TextView;IIZ)V
    .locals 5
    .parameter "dictID"
    .parameter "editor"
    .parameter "start"
    .parameter "end"
    .parameter "extendBoundaries"

    .prologue
    .line 862
    iget-boolean v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mServiceEnabled:Z

    if-nez v3, :cond_1

    .line 937
    :cond_0
    :goto_0
    return-void

    .line 872
    :cond_1
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v3

    if-ltz v3, :cond_0

    .line 879
    if-eqz p2, :cond_0

    .line 886
    invoke-virtual {p2}, Landroid/widget/TextView;->length()I

    move-result v1

    .line 887
    .local v1, length:I
    if-ltz p3, :cond_0

    if-ge p3, p4, :cond_0

    if-gt p3, v1, :cond_0

    .line 894
    invoke-static {p4, v1}, Ljava/lang/Math;->min(II)I

    move-result p4

    .line 896
    if-eqz p5, :cond_5

    .line 897
    invoke-virtual {p2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    .line 899
    .local v2, str:Ljava/lang/String;
    if-lez p3, :cond_3

    .line 901
    const/4 v3, 0x1

    sub-int v0, p3, v3

    .local v0, i:I
    :goto_1
    if-ltz v0, :cond_2

    .line 902
    invoke-virtual {v2, v0}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-direct {p0, v3}, Lcom/motorola/spellchecker/SpellingCheckManager;->isWordSeparator(C)Z

    move-result v3

    if-eqz v3, :cond_6

    .line 906
    :cond_2
    add-int/lit8 p3, v0, 0x1

    .line 909
    .end local v0           #i:I
    :cond_3
    if-ge p4, v1, :cond_5

    .line 911
    move v0, p4

    .restart local v0       #i:I
    :goto_2
    if-ge v0, v1, :cond_4

    .line 912
    invoke-virtual {v2, v0}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-direct {p0, v3}, Lcom/motorola/spellchecker/SpellingCheckManager;->isWordSeparator(C)Z

    move-result v3

    if-eqz v3, :cond_7

    .line 916
    :cond_4
    move p4, v0

    .line 924
    .end local v0           #i:I
    .end local v2           #str:Ljava/lang/String;
    :cond_5
    invoke-virtual {p2}, Landroid/widget/TextView;->getEditableText()Landroid/text/Editable;

    move-result-object v3

    invoke-static {v3, p3, p4}, Lcom/motorola/spellchecker/SpellingCheckManager;->removeSpellCheckerFlags(Ljava/lang/CharSequence;II)V

    .line 926
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    if-eqz v3, :cond_0

    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    iget-boolean v3, v3, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->mAvailable:Z

    if-eqz v3, :cond_0

    .line 927
    sub-int v3, p4, p3

    const/16 v4, 0xfa0

    if-le v3, v4, :cond_8

    .line 928
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    invoke-virtual {v3, p1, p2, p3, p4}, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->asyncCheckEditor(ILandroid/widget/TextView;II)V

    goto :goto_0

    .line 901
    .restart local v0       #i:I
    .restart local v2       #str:Ljava/lang/String;
    :cond_6
    add-int/lit8 v0, v0, -0x1

    goto :goto_1

    .line 911
    :cond_7
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 930
    .end local v0           #i:I
    .end local v2           #str:Ljava/lang/String;
    :cond_8
    iget-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    invoke-virtual {v3, p1, p2, p3, p4}, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->checkEditor(ILandroid/widget/TextView;II)V

    goto :goto_0
.end method

.method public spellCheckDone()V
    .locals 4

    .prologue
    const/4 v3, 0x0

    .line 1300
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    if-eqz v1, :cond_2

    .line 1301
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    if-eqz v1, :cond_0

    .line 1302
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mEditorChecker:Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;

    invoke-virtual {v1}, Lcom/motorola/spellchecker/SpellingCheckManager$EditorChecker;->onStop()V

    .line 1305
    :cond_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    if-eqz v1, :cond_1

    .line 1307
    :try_start_0
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    iget v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mClientID:I

    invoke-interface {v1, v2}, Lcom/motorola/spellchecker/ISpellingCheckService;->deregisterClient(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1312
    :goto_0
    iput-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mISpellingCheckService:Lcom/motorola/spellchecker/ISpellingCheckService;

    .line 1318
    :cond_1
    iget-object v1, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    invoke-virtual {v1, v2}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 1319
    iput-object v3, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mSpellingCheckServiceConnection:Lcom/motorola/spellchecker/SpellingCheckManager$SpellingCheckServiceConnection;

    .line 1321
    :cond_2
    return-void

    .line 1308
    :catch_0
    move-exception v1

    move-object v0, v1

    .line 1309
    .local v0, e:Landroid/os/RemoteException;
    const-string v1, "*** SpellingCheckManager ***"

    const-string v2, "Spell Client Register failed!!!"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public suggest(ILjava/lang/String;)[Ljava/lang/String;
    .locals 13
    .parameter "dictID"
    .parameter "wd"

    .prologue
    const/4 v12, 0x0

    .line 738
    invoke-direct {p0, p1}, Lcom/motorola/spellchecker/SpellingCheckManager;->isValidDictID(I)I

    move-result v3

    .line 740
    .local v3, index:I
    if-ltz v3, :cond_0

    if-eqz p2, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v10

    if-lez v10, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v10

    const/16 v11, 0x20

    if-le v10, v11, :cond_1

    :cond_0
    move-object v10, v12

    .line 775
    .end local p0
    :goto_0
    return-object v10

    .line 745
    .restart local p0
    :cond_1
    invoke-virtual {p0, p1, p2}, Lcom/motorola/spellchecker/SpellingCheckManager;->spell(ILjava/lang/String;)I

    move-result v5

    .line 746
    .local v5, ret:I
    if-nez v5, :cond_5

    .line 747
    invoke-direct {p0, p1, p2}, Lcom/motorola/spellchecker/SpellingCheckManager;->checkSug(ILjava/lang/String;)[B

    move-result-object v0

    .line 748
    .local v0, bSuggestion:[B
    if-nez v0, :cond_2

    move-object v10, v12

    .line 749
    goto :goto_0

    .line 752
    :cond_2
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    .line 753
    .local v8, suggestionList:Ljava/util/ArrayList;,"Ljava/util/ArrayList<Ljava/lang/String;>;"
    const-string v9, ""

    .line 756
    .local v9, suggests:Ljava/lang/String;
    :try_start_0
    new-instance v9, Ljava/lang/String;

    .end local v9           #suggests:Ljava/lang/String;
    iget-object v10, p0, Lcom/motorola/spellchecker/SpellingCheckManager;->mOpenedDicts:Ljava/util/ArrayList;

    invoke-virtual {v10, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    .end local p0
    check-cast p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;

    iget-object v10, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    invoke-direct {v9, v0, v10}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 762
    .restart local v9       #suggests:Ljava/lang/String;
    :goto_1
    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v4

    .line 763
    .local v4, len:I
    const/4 v6, 0x0

    .line 764
    .local v6, start:I
    const/4 v2, 0x0

    .local v2, i:I
    :goto_2
    if-ge v2, v4, :cond_4

    .line 765
    invoke-virtual {v9, v2}, Ljava/lang/String;->charAt(I)C

    move-result v10

    const/16 v11, 0x24

    if-ne v10, v11, :cond_3

    .line 766
    invoke-virtual {v9, v6, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v8, v10}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 767
    add-int/lit8 v6, v2, 0x1

    .line 764
    :cond_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 757
    .end local v2           #i:I
    .end local v4           #len:I
    .end local v6           #start:I
    .end local v9           #suggests:Ljava/lang/String;
    :catch_0
    move-exception v10

    move-object v1, v10

    .line 758
    .local v1, e:Ljava/lang/Exception;
    const-string v10, "*** SpellingCheckManager ***"

    const-string v11, "Unsupported dictionary encoding!!!"

    invoke-static {v10, v11}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 759
    new-instance v9, Ljava/lang/String;

    invoke-direct {v9, v0}, Ljava/lang/String;-><init>([B)V

    .restart local v9       #suggests:Ljava/lang/String;
    goto :goto_1

    .line 771
    .end local v1           #e:Ljava/lang/Exception;
    .restart local v2       #i:I
    .restart local v4       #len:I
    .restart local v6       #start:I
    :cond_4
    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v10

    new-array v7, v10, [Ljava/lang/String;

    .line 773
    .local v7, suggestionArray:[Ljava/lang/String;
    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/lang/String;

    move-object v10, p0

    goto :goto_0

    .end local v0           #bSuggestion:[B
    .end local v2           #i:I
    .end local v4           #len:I
    .end local v6           #start:I
    .end local v7           #suggestionArray:[Ljava/lang/String;
    .end local v8           #suggestionList:Ljava/util/ArrayList;,"Ljava/util/ArrayList<Ljava/lang/String;>;"
    .end local v9           #suggests:Ljava/lang/String;
    .restart local p0
    :cond_5
    move-object v10, v12

    .line 775
    goto :goto_0
.end method
