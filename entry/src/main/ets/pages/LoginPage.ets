
import { toast } from '../common/Toast'
import Api from '../net/Api'
import UserService from '../service/UserService'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { TitleBar } from '../widget/TitleBar'
import router from '@ohos.router'
@Entry
@Component
struct LoginPage {

  @State loadStatus: LoadStatus = LoadStatus.SUCCESS
  @State showLoading: boolean = false
  @State title: string = "登录"
  private account: string
  private password: string

  async login() {
    if(!this.account) {
      toast('请输入用户名')
      return
    }
    if(!this.password) {
      toast("请输入密码")
      return
    }
    this.showLoading = true
    let res = await Api.get().login(this.account, this.password)
    this.showLoading = false
    if(res.isSuccessWithData()) {
      toast("登录成功")
      UserService.get().setUser(res.data)
      let user = await UserService.get().updateUser()
      if(user) {
        router.back()
      }
    } else {
      toast(res.errorMsg)
    }
  }

  build() {
    Column() {
      PageLoading({
        loadStatus: $loadStatus,
        showLoading: $showLoading
      }) {
        Column() {
          TitleBar({
            title: this.title
          })
          Column() {
            TextInput({
              placeholder: "请输入用户名"
            })
              .fontSize(15)
              .fontColor('#000')
              .onChange((value) => {
                this.account = value
              })

            TextInput({
              placeholder: "请输入密码"
            })
              .margin({ top: 16 })
              .fontSize(15)
              .fontColor('#000')
              .type(InputType.Password)
              .onChange((value) => {
                this.password = value
              })

            Button('登录', {
              type: ButtonType.Capsule
            })
              .width('100%')
              .margin({ top: 50 })
              .fontSize(15)
              .fontColor('#fff')
              .backgroundColor('#055ad7')
              .onClick((e) => {
                this.login()
              })

            Column()
              {
                Text('还没注册，去注册')
                  .fontSize(20)
                  .fontColor('#055ad7')
                  .decoration({
                    type: TextDecorationType.Underline,
                    color: '#055ad7'
                  })
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/RegisterPage'
                    })
                  })
              }
              .width('100%')
              .margin({ top: 20 })
              .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .layoutWeight(1)
          .margin({ top: 120 })
          .padding({ left: 16, right: 16 })


        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }

}


















