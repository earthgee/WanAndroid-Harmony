
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { Pair } from '../common/Structs'
import Api from '../net/Api'
import { Article } from '../net/module/Article'
import { IndexTree } from '../net/module/IndexTree'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { TitleBar } from '../widget/TitleBar'

//体系页面
@Component
export struct IndexPage {

  @State loadStatusTree: LoadStatus = LoadStatus.LOADING
  @State loadStatusArticle: LoadStatus = LoadStatus.LOADING
  @State showLoading: boolean = false
  @State treeList: Array<IndexTree> = []
  @State data: Array<Article> = []
  @State title: string = "体系"
  articleScroller: Scroller = new Scroller()
  @State selectTrees: Pair<IndexTree, IndexTree> = { first: undefined, second: undefined }
  @State selectTreeTemp: IndexTree = undefined
  //是否展示筛选
  @State showSelectLayer: boolean = false
  @State firstStepTrees: Array<IndexTree> = []
  @State currentSelectTree: IndexTree = undefined
  private refreshConfig = new PullToRefreshConfigurator()
  private nextPage: number = 1

  aboutToAppear() {
    this.refreshConfig.setHasRefresh(false)
    this.loadTreeData()
  }

  private async loadTreeData() {
    this.loadStatusTree = LoadStatus.LOADING
    let res = await Api.get().getTree()
    if(res.isSuccessWithData()) {
      if(res.data.length > 0) {
        this.treeList = res.data
        this.selectTreeTemp = this.treeList[0]
        this.selectTrees = { first: this.treeList[0], second: this.treeList[0].children[0] }
        this.loadStatusTree = LoadStatus.SUCCESS
        this.loadArticleData()
      } else {
        this.loadStatusTree = LoadStatus.EMPTY
      }
    } else {
      this.loadStatusTree = LoadStatus.FAIL
    }
  }

  private loadArticleData() {
    this.loadStatusArticle = LoadStatus.LOADING
    this.nextPage = 1
    this.loadArticleDataByPage(0).then(
      (data) => {
        this.data = data
        if(this.data.length === 0) {
          this.loadStatusArticle = LoadStatus.EMPTY
        } else {
          this.loadStatusArticle = LoadStatus.SUCCESS
        }
      },
      (error) => {
        this.loadStatusArticle = LoadStatus.FAIL
      }
    )
  }

  private async loadArticleDataByPage(page: number): Promise<Array<Article>> {
    let res = await Api.get().getTreeArticleList(this.selectTrees.second.id, page)
    return new Promise<Array<Article>>((resolve, reject) => {
      if(res.isSuccessWithData()) {
        let list = res.data.datas
        resolve(list)
      } else {
        reject()
      }
    })
  }

  build() {
    Column() {
      PageLoading({
        loadStatus: $loadStatusTree,
        showLoading: $showLoading,
        onReload: () => {
          this.loadTreeData()
        }
      }) {
        Column() {
          if(this.selectTrees.first && this.selectTrees.second) {
            Row() {
              Text(`${this.selectTrees.first.name} > ${this.selectTrees.second.name}`)
                .fontColor('#000')
                .fontSize(17)
                .layoutWeight(1)
              Text(`更换`)
                .margin({ left: 12 })
                .fontColor('#055ad7')
                .fontSize(16)
              Image(this.showSelectLayer? $r('app.media.ic_arrow_up') : $r('app.media.ic_arrow_down'))
                .margin({ left: 12 })
            }
            .width('100%')
            .height(48)
            .padding({ left: 16, right: 16 })
            .alignItems(VerticalAlign.Center)
            .onClick((event) => {
              if(this.showSelectLayer) {
                this.showSelectLayer = false
                this.selectTreeTemp = this.selectTrees.first
              } else {
                this.showSelectLayer = true

              }
            })
          }
        }
        .width('100%')
        .height('100%')
      }

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