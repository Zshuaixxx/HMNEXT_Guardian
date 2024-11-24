import { router } from '@kit.ArkUI'
import { deviceInfo } from '@kit.BasicServicesKit';
import { hidebug } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { statfs } from '@kit.CoreFileKit';
import { batteryInfo } from '@kit.BasicServicesKit';
import { LOGIN_INFO, LoginInfoResponse } from '../../../common/constants'
import { TitleRow, UsageColumn } from './comp'

@Component
export struct MyTabsComp {
  // 用户信息持久化
  @StorageLink(LOGIN_INFO) loginInfo: LoginInfoResponse = {}
  @StorageLink('topHeight') topHeight: number = 0
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChanged') currentIndex: number
  /**
   * 设备名称
   */
  @State deviceName: string = ''
  /**
   * 系统剩余电量百分比信息
   */
  @State batteryState: number = 0
  /**
   * 当前进程使用的内存
   */
  @State memorySize: number = 0
  /**
   * 当前进程CPU使用率
   */
  @State cpuUsage: number = 0
  /**
   * 系统剩余可用磁盘大小
   */
  @State statfsFreeSize: number = 0

  /**
   * 创建实例时
   */
  aboutToAppear(): void {
    this.getDeviceInfo()
    this.getDebugInfo()
    this.getStatfsInfo()
    this.getBatteryStateInfo()
  }

  /**
   * 监听tabbar切换回调函数
   */
  onTabsChanged() {
    if (this.currentIndex === 2) {
      this.getDebugInfo()
      this.getStatfsInfo()
      this.getBatteryStateInfo()
    }
  }

  /**
   * 获取设备信息
   */
  getDeviceInfo = () => {
    this.deviceName = deviceInfo.marketName
  }
  /**
   * 获取当前进程的信息
   */
  getDebugInfo = () => {
    this.cpuUsage = hidebug.getCpuUsage() * 100
    this.memorySize = Number(hidebug.getPss()) / 1000
  }
  /**
   * 获取文件系统储存信息
   */
  getStatfsInfo = () => {
    let context = getContext(this) as common.UIAbilityContext;
    let path = context.filesDir;
    this.statfsFreeSize = statfs.getFreeSizeSync(path) / (1000 * 1000 * 1000);
  }
  /**
   * 获取系统剩余电量百分比信息
   */
  getBatteryStateInfo = () => {
    this.batteryState = batteryInfo.batterySOC
  }

  build() {
    Scroll() {
      Column() {
        Stack({ alignContent: Alignment.TopEnd }) {
          // 设置按钮
          Image($r('app.media.ic_my_settings'))
            .width(22)
            .aspectRatio(1)
            .zIndex(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Settings/SettingsIndexPage' })
            })
            .margin({ top: this.topHeight + 25, right: 25 })
          // 用户信息
          Column() {
            if (this.loginInfo.accessToken) {
              // 已登录
              Column({ space: 10 }) {
                Image(this.loginInfo.avatar || $r("app.media.ic_my_avatar_default"))
                  .height(70)
                  .aspectRatio(1)
                  .borderRadius(70 / 2)
                Text(this.loginInfo.nickname)
                  .fontSize(18)
                  .fontWeight(500)
                  .fontColor($r('app.color.font'))
              }
              .onClick(() => {
                router.pushUrl({ url: 'pages/User/UserInfoPage' })
              })
            } else {
              // 未登录
              Column({ space: 10 }) {
                Image($r("app.media.ic_my_avatar_default"))
                  .height(70)
                  .aspectRatio(1)
                  .borderRadius(70 / 2)
                Text('用户登录')
                  .fontSize(18)
                  .fontWeight(500)
                  .fontColor($r('app.color.font'))
              }
              .onClick(() => {
                router.pushUrl({ url: 'pages/User/UserLoginPage' })
              })
            }
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 56 })
        }
        .height(250)
        .width('100%')

        // 硬件信息
        Column() {
          TitleRow({
            title: this.deviceName,
            target: 'pages/Hardware/HardwareIndexPage'
          }
          )
          GridRow({ columns: 3, gutter: 10 }) {
            GridCol() {
              UsageColumn({
                item: {
                  icon: $r('app.media.ic_my_cpu'),
                  name: 'CPU占用',
                  value: this.cpuUsage.toFixed(0),
                  unit: '%'
                }
              })
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/Hardware/HardwareIndexPage' })
            })

            GridCol() {
              UsageColumn({
                item: {
                  icon: $r('app.media.ic_my_ram'),
                  name: '内存占用',
                  value: this.memorySize.toFixed(0),
                  unit: 'M'
                }
              })
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/Hardware/HardwareIndexPage' })
            })

            GridCol() {
              UsageColumn({
                item: {
                  icon: $r('app.media.ic_my_storage'),
                  name: '剩余存储',
                  value: this.statfsFreeSize.toFixed(1),
                  unit: 'GB'
                }
              })
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/Hardware/HardwareIndexPage' })
            })
          }
        }
        .padding({ left: 20, right: 20 })

        // 电池管家
        Column() {
          TitleRow({
            title: '电池管家',
            target: 'pages/Battery/BatteryIndexPage'
          })
          Column() {
            Row() {
              Text(`电池剩余${this.batteryState}%`)
                .fontSize(14)
                .fontColor($r('app.color.font2'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // 环形图表
            Gauge({ value: this.batteryState, min: 0, max: 100 }) {
              Column() {
                Text(this.batteryState + '%')
                  .fontSize(30)
                  .fontWeight(500)
                  .margin({ top: 60 })
              }
              .width('100%')
              .height('100%')
            }
            .startAngle(270)
            .endAngle(90)
            .description(null)
            .colors(new LinearGradient([
              { color: $r('app.color.danger'), offset: 0 },
              { color: $r('app.color.warning'), offset: 0.2 },
              { color: $r('app.color.success'), offset: 1 },
            ]))
            .strokeWidth(12)
            .width(200)
            .height(200)
            .margin({ top: 20 })
          }
          .width('100%')
          .height(180)
          .borderRadius(6)
          .padding(15)
          .backgroundColor($r('app.color.background'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/Battery/BatteryIndexPage' })
          })
        }
        .padding({ left: 20, right: 20 })
      }
      .constraintSize({ minHeight: '100%' })
    }
    .backgroundImage('/common/images/MyPage_bg.png')
    .backgroundImageSize({ width: '100%' })
    .height('100%')
  }
}