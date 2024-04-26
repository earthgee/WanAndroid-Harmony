
import { PullToRefresh } from '@ohos/pulltorefresh'
import { Article } from '../net/module/Article'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { TitleBar } from '../widget/TitleBar'

@Component
export struct SquarePage {

  @State data: Array<Article> = []
  @State title: string = "广场"
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      TitleBar({
        title: $title,
        showBack: false
      })

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