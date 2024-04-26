import { PullToRefresh } from '@ohos/pulltorefresh'
import { Article, HomeBannerData } from '../net/module/Article'
import { ArticleItemBuilder } from '../widget/ArticleItemBuilder'
import { TitleBar } from '../widget/TitleBar'

@Component
export struct HomePage {

  @State data: Array<Object> = []
  @State title: string = "首页"
  private scroller: Scroller = new Scroller()


  build() {
    Column() {
      TitleBar({
        title: this.title,
        showBack: false,
        menuIcon: $r('app.media.ic_search'),
        onMenuClick: () => {
          //todo
        }
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











