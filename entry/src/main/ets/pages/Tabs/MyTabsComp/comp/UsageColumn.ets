/**
 * 我的页面-占用率组件
 */

/**
 * 占用率类型
 */
interface UsageItem {
  icon: Resource
  name: string
  value: string
  unit: string
}

@Component
export struct UsageColumn {

  @State item:UsageItem={
    icon:$r('app.media.ic_my_storage'),
    name:'',
    value:'',
    unit:''
  }

  build() {
    Column({ space: 10 }) {
      Image(this.item.icon)
        .height(28)
        .aspectRatio(1)
      Text(this.item.name)
        .fontSize(14)
        .fontColor($r('app.color.font2'))
      Text() {
        Span(this.item.value)
          .fontSize(26)
          .fontWeight(500)
        Span(' ')
        Span(this.item.unit)
      }
      .fontSize(14)
      .fontColor($r('app.color.font'))
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(120)
    .borderRadius(5)
    .padding(10)
    .backgroundColor($r('app.color.background'))
  }
}