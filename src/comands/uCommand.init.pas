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


  { TODO : Não olhar para o Nome do Arquivo apenas para o Extensão }
  if FileExists(filename) then
    raise EFilerError.CreateFmt('Já existe um arquivo %s neste diretório',[TMigrationFileExt.ConfigMigration]);

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
