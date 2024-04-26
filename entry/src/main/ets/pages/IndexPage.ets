
import { PullToRefresh } from '@ohos/pulltorefresh'
import { Pair } from '../common/Structs'
import { Article } from '../net/module/Article'
import { IndexTree } from '../net/module/IndexTree'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { TitleBar } from '../widget/TitleBar'

@Component
export struct IndexPage {

  @State data: Array<Article> = []
  @State title: string = "体系"
  articleScroller: Scroller = new Scroller()
  @State selectTrees: Pair<IndexTree, IndexTree> = { first: undefined, second: undefined }
  //是否展示筛选
  @State showSelectLayer: boolean = false
  @State firstStepTrees: Array<IndexTree> = []
  @State currentSelectTree: IndexTree = undefined

  build() {
    Column() {
      if(this.selectTrees.first && this.selectTrees.second) {
        Row() {
          Text(`${this.selectTrees.first.name} > ${this.selectTrees.second.name}`)
            .fontColor('#000')
            .fontSize(17)
            .layoutWeight(1)

          Button('切换分类')
            .fontColor('#fff')
            .fontSize(17)
            .borderRadius(5)
            .backgroundColor('#00f')
        }
        .width('100%')
        .height(42)
        .padding({left: 16, right:16})
      }

      Stack() {
        PullToRefresh({
          data: $data,
          scroller: this.articleScroller,
          customList: this.ListViewBuilder,
          customLoad: null,
          customRefresh: null,
        })

        if(this.showSelectLayer) {
          Column() {
            Row() {
              List() {
                ForEach(this.firstStepTrees, (item: IndexTree, index: number) => {
                   ListItem() {
                     Text(item.name)
                       .width('100%')
                       .padding(10)
                       .fontColor((this.currentSelectTree.id === item.id) ? '#055ad7': '#000')
                       .fontSize(14)
                   }
                })
              }
              .width('50%')
              .height('100%')
              .backgroundColor('#fff')

              Line()
                .width(0.5)
                .height('100%')
                .backgroundColor('#000')
              
              List() {
                ForEach(this.currentSelectTree.children, (item: IndexTree, index: number) => {
                  ListItem() {
                    Text(item.name)
                      .width('100%')
                      .padding(10)
                      .fontColor((this.selectTrees.second.id === item.id) ? '#055ad7': '#000')
                      .fontSize(14)
                  }
                })
              }
              .width('50%')
              .height('100%')
              .backgroundColor('#fff')
            }
            .width('100%')
            .height('70%')
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#80000000')
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ListViewBuilder() {
    List({ scroller: this.articleScroller }) {
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