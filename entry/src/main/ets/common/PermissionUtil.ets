import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import hilog from '@ohos.hilog';

export default class PermissionUtil {

  static requestPermission(context: Context, permissionList: Permissions[]): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      let atManager = abilityAccessCtrl.createAtManager()
      atManager.requestPermissionsFromUser(context, permissionList)
        .then((data) => {
          let grantStatus: Array<number> = data.authResults
          let length: number = grantStatus.length
          for(let i=0; i<length; i++) {
            if(grantStatus[i] !== 0) {
              reject()
            }
          }
          resolve()
        })
        .catch((err) => {
          hilog.error(0, "PermissionUtil", `requestPermissionFromUser failed, code: ${err.code}, message is ${err.message}`)
          reject()
        })
    })
  }

}




