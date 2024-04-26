import {TitleBar} from '../../widget/TitleBar'

//全局公共样式
@Styles function fillScreen() {
  .width('100%')
  .height('100%')
  .backgroundColor('#efefef')
  .padding(20)
}

@Extend(Text) function priceText() {
  .fontColor('#f36')
  .fontSize(18)
}

@Component
struct Index {

  private items: Array<Item> = [
    new Item('华为mate60', $r('app.media.icon'), 6999, 500),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
    new Item('华为mate60', $r('app.media.icon'), 6999),
  ]

  @State stateTitle: string = "hello world"

  build() {

    Column({space: 8}) {
      TitleBar({title: $stateTitle, showBack:false})
        .onClick(() => {
          this.stateTitle = "changed text"
        })

      List({space: 8}) {
        ForEach(
          this.items,
          (item: Item) => {
            ListItem() {
              this.ItemCard(item)
            }
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
    }
    .fillScreen()
  }

  @Builder ItemCard(item: Item) {
  Row({space: 10}) {
    Image(item.image)
      .width(100)
    Column({space: 4}) {
      if(item.discount) {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('原价：$'+item.price)
          .priceText()
          .decoration({type: TextDecorationType.LineThrough})
        Text('折扣价：$'+(item.price - item.discount))
          .priceText()
        Text('补贴：$'+item.discount)
          .priceText()
      } else {
        Text(Item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('$'+item.price)
          .priceText()
      }
    }
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(20)
  .height(120)
  .padding(10)
}

}

class Item {
  name: string
  image: ResourceStr
  price: number
  discount: number

  constructor(name: string, image: ResourceStr, price: number, discount: number = 0) {
    this.name = name
    this.image = image
    this.price = price
    this.discount = discount
  }
}