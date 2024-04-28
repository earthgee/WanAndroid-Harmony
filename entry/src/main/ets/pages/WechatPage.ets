
import { WeChatAuthor } from '../net/module/WeChat'
import { WechatTabPage } from './WechatTabPage'
import { TitleBar } from '../widget/TitleBar'

@Component
export struct WechatPage {

  @State title: string = "公众号"
  @State authors: Array<WeChatAuthor> = []

  build() {
    Column() {
      TitleBar({
        title: this.title,
        showBack: false
      })

      Tabs() {
        ForEach(this.authors, (item: WeChatAuthor) => {
          TabContent() {
            WechatTabPage({
              authorId: item.id
            })
          }
          .tabBar(item.name)
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }



}






