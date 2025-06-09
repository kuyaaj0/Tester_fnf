如果曲绘数组有多个图片
就像这样："Painting": ["assets/Pating.png","assets/Pating1.png"],那么他会按照组里的顺序依次切换，Pating.png -> Pating1.png 遍历完后将继续循环加载
如果曲绘数组为null，
就像这样："Painting": null,或者你的json里没有Painting，那么他会默认加载None0.png -> None1.png -> None2.png -> 以此类推

PS：None.png的作用可以理解为全局曲绘，也就是说你很多首歌都用同一个曲绘


If the painting array contains multiple images, like this: "Painting": ["assets/Pating.png", "assets/Pating1.png"], it will switch between them in the order they appear, transitioning from Pating.png to Pating1.png. After cycling through these, it will continue to loop. If the painting array is null, like this: "Painting": null, or if your JSON does not include Painting, it will default to loading None0.png -> None1.png -> None2.png, and so on. PS: The purpose of None.png can be understood as a global painting, meaning that many songs can use the same painting.
