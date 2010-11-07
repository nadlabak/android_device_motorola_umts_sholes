.class Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;
.super Ljava/lang/Object;
.source "SpellingCheckManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/motorola/spellchecker/SpellingCheckManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "OpenedDictionary"
.end annotation


# instance fields
.field dictEncoding:Ljava/lang/String;

.field id:I

.field refCount:I

.field final synthetic this$0:Lcom/motorola/spellchecker/SpellingCheckManager;


# direct methods
.method public constructor <init>(Lcom/motorola/spellchecker/SpellingCheckManager;ILjava/lang/String;)V
    .locals 1
    .parameter
    .parameter "ID"
    .parameter "dict_encoding"

    .prologue
    const/4 v0, 0x0

    .line 93
    iput-object p1, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->this$0:Lcom/motorola/spellchecker/SpellingCheckManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 90
    iput v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->id:I

    .line 91
    iput v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    .line 92
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    .line 94
    iput p2, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->id:I

    .line 95
    const/4 v0, 0x1

    iput v0, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->refCount:I

    .line 96
    iput-object p3, p0, Lcom/motorola/spellchecker/SpellingCheckManager$OpenedDictionary;->dictEncoding:Ljava/lang/String;

    .line 97
    return-void
.end method
