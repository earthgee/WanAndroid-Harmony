
import router from '@ohos.router'

@Component
export struct TitleBar {
  title: string
  showBack: boolean = true
  onBack: ()=> void = ()=> {
    router.back()
  }
  menuIcon: Resource = undefined
  onMenuClick: ()=> void = undefined

  build() {
    Row() {
      if(this.showBack) {
        Image($r('app.media.ic_back'))
          .width(42)
          .height(42)
          .padding(12)
          .fillColor('#000')
          .onClick(() => {
            if(this.onBack !== undefined) {
              this.onBack()
            }
          })
      }
      Text(this.title)
        .layoutWeight(1)
        .fontSize(20)
        .fontColor('#000')
        .fontWeight(FontWeight.Bold)
        .padding({left: 16, right: 16})
      if(this.menuIcon !== undefined) {
        Image(this.menuIcon)
          .width(48)
          .height(48)
          .padding(14)
          .fillColor('#000')
          .onClick(() => {
            if(this.onMenuClick !== undefined) {
              this.onMenuClick()
            }
          })
      }
    }
    .width('100%')
    .height(42)
    .backgroundColor("#fafafa")
    .alignItems(VerticalAlign.Center)
  }

}