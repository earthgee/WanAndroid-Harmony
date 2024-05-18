
import { WeChatAuthor } from '../net/module/WeChat'
import { WechatTabPage } from './WechatTabPage'
import { TitleBar } from '../widget/TitleBar'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { Article } from '../net/module/Article'
import Api from '../net/Api'

@Component
export struct WechatPage {

  @State loadStatus: LoadStatus = LoadStatus.LOADING
  @State showLoading: boolean = false
  @State title: string = "公众号"
  @State authors: Array<WeChatAuthor> = []

  aboutToAppear() {
    this.loadData()
  }

  private loadData() {
    this.loadStatus = LoadStatus.LOADING
    Api.get().getWeChatAuthorList()
      .then((res) => {
        if(res.isSuccessWithData()) {
          this.authors = res.data
          if(this.authors.length === 0) {
            this.loadStatus = LoadStatus.EMPTY
          } else {
            this.loadStatus = LoadStatus.SUCCESS
          }
        } else {
          this.loadStatus = LoadStatus.FAIL
        }
      })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title,
        showBack: false
      })

      PageLoading({
        loadStatus: $loadStatus,
        showLoading: $showLoading,
        onReload: () => {
          this.loadData()
        }
      }) {
        if(this.authors.length > 0) {
          Tabs({
            barPosition: BarPosition.Start
          }) {
            ForEach(this.authors, (author: WeChatAuthor) => {
              TabContent() {
                WechatTabPage({
                  authorId: author.id
                })
              }
              .tabBar(author.name)
            })
          }
          .width('100%')
          .height('100%')
          .scrollable(true)
          .barMode(BarMode.Scrollable)
          .barHeight(44)
        }
      }
    }
    .width('100%')
    .height('100%')
  }



}






