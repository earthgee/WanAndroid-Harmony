import { Article, ArticleTag, getArticleAuthor, getArticleChapter } from '../net/module/Article';

@Component
export struct ArticleItemBuilder {

  article: Article;

  build() {
    Column({space: 5}) {
      Row({space: 8}) {
        //标签
        ForEach(this.article.tags, (item: ArticleTag) => {
            Text(item.name)
              .fontColor('#000')
              .fontSize(10)
              .textAlign(TextAlign.Center)
              .border({
                width: 0.5,
                color: '#000',
                radius: 3
              })
        })
        //标题
        Text(getArticleAuthor(this.article))
          .layoutWeight(1)
          .fontColor('#000')
          .fontSize(12)
        //时间
        Text(this.article.niceDate)
          .fontColor('#757575')
          .fontSize(12)
      }

      Text(this.article.title)
        .width('100%')
        .fontColor('#000')
        .fontSize(15)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text(getArticleChapter(this.article))
          .fontColor("#757575")
          .fontSize(12)
        Blank()
        Image(this.article.collect ? $r('app.media.ic_like_fill') : $r('app.media.ic_like'))
          .fillColor(this.article.collect ? '#f00': '#757575')
          .width(24)
          .height(24)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, top: 10, right: 16, bottom: 10 })
  }

}