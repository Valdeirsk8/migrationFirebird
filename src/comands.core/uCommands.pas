unit uCommands;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections;


type

  ICommand = Interface
    ['{2034534E-34E5-4CC5-A93D-27619EB40B40}']
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;

  TCommands = class(TObjectDictionary<String, ICommand>)
  private
    class Var Commands :TCommands;

  public
    procedure RegisterCommand(aCommand:ICommand);
    procedure ExecuteCommandLine(aCommandline:String);
    function ParseComandLine():String;
    class function GetInstance():TCommands;
  end;

implementation

{ TCommnads }

Const
  HelpCommand :String = 'HELP';

procedure TCommands.RegisterCommand(aCommand: ICommand);
begin
  Self.Add(aCommand.getCommandName.ToUpper(), aCommand);
end;

procedure TCommands.ExecuteCommandLine(aCommandline: String);
begin
  var rumHelp : boolean := aCommandline.toUpper.EndsWith(HelpCommand) and not aCommandline.ToUpper.Equals(HelpCommand);

  if rumHelp then aCommandline := copy(aCommandline, 1, aCommandline.Length - HelpCommand.Length).Trim;

  if Self.ContainsKey(aCommandline.ToUpper()) then begin
    if not rumHelp
    then self.Items[aCommandline.ToUpper()].Execute()
    else writeLn(Format('%s : %s ',[aCommandline, self.Items[aCommandline.ToUpper()].getDescription()]));
  end

  else begin
    writeLn(Format('command ''%s'' not found',[aCommandline]));
    TCommands.GetInstance().ExecuteCommandLine('help');
  end;
end;

class function TCommands.GetInstance: TCommands;
begin
  if not assigned(Commands) then
    Commands := TCommands.Create();

  result := Commands;
end;

function TCommands.ParseComandLine:string;
begin
  var TotalParams := ParamCount();
  var sCommand : string := EmptyStr;

  if TotalParams = 0 then sCommand := 'help';

  for var i := 1 to TotalParams do begin
    sCommand := sCommand + ParamStr(i) + ' ';
  end;

  result := sCommand.Trim;
end;

initialization
  TCommands.GetInstance();

finalization
  TCommands.Commands.Free;


end.
