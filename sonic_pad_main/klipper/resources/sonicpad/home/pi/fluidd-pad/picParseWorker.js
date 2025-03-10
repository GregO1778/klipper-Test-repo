onmessage = function (e) {
  //通过请求获取数据
  if (e.data.type === 'getPos') {
    onHandlePos(e.data)
  } else if(e.data.type === 'setColor'){
    onHandleSetColor(e.data)
  }
}

// 解析位置坐标
function onHandlePos(e) {
  let pixs = e.data.data || []
  let pixelPosition = []
  let ymin = 0
  let ymax = 0
  let isFirstFlag = true
  let width = e.data.width
  // 得到最低非透明像素点的高度
  for(let i = 0; i<=pixs.length-1 ; i+=4){
    let a = pixs[i+3]
    if(a != 0){
      ymin = Math.ceil(i / 4 / width)
      break
    }
  }
  // 得到最高非透明像素点的高度及非透明像素点
  for(let i= pixs.length-1; i>=0; i-=4){
    let a = pixs[i]
    if(a != 0){
      let y = Math.ceil((i - 3) / 4 / width)
      if (isFirstFlag) {
        ymax = y
        isFirstFlag = false
      }
      let persent = Math.ceil(((ymax - y + 1) * 100) / (ymax - ymin + 1)) / 100
      let item = {persent, i: i - 3}
      pixelPosition.push(item)
    }
  }
  postMessage({pixelPosition: pixelPosition, ymin: ymin})
  self.close()
}

// 注水
function onHandleSetColor(e) {
  let currentPos = e.data.currentPos //最后绘制的点位置
  let value = e.data.value   //百分比数字
  let pixelPosition = e.data.pixelPosition// 非透明像素对象。包含
  let imgData = e.data.imgData
  for (let k = currentPos; k < pixelPosition.length - 1 ; k++) {
    // 获取y坐标
    if (pixelPosition[k].persent <= value) {
      imgData.data[pixelPosition[k].i] = 0;
      imgData.data[pixelPosition[k].i+1] = imgData.data[pixelPosition[k].i+2];
      imgData.data[pixelPosition[k].i+2] = 238;
    } else {
      currentPos = k
      break
    }
  }
  postMessage({
    currentPos: currentPos,
    imgData: imgData
  })
  self.close()
}