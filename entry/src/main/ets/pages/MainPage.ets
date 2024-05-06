import PermissionUtil from '../common/PermissionUtil'
import { HomePage } from './HomePage'
import { IndexPage } from './IndexPage'
import { MePage } from './MePage'
import { SquarePage } from './SquarePage'
import { WechatPage } from './WechatPage'

@Entry
@Component
struct MainPage {

  tabsController = new TabsController()
  @State currentIndex: number = 0
  @State isPermissionGrant: boolean = false

  build() {
    if(this.isPermissionGrant) {
      Tabs({barPosition: BarPosition.End, controller: this.tabsController}) {
        TabContent() {
          HomePage()
        }.tabBar(this.TabBuilder("首页", 0, $r('app.media.ic_tab_home_fill'), $r('app.media.ic_tab_home')))

        TabContent() {
          SquarePage()
        }.tabBar(this.TabBuilder("广场", 1, $r('app.media.ic_tab_discover_fill'), $r('app.media.ic_tab_discover')))

        TabContent() {
          IndexPage()
        }.tabBar(this.TabBuilder('体系', 2, $r('app.media.ic_tab_tree_fill'), $r('app.media.ic_tab_tree')))

        TabContent() {
          WechatPage()
        }.tabBar(this.TabBuilder('公众号', 3, $r('app.media.ic_tab_wechat_fill'), $r('app.media.ic_tab_wechat')))

        TabContent() {
          MePage()
        }.tabBar(this.TabBuilder('我的', 4, $r('app.media.ic_tab_my_fill'), $r('app.media.ic_tab_my')))
      }
      .onChange((index) => {
        this.currentIndex = index
      })
      .backgroundColor('#fff')
    } else {
      Text('No Permission')
        .textAlign(TextAlign.Center)
    }
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
        .fillColor(this.currentIndex === targetIndex ? '#055ad7' : '#757575')
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#055ad7' : "#757575")
        .fontSize(11)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear() {
    PermissionUtil.requestPermission(getContext(this), ['ohos.permission.INTERNET'])
      .then((data) => {
        this.isPermissionGrant = true
      })
      .catch((err) => {
        this.isPermissionGrant = false
      })
  }

}









