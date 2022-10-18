///基础请求地址baseUrl
const PEXELS_BASE_URL = "https://api.pexels.com";

const PEXELS_VERSION = "/v1";

///精选照片path
const _apiCuratedPhotos = "/curated";

///热门视频path
const _apiVideoPopular = "/videos/popular";

///获取具体视频信息
const _apiVideoInfo = "/videos/videos";

///搜索照片path
const apiSearch = "/search";

///我的收藏列表path
const apiCollectionMine = "/collections";

///某个收藏集的内容
String apiCollectionContentMedia(String id) => "/collections/$id";

///默认数据请求认证key
const PEXELS_KEY_DEF =
    "563492ad6f917000010000019841bfce1f484ab3945c74722afe8fd1";

///获取第一页照片url
String getPexelsPhotosFirstPage() {
  return "$PEXELS_BASE_URL$PEXELS_VERSION$_apiCuratedPhotos?per_page=5";
}

///获取热门视频第一页url
String getPexelsVideoPopularFirstPage() {
  return "$PEXELS_BASE_URL$PEXELS_VERSION$_apiVideoPopular?per_page=3";
}

///获取视频详情内容
String getPexelsVideoInfoUrl(String videoId) {
  return "$PEXELS_BASE_URL$_apiVideoInfo/$videoId";
}
