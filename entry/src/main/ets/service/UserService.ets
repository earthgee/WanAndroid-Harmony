import dataPreferences from '@ohos.data.preferences';
import EntryContext from '../common/EntryContext';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import Api from '../net/Api';
import observer from '@ohos.telephony.observer';

export default class UserService {

  private static instance: UserService
  private tag = "UserService"
  private key = "user_info"
  private preferences?: dataPreferences.Preferences
  private user: User = new User()
  private userObservers: Array<(user?: User) => void> = []

  static get(): UserService {
    if(UserService.instance === undefined) {
      UserService.instance = new UserService()
    }
    return UserService.instance
  }

  private constructor() {
    this.init()
  }

  private async init() {
    let context = EntryContext.getContext() as Context
    this.preferences = await dataPreferences.getPreferences(context, 'earthgeeUserKV')
    let json = await this.preferences.get(this.key, "")
    if(json) {
      let user: User = JSON.parse(json as string)
      this.user = user
      this.notifyObserver()
      this.updateUser()
    }
  }

  isLogin(): boolean {
    if(this.user) {
      return true
    }
    return false
  }

  checkLogin(onLogin?: () => void) {
    if(this.isLogin()) {
      if(onLogin != undefined) {
        onLogin()
      }
    } else {
      promptAction.showDialog({
        title: '提示',
        message: '当前操作需要登录',
        buttons: [
          {
            text: '立即登录',
            color: '#055ad7'
          },
          {
            text: "取消",
            color: '#000'
          }
        ]
      }).then((resp) => {
        if(resp.index === 0) {
          router.pushUrl({
            url: 'pages/LoginPage'
          })
        }
      })
    }
  }

  getUser(): User | undefined {
    return this.user
  }

  setUser(user?: User) {
    if(!user) return
    this.user = user
    if(user) {
      this.preferences?.put(this.key, JSON.stringify(user))
    } else {
      this.preferences?.delete(this.key)
    }
    this.preferences?.flush()
  }

  async updateUser(): Promise<User> {
    if(this.isLogin()) {
      let res = await Api.get().getUserInfo()
      return new Promise<User>((resolve, reject) => {
        if(res.isSuccessWithData()) {
          let user = this.user
          this.user.coinCount = res.data?.coinCount ?? 0
          this.user.level = res.data?.level ?? ''
          this.user.rank = res.data?.rank ?? ''
          this.setUser(user)
          resolve(this.user)
        } else {
          reject()
        }
      })
    } else {
      return new Promise<User>((resolve, reject) => {
        reject()
      })
    }
  }

  addUserObserver(observer: (user?: User) => void) {
    if(!this.userObservers.includes(observer)) {
      this.userObservers.push(observer)
    }
  }

  removeUserObserver(observer: (user?: User) => void) {
    let index = this.userObservers.indexOf(observer)
    if(index >= 0) {
      this.userObservers.splice(index, 1)
    }
  }

  private notifyObserver() {
    this.userObservers.forEach((observer) => {
      if(observer) {
        observer(this.user)
      }
    })
  }

  clearUser() {
    this.setUser(undefined)

  }

}

export class User {
  id: number = 0
  username: string = ""
  nickname: string = ""
  chapterTops: Array<Object> = []
  coinCount: number = 0
  collectIds: Array<number> = []
  email: string = ""
  icon: string = ""
  level: string = ""
  rank: string = ""
}