
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { Article } from '../net/module/Article'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import Api from '../net/Api'

@Component
export struct WechatTabPage {

  authorId: number
  @State loadStatus: LoadStatus = LoadStatus.LOADING
  @State showLoading: boolean = false
  @State data: Array<Article> = []
  private scroller: Scroller = new Scroller()
  private refreshConfig = new PullToRefreshConfigurator()
  private nextPage: number = 1
  private hasMore: boolean = true

  aboutToAppear() {
    this.refreshConfig.setHasRefresh(false)
    this.loadData()
  }

  private loadData() {
    if(this.authorId) {
      this.loadStatus = LoadStatus.LOADING
      this.loadDataByPage(0).then(
        (data) => {
          this.data = data
          if(this.data.length === 0) {
            this.loadStatus = LoadStatus.EMPTY
          } else {
            this.loadStatus = LoadStatus.SUCCESS
          }
        },
        (error) => {
          this.loadStatus = LoadStatus.FAIL
        }
      )
    }
  }

  private async loadDataByPage(page: number): Promise<Array<Article>> {
    let res = await Api.get().getWeChatArticleList(this.authorId, page)
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
        loadStatus: $loadStatus,
        showLoading: $showLoading,
        onReload: () => {
          this.loadData()
        }
      }) {
         Column() {
            PullToRefresh({
              data: $data,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: this.ListViewBuilder,
              onLoadMore: () => {
                return new Promise<string>((resolve, reject) => {
                  if(this.hasMore) {
                    this.loadDataByPage(this.nextPage).then(
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
                        resolve('加载失败')
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