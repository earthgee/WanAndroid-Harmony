
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { Pair } from '../common/Structs'
import Api from '../net/Api'
import { Article } from '../net/module/Article'
import { IndexTree } from '../net/module/IndexTree'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { TitleBar } from '../widget/TitleBar'
import data from '@ohos.telephony.data'

//体系页面
@Component
export struct IndexPage {

  @State loadStatusTree: LoadStatus = LoadStatus.LOADING
  @State loadStatusArticle: LoadStatus = LoadStatus.LOADING
  @State showLoading: boolean = false
  @State treeList: Array<IndexTree> = []
  @State data: Array<Article> = []
  @State title: string = "体系"
  private articleScroller: Scroller = new Scroller()
  private treeScrollLeft = new Scroller()
  private treeScrollRight = new Scroller()
  @State selectTrees: Pair<IndexTree, IndexTree> = { first: undefined, second: undefined }
  @State selectTreeTemp: IndexTree = undefined
  //是否展示筛选
  @State showSelectLayer: boolean = false
  private refreshConfig = new PullToRefreshConfigurator()
  private nextPage: number = 1
  private hasMore: boolean = true

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
                .margin({ left: 2 })
                .width(20)
                .height(48)
                .padding({top: 16, bottom: 12})
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
                setTimeout(() => {
                  let selectedIndex1 = this.treeList.findIndex(item => {
                    item.id === this.selectTrees.first.id
                  })
                  if(selectedIndex1 >= 0) {
                    this.treeScrollLeft.scrollToIndex(Math.max(selectedIndex1 - 1, 0))
                  }
                  let selectedIndex2 = this.selectTrees.first.children.findIndex(item => {
                    item.id === this.selectTrees.second.id
                  })
                  if(selectedIndex2 >= 0) {
                    this.treeScrollRight.scrollToIndex(Math.max(selectedIndex2 - 1, 0))
                  }
                }, 16)
              }
            })
          }

          Stack() {
            PageLoading({
              loadStatus: $loadStatusArticle,
              showLoading: $showLoading,
              onReload: () => {
                this.loadArticleData()
              }
            }) {
              Column() {
                PullToRefresh({
                  data: $data,
                  scroller: this.articleScroller,
                  customList: this.ListViewBuilder,
                  onLoadMore: () => {
                    return new Promise<string>((resolve, reject) => {
                      if(this.hasMore) {
                        this.loadArticleDataByPage(this.nextPage).then(
                          (data) => {
                            if(data.length > 0) {
                              this.nextPage++
                              this.data = this.data.concat(data)
                              resolve('加载成功')
                            } else {
                              this.hasMore = false
                              resolve('没有更多了')
                            }
                          },
                          (error) => {
                            resolve('没有更多了')
                          }
                        )
                      } else {
                        resolve('没有更多了')
                      }
                    })
                  },
                  customLoad: null,
                  customRefresh: null,
                })
              }
              .width('100%')
              .height('100%')
            }

            if(this.showSelectLayer) {
              Column() {
                Row() {
                  List({ scroller: this.treeScrollLeft }) {
                    ForEach(this.treeList, (item: IndexTree, index: number) => {
                      ListItem() {
                        Text(item.name)
                          .width('100%')
                          .padding({ left: 12, top: 8, right: 12, bottom: 8 })
                          .fontColor((this.selectTreeTemp.id === item.id) ? '#055ad7': '#000')
                          .fontSize(14)
                          .textAlign(TextAlign.Center)
                          .onClick(() => {
                            this.selectTreeTemp = item
                          })
                      }
                    })
                  }
                  .width('50%')
                  .height('100%')

                  Line()
                    .width(0.5)
                    .height('100%')
                    .backgroundColor('#000')

                  List({ scroller: this.treeScrollRight }) {
                    ForEach(this.selectTreeTemp.children, (item: IndexTree, index: number) => {
                      ListItem() {
                        Text(item.name)
                          .width('100%')
                          .padding({ left: 12, top: 8, right: 12, bottom: 8 })
                          .fontColor((this.selectTrees.second.id === item.id) ? '#055ad7': '#000')
                          .fontSize(14)
                          .textAlign(TextAlign.Center)
                          .onClick(() => {
                            this.selectTrees = { first: this.selectTreeTemp, second: item }
                            this.showSelectLayer = false
                            this.loadArticleData()
                          })
                      }
                    })
                  }
                  .width('50%')
                  .height('100%')
                }
                .width('100%')
                .height('70%')
                .backgroundColor('#fff')
              }
              .width('100%')
              .height('100%')
              .backgroundColor('#80000000')
              .onClick(() => {
                this.showSelectLayer = false
                this.selectTreeTemp = this.selectTrees.first
              })
            }
          }
          .width('100%')
          .layoutWeight(1)
        }
        .width('100%')
        .height('100%')
      }
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
    .width('100%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: 0.5,
      color: '#eee',
      startMargin: 16,
      endMargin: 16
    })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }


}