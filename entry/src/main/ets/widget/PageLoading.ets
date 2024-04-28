import { MaterialProgressBar, MaterialProgressStyle } from '@ohos/materialprogressbar'

export enum LoadStatus {
  LOADING,
  SUCCESS,
  FAIL,
  EMPTY
}

@Component
export struct PageLoading {

  @Link loadStatus: LoadStatus
  onReload: () => void = undefined
  @Link showLoading: boolean
  @BuilderParam content: () => void

  build() {
    Stack() {
      if(this.loadStatus === LoadStatus.LOADING) {
        MaterialProgressBar({
          style: MaterialProgressStyle.MaterialCircular,
          modelBuild: {
            color: '#055ad7',
            bgColor: '#fff',
            indeterminate: true,
            strokeWidth: 4
          }
        })
          .margin({ left: 16, top: 16 })
          .align(Alignment.Center)
      } else if(this.loadStatus === LoadStatus.SUCCESS) {
        this.content()
        if(this.showLoading) {
          Stack() {
            MaterialProgressBar({
              style: MaterialProgressStyle.MaterialCircular,
              modelBuild: {
                color: '#055ad7',
                bgColor: '#fff',
                indeterminate: true,
                strokeWidth: 4
              }
            })
              .margin({ left: 16, top: 16 })
              .align(Alignment.Center)
          }
          .width(100)
          .height(100)
          .align(Alignment.Center)
          .backgroundColor('#80000000')
          .borderRadius(8)
        }
      } else if(this.loadStatus === LoadStatus.FAIL) {
        Stack() {
          Text('加载失败，点击重试')
            .align(Alignment.Center)
        }
        .width('100%')
        .height('100%')
        .onClick(() => {
          if(this.onReload !== undefined) {
            this.onReload()
          }
        })
      } else {
        Stack() {
          Text('数据为空')
            .align(Alignment.Center)
        }
        .width('100%')
        .height('100%')
        .onClick(() => {
          if(this.onReload !== undefined) {
            this.onReload()
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }

}











