
import { PullToRefresh } from '@ohos/pulltorefresh'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { Article } from '../net/module/Article'

@Component
export struct WechatTabPage {

  authorId: number
  @State data: Array<Article> = []
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      PullToRefresh({
        data: $data,
        scroller: this.scroller,
        customList: this.ListViewBuilder,
        customLoad: null,
        customRefresh: null,
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ListViewBuilder() {
    List({ scroller: this.scroller }) {
      ForEach(this.data, (item: Article) => {
        ListItem() {
          ArticleItemBuilder({
            article: item
          })
        }
      })
    }
  }

}