/*
 * toolbar for lenya
 */

FCKConfig.ToolbarSets["Lenya"] = [
	['Source','DocProps','-','lenyaSave','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteWord','-','Print'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink','Anchor'],
	['Image','Table','Rule','Smiley','SpecialChar','PageBreak','UniversalKey'],
	['Form','Checkbox','Radio','TextField','Textarea','Select','Button','ImageButton','HiddenField'],
	'/',
	['Style','FontFormat','FontName','FontSize'],
	['TextColor','BGColor'],
	['About']
  ];  
  
﻿/*
 * plugin for save in lenya
 */  
FCKConfig.Plugins.Add( 'lenyaSave', 'de,en', '/modules/fckeditor/plugins/' ) ;