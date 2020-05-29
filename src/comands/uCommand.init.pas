unit uCommand.init;

interface

uses
  System.Classes, System.SysUtils, system.IoUtils,


  uCommands;

Type
  TCommandInit = class(TInterfacedObject, ICommand)
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation


{ TCommandInit }

uses model.init, common.Types;

function TCommandInit.Execute: Boolean;
begin
  var dir :String := GetCurrentDir();
  var nameDir :String := dir.Replace(TPath.GetDirectoryName(dir),'').replace(TPath.DirectorySeparatorChar,'');
  var fileName := Tpath.Combine(dir, nameDir + TMigrationFileExt.ConfigMigration);


  { TODO : N�o olhar para o Nome do Arquivo apenas para o Extens�o }
  if FileExists(filename) then
    raise EFilerError.CreateFmt('J� existe um arquivo %s neste diret�rio',[TMigrationFileExt.ConfigMigration]);

  Tinit.New().SaveToFile(FileName).Free;

  Result := true;
end;

function TCommandInit.getCommandName: String;
begin
  Result := 'init';
end;

function TCommandInit.getDescription: String;
begin
  Result := 'Comando que inicializa um novo projeto de migration';
end;

initialization
  TCommands.GetInstance().RegisterCommand(TCommandInit.Create());

end.
