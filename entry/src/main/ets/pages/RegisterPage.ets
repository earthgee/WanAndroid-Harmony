import { toast } from '../common/Toast'
import Api from '../net/Api'
import UserService from '../service/UserService'
import { LoadStatus, PageLoading } from '../widget/PageLoading'
import { TitleBar } from '../widget/TitleBar'
import router from '@ohos.router'

@Entry
@Component
struct RegisterPage {

  @State loadStatus: LoadStatus = LoadStatus.SUCCESS
  @State showLoading: boolean  = false
  @State title: string = "注册"
  private account: string
  private password: string
  private rePassword: string

  register() {
    if(!this.account) {
      toast('请输入用户名')
      return
    }

    if(!this.password) {
      toast('请输入密码')
      return
    }

    if(!this.rePassword) {
      toast('请二次输入密码')
      return
    }

    if(this.password !== this.rePassword) {
      toast('两次密码不一致')
      return
    }

    this.showLoading = true
    Api.get().register(this.account,
      this.password, this.rePassword).then((res) => {
      if(res.isSuccessWithData()) {
        this.showLoading = true
        toast("注册成功")
        router.back()
      } else {
        this.showLoading = false
        toast(res.errorMsg)
      }
    })

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
              .onChange((value) => {
                this.password = value
              })

            TextInput({
              placeholder: "请重复输入密码"
            })
              .margin({ top: 16 })
              .fontSize(15)
              .fontColor('#000')
              .onChange((value) => {
                this.rePassword = value
              })

            Button('注册', {
              type: ButtonType.Capsule
            })
              .width('100%')
              .margin({ top: 50 })
              .fontSize(15)
              .fontColor('#fff')
              .backgroundColor('#055ad7')
              .onClick((e) => {
                this.register()
              })
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