
import { UserInfo } from '../net/module/UserInfo'
import UserService, { User } from '../service/UserService'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
@Component
export struct MePage {

  @State loadStatus: LoadStatus = LoadStatus.SUCCESS
  @State showLoading: boolean = false
  @State title: string = "我的"
  private unLoginInfo: UserInfo = {
    name: "未登录",
    level: "",
    rank: "",
    point: ""
  }
  @State userInfo: UserInfo = this.unLoginInfo
  @State isLogin: boolean = false
  private userObserver = (user?: User) => {
    if(user) {
      this.isLogin = true
      this.userInfo = {
        name: user.nickname,
        level: user.level,
        rank: user.rank,
        point: user.coinCount.toString()
      }
    } else {
      this.isLogin = false
      this.userInfo = this.unLoginInfo
    }
  }

  aboutToAppear() {
    UserService.get().addUserObserver(this.userObserver)
    let user = UserService.get().getUser()
    this.userObserver(user)
  }

  aboutToDisappear() {
    UserService.get().removeUserObserver(this.userObserver)
  }

  build() {
    PageLoading({
      loadStatus: $loadStatus,
      showLoading: $showLoading
    }) {
      Column() {
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
        }
        .margin({ top: 30, bottom: 50 })
        .alignItems(HorizontalAlign.Center)
        .onClick((e) => {
          UserService.get().checkLogin()
        })

        this.LineBuilder()
        this.MeItemBuilder("我的积分", this.userInfo.point, false)
        this.LineBuilder()
        this.MeItemBuilder("我的收藏")
        this.LineBuilder()
        if(this.isLogin) {
          this.MeItemBuilder("退出登录")
          this.LineBuilder()
        }
      }
      .width('100%')
      .height('100%')
    }
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













