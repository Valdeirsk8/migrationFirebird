unit uCommand.migrate;

interface

uses
  System.Classes, System.SysUtils, uCommands, system.Generics.Collections;

Type

  TCommandMigrate = class(TInterfacedObject, ICommand)
    function Execute(aArgs:TArgs):Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;

implementation

{ TCommandMigrate }

uses Core.Migration;

function TCommandMigrate.Execute(aArgs:TArgs): Boolean;
begin
  Var Migration := TMigration.New(aArgs);

  try
    Migration.execute();

  finally
    FreeAndNil(Migration);
  end;

  result := true;
end;

function TCommandMigrate.getCommandName: String;
begin

  result := 'migrate';
end;

function TCommandMigrate.getDescription: String;
begin
  result := 'Atualiza o banco configurado at� a vers�o mais recente dipon�vel.';
end;


initialization
  TCommands.GetInstance().RegisterCommand(TCommandMigrate.Create());

end.
