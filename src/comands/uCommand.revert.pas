unit uCommand.revert;

interface

uses
  System.Classes, System.SysUtils, uCommands;

Type
  TCommandRevert = class(TInterfacedObject, ICommand)
    function Execute(aArgs:TArgs):Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation


{ TCommandRevert }

uses Core.Revert;

function TCommandRevert.Execute(aArgs:TArgs): Boolean;
begin
  Var Revert := TRevert.New(aArgs);

  try
    Revert.execute();

  finally
    FreeAndNil(Revert);
  end;

  result := true;


  result := true;
end;

function TCommandRevert.getCommandName: String;
begin
  result := 'revert';
end;

function TCommandRevert.getDescription: String;
begin
  result := 'reverte o banco configurado para uma versão anterior'
end;

initialization
  TCommands.GetInstance().RegisterCommand(TCommandRevert.Create());

end.
