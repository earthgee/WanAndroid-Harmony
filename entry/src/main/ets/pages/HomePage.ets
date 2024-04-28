import { PullToRefresh } from '@ohos/pulltorefresh'
import Api from '../net/Api'
import { Article, ArticleList, ArticleTag, HomeBannerData } from '../net/module/Article'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { TitleBar } from '../widget/TitleBar'

@Component
export struct HomePage {

  @State data: Array<Object> = []
  @State title: string = "首页"
  private scroller: Scroller = new Scroller()

  @State bannerPosition: number = 0

  @State loadStatus: LoadStatus = LoadStatus.LOADING
  @State showLoading: boolean = false

  //before build
  //组件生命周期
  async aboutToAppear() {
    this.loadData()
  }

  async loadData() {
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

  loadDataByPage(page: number): Promise<Array<Object>> {
    return new Promise<Array<Object>>(async (resolve, reject) => {
      if(page === 0) {
        let bannerRes = await Api.get().getHomeBanner()
        let topRes = await Api.get().getTopArticle()
        let articleRes = await Api.get().getHomeArticleList(page)

        if(bannerRes.isSuccessWithData()
          && topRes.isSuccessWithData()
          && articleRes.isSuccessWithData()) {
          let bannerList = bannerRes.data
          let articleList = []
          topRes.data.forEach((item) => {
            let tag = new ArticleTag()
            tag.name = "置顶"
            item.tags = [tag].concat(item.tags)
            articleList.push(item)
          })
          articleList = articleList.concat(articleRes.data.datas)
          let dataList = [bannerList].concat(articleList)
          resolve(dataList)
        } else {
          reject()
        }
      } else {
        let articleRes = await Api.get().getHomeArticleList(page)
        if(articleRes.isSuccessWithData()) {
          resolve(articleRes.data.datas)
        } else {
          reject()
        }
      }
    })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title,
        showBack: false,
        menuIcon: $r('app.media.ic_search'),
        onMenuClick: () => {
          //todo 搜索页
        }
      })

      PageLoading({
        loadStatus: $loadStatus,
        showLoading: $showLoading,
        onReload: () => {
          //todo 请求数据加载
        }
      }) {
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
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ListViewBuilder() {
    List({ scroller: this.scroller }) {
      ForEach(this.data, (item: object) => {
          ListItem() {
            if(item instanceof Array) {
              BannerBuilder({
                bannerList: item
              })
            } else {
              ArticleItemBuilder({
                article: item as Article,
              })
            }
          }
      })
    }
  }

}

@Component
struct BannerBuilder {

  swipeController: SwiperController = new SwiperController()
  @State bannerPosition: number = 0
  bannerList: Array<HomeBannerData>

  build() {
    Stack() {
      Swiper(this.swipeController) {
        ForEach(this.bannerList, (item) => {
          this.BannerItemBuilder(item)
        })
      }
      .autoPlay(true)
      .index(this.bannerPosition)
      .loop(true)
      .indicatorStyle({
        right:16,
        bottom: 0
      })
    }
    .width('100%')
    .height(220)
  }

  @Builder
  BannerItemBuilder(data: HomeBannerData) {
    Stack({ alignContent:Alignment.Bottom }) {
      Image(data.imagePath)
        .width('100%')
        .height('100%')
      Text(data.title)
        .width('100%')
        .padding({
          left:16, top:6, right:16, bottom:6
        })
        .fontColor('#fff')
        .fontSize(15)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .backgroundColor('#ccc')
    }
  }
}











