function fckloader(host, requesturi)
{
  var oFCKeditor = new FCKeditor( 'content' ) ;
  oFCKeditor.BasePath	= '/modules/fckeditor/FCKeditor/' ;
  oFCKeditor.Width="800";
  oFCKeditor.Height="700";
  oFCKeditor.Config[ "Debug" ] = true ;
  oFCKeditor.Config[ "FullPage" ] = true ;
  oFCKeditor.Config[ "BaseHref" ] = host + requesturi ;
  oFCKeditor.Config[ "ImageBrowserURL" ] = host + requesturi +'?lenya.usecase=insertImage.fckeditor' ;
  oFCKeditor.Config[ "LinkBrowserURL" ] = host + requesturi +'?lenya.module=fckeditor&lenya.step=link-show&language=en' ;
  oFCKeditor.Config[ "EditorAreaCSS" ] = '/default/authoring/css/page.css' ;
  oFCKeditor.ReplaceTextarea() ;
}