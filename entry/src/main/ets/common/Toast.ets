import WindowUtils from './WindowUtils'
import promptAction from '@ohos.promptAction'
import hilog from '@ohos.hilog'

export function toast(message: string | Resource) {
  if(message) {
    let bottom = WindowUtils.windowHeight > 0 ? (WindowUtils.windowHeight / 2 + 'px') : 0
    hilog.info(0, "toast", `show toast, bottom = ${WindowUtils.windowHeight}`)
    promptAction.showToast({
      message: message,
      bottom: bottom
    })
  }
}