
@Entry
@Component
export struct TitleBar {
  private title: ResourceStr

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(30)
        .fillColor($r('app.color.black'))
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Blank()
    }
    .width('100%')
    .height(42)
  }

}