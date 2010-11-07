.class public Lcom/motorola/spellchecker/SpellingCheckManager$SpellCheckerMarkupSpan;
.super Landroid/text/style/BackgroundColorSpan;
.source "SpellingCheckManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/motorola/spellchecker/SpellingCheckManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "SpellCheckerMarkupSpan"
.end annotation


# direct methods
.method public constructor <init>(I)V
    .locals 0
    .parameter "color"

    .prologue
    .line 60
    invoke-direct {p0, p1}, Landroid/text/style/BackgroundColorSpan;-><init>(I)V

    .line 61
    return-void
.end method

.method public constructor <init>(Landroid/os/Parcel;)V
    .locals 0
    .parameter "src"

    .prologue
    .line 64
    invoke-direct {p0, p1}, Landroid/text/style/BackgroundColorSpan;-><init>(Landroid/os/Parcel;)V

    .line 65
    return-void
.end method


# virtual methods
.method public getSpanTypeId()I
    .locals 1

    .prologue
    .line 68
    const/16 v0, 0x13

    return v0
.end method
