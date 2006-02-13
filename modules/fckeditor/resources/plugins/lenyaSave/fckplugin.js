/* FCKCommands.RegisterCommand(commandName, command)
       commandName - Command name, referenced by the Toolbar, etc...
       command - Command object (must provide an Execute() function).
*/
// Register the related commands.
FCKCommands.RegisterCommand(
   'lenyaSave',
    new LenyaSaveCommand()
);

function LenyaSaveCommand()
{
  this.Name = 'lenyaSave' ;
}

LenyaSaveCommand.prototype.Execute = function()
{
  var oForm = FCK.LinkedField.form ;
  oForm.submit.click()
}

LenyaSaveCommand.prototype.GetState = function()
{
	return 0;
}

// Create the "Find" toolbar button. 
var oFindItem = new FCKToolbarButton('lenyaSave', FCKLang['lenyaSaveDlgToolbarName']);
oFindItem.IconPath = '/modules/fckeditor/FCKeditor/editor/skins/default/toolbar/save.gif' ;

// 'My_Find' is the name used in the Toolbar config.
FCKToolbarItems.RegisterItem( 'lenyaSave', oFindItem ) ;

