
import { UserInfo } from '../net/module/UserInfo'
@Component
export struct MePage {

  @State title: string = "我的"
  @State userInfo: UserInfo = {
    name: "",
    level: "",
    rank: "",
    point: ""
  }
  @State isLogin: boolean = false

  build() {
    Column() {
      Image($r('app.media.icon'))
        .width(100)
        .height(100)
      Text(this.userInfo.name)
        .fontColor('#000')
        .fontSize(17)
        .margin({ top: 20 })
      Row({ space: 10 }) {
        Text('LV' + this.userInfo.level)
          .fontColor('#fff')
          .fontSize(15)
          .backgroundColor('#0f0')
          .padding(3)
        Text('排名' + this.userInfo.rank)
          .fontColor('#fff')
          .fontSize(15)
          .backgroundColor('#00f')
          .padding(3)
      }
      .margin({ top: 20 })

      this.LineBuilder()
      if(this.isLogin) {
        this.MeItemBuilder("我的积分", this.userInfo.point, false)
        this.LineBuilder()
        this.MeItemBuilder("我的收藏")
        this.LineBuilder()
        this.MeItemBuilder("退出登录")
        this.LineBuilder()
      } else {
        this.MeItemBuilder("注册")
        this.LineBuilder()
        this.MeItemBuilder("登录")
        this.LineBuilder()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  MeItemBuilder(title: string, content: string = "", showIcon: boolean = true) {
    Row() {
      Text(title)
        .layoutWeight(1)
        .fontSize(15)
        .fontColor('#000')
      if(content) {
        Text(content)
          .fontSize(15)
          .fontColor('#000')
      }
      if(showIcon) {
        Image($r('app.media.ic_arrow_right'))
          .fillColor('#000')
          .width(20)
          .height(20)
      }
    }
    .width('100%')
    .height(50)
    .padding({left:16, right: 16})
    .backgroundColor('#fff')
  }

  @Builder
  LineBuilder() {
    Line()
      .width('100%')
      .height(0.5)
      .backgroundColor('#dcdcdc')
  }

}













