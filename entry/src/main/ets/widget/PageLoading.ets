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

          }
          .width(100)
          .height(100)
          .align(Alignment.Center)
          .backgroundColor('#80000000')
          .borderRadius(8)
        }
      }
    }
  }

}











