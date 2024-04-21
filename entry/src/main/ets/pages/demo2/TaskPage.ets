
class Task {
  static id: number = 1
  name: string = `任务${Task.id++}`
  finished: boolean = false
}

//统一的卡片样式
@Styles function card() {
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({radius: 6, color: '#1f000000', offsetX: 2, offsetY: 2})
}

@Extend(Text) function finishedTask() {
  .decoration({type:TextDecorationType.LineThrough})
  .fontColor('#b1b2b1')
}

class StatInfo {
  totalTask: number = 0
  finishTask: number = 0
}

@Entry
@Component
struct TaskPage {

  @State stat: StatInfo = new StatInfo()

  build() {
    Column({space: 10}) {
      TaskStatistics({totalTask: this.stat.totalTask, finishTask: this.stat.finishTask})

      TaskList({stat: $stat})
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')
  }

}

@Component
struct TaskStatistics {

  @Prop totalTask: number
  @Prop finishTask: number

  build() {
    Row() {
      Text('任务进度：')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Stack() {
        Progress({value: this.finishTask, total: this.totalTask, type: ProgressType.Ring})
          .width(100)
        Row() {
          Text(this.finishTask.toString())
            .fontSize(24)
            .fontColor('#36D')
          Text(' / ' + this.totalTask.toString())
            .fontSize(24)
        }
      }
    }
    .card()
    .margin({top: 20, bottom: 10})
    .justifyContent(FlexAlign.SpaceEvenly)
  }

}

@Component
struct TaskList {

  @Link stat: StatInfo
  @State tasks: Task[] = []

  build() {
    Column() {
      Button('新增任务')
        .width(200)
        .onClick(() => {
          this.tasks.push(new Task())
          this.stat.totalTask = this.tasks.length
        })

      List({space: 10}) {
        ForEach(
          this.tasks,
          (item: Task, index: number) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontSize(20)
                Checkbox()
                  .select(item.finished)
                  .onChange(val => {
                    item.finished = val
                    this.stat.finishTask = this.tasks.filter(
                      item => item.finished
                    ).length
                  })
              }
              .card()
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .swipeAction({end: this.DeleteButton(index)})
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
    }
  }

  @Builder DeleteButton(index: number) {
    Button('delete')
      .margin(5)
      .onClick(() => {
        this.tasks.splice(index, 1)
        this.stat.totalTask = this.tasks.length
        this.stat.finishTask = this.tasks.filter(
          item => item.finished
        ).length
      })
  }

}

