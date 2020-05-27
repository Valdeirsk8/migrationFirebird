unit uCommand.revert;

interface

uses
  System.Classes, System.SysUtils, uCommands;

Type
  TCommandRevert = class(TInterfacedObject, ICommand)
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation


{ TCommandRevert }

function TCommandRevert.Execute: Boolean;
begin
  writeln('comando revert executado');
  { TODO : need to be implemented }
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
