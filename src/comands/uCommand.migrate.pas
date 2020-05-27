unit uCommand.migrate;

interface

uses
  System.Classes, System.SysUtils, uCommands, system.Generics.Collections;

Type

  TCommandMigrate = class(TInterfacedObject, ICommand)
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;

implementation

{ TCommandMigrate }

uses Core.Migration;

function TCommandMigrate.Execute: Boolean;
begin
  TMigration
  .New
    .execute()
  .Free;

  result := true;
end;

function TCommandMigrate.getCommandName: String;
begin

  result := 'migrate';
end;

function TCommandMigrate.getDescription: String;
begin
  result := 'Atualiza o banco configurado até a versão mais recente diponível.';
end;


initialization
  TCommands.GetInstance().RegisterCommand(TCommandMigrate.Create());

end.
