//
//  Define.h
//  Music
//
//  Created by qianfeng on 15-4-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef Music_Define_h
#define Music_Define_h

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define Info @"&deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.2.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22H30-T00%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22c5aa133090bd0d5d9ecd4163bb27f3cb%22%2C%22clid%22%3A110013000%7D"
#define HuaDongString @"http://mapi.yinyuetai.com/suggestions/front_page.json?D-A=0&rn=640*540"
#define ShouBoString @"http://mapi.yinyuetai.com/video/list.json?D-A=0&promoTitle=true&area=ALL&supportBanner=true&offset=0&size=4"
#define LiuXingString @"http://mapi.yinyuetai.com/video/list.json?D-A=0&promoTitle=true&area=POP_ALL&supportBanner=true&offset=0&size=4"
#define ReBoString @"http://mapi.yinyuetai.com/video/list.json?D-A=0&promoTitle=true&area=DAYVIEW_ALL&supportBanner=true&offset=0&size=4"
#define XiHuanString @"http://mapi.yinyuetai.com/video/guess.json?D-A=0&access_token=b225212bae2b2a82f5f8a256e87036f5&offset=0&size=20"

#define FenLeiString @"http://mapi.yinyuetai.com/recommend/video/aggregation.json?D-A=0"
//3内地
#define MLurl @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=ML&offset=0&size=20"
//4韩国
#define KRurl @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=KR&offset=0&size=20"
//5港台
#define HTurl @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=HT&offset=0&size=20"
//日本
#define JPurl @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=JP&offset=0&size=20"
//欧美
#define USurl @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=US&offset=0&size=20"
//上拉加载第一个参数JP US ML KR HT第二个参数20
#define VChartMore @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=%@&offset=%ld&size=20"
//精选
#define CHOICEurl @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=CHOICE&offset=0&size=20"
//热门
#define HOTurl @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=HOT&offset=0&size=20"
//最新
#define NEWurl @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=NEW&offset=0&size=20"
//上拉加载第一个参数CHOICE HOT NEW第二个参数20
#define TuiJianMore @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=%@&offset=%ld&size=20"
//相关MV
#define showString @"http://mapi.yinyuetai.com/video/show.json?D-A=0&relatedVideos=true&id=%@"
//
#define commentString @"http://mapi.yinyuetai.com/video/comment/list.json?D-A=0&offset=0&videoId=%@&size=10"
//和info一起使用分类的详情界面
#define MvUrl @"http://mapi.yinyuetai.com/channel/videos.json?D-A=0&detail=true&offset=0&channelId=%@&size=20"
//第一个参数20和info一起使用
#define MvUrlMore @"http://mapi.yinyuetai.com/channel/videos.json?D-A=0&detail=false&offset=%ld&channelId=%@&size=20"
//推荐列表
#define PlaylistString @"http://mapi.yinyuetai.com/playlist/show.json?D-A=0&id=%@"
//
#define SearchString @"http://mapi.yinyuetai.com/search/video.json?D-A=0&offset=0&size=20&keyword=%@"
//
#define SearchMore @"http://mapi.yinyuetai.com/search/video.json?D-A=0&area=ALL&videoType=ALL&singerType=ALL&offset=%ld&size=20&keyword=%@"
#define UMAPPKEY @"552a0260fd98c5085000021c"

#endif
