/**
 * 我的页面-标题行组件
 */
@Component
export struct TitleRow {

  @State title:string=''
  @State target:string=''


  build() {
    Row() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(500)
        .fontColor($r('app.color.font'))
      Navigator({ target: this.target }) {
        Row({ space: 2 }) {
          Text('查看')
            .fontColor($r('app.color.font_sub'))
            .fontSize(14)
          Image($r('app.media.ic_public_arrow_right'))
            .width(12)
            .fillColor('#89939C')
        }
      }
      .visibility(this.target ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .padding({ top: 40, bottom: 20 })
    .justifyContent(FlexAlign.SpaceBetween)
  }
}