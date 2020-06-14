unit uCommands;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.RegularExpressions;


type
  TArgs = TObjectDictionary<String, String>;

  ICommand = Interface
    ['{2034534E-34E5-4CC5-A93D-27619EB40B40}']
    function Execute(aArgs:TArgs):Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


  TCommands = class(TObjectDictionary<String, ICommand>)

  private
    class Var Commands :TCommands;

  private
     FArgs : TArgs;
     FCommand : String;
  public
    Constructor Create();
    Destructor Destroy();override;

    procedure RegisterCommand(aCommand:ICommand);
    procedure ExecuteCommandLine();
    procedure ParseComandLine();
    class function GetInstance():TCommands;
  end;

implementation

{ TCommnads }

Const
  HelpCommand :String = 'HELP';
  RegexArgs :String = '(?<=[-{1,2}|/])([a-zA-Z0-9]*)[ |:|"]*([\w|.|?|=|&|+| |:|/|\\|"]*)(?=[ |"]|$)';

procedure TCommands.RegisterCommand(aCommand: ICommand);
begin
  Self.Add(aCommand.getCommandName.ToUpper(), aCommand);
end;

constructor TCommands.Create;
begin
  inherited Create();

  FArgs := TArgs.Create();
end;

destructor TCommands.Destroy;
begin

 if Assigned(Self.FArgs) then FreeAndNil(FArgs);

  inherited;
end;

procedure TCommands.ExecuteCommandLine();
begin
  var rumHelp : boolean := Self.FCommand.toUpper.EndsWith(HelpCommand) and not Self.FCommand.ToUpper.Equals(HelpCommand);

  if rumHelp then Self.FCommand := copy(Self.FCommand, 1, Self.FCommand.Length - HelpCommand.Length).Trim;

  if Self.ContainsKey(Self.FCommand.ToUpper()) then begin
    if not rumHelp
    then self.Items[Self.FCommand.ToUpper()].Execute(Self.FArgs)
    else writeLn(Format('%s : %s ',[Self.FCommand, self.Items[Self.FCommand.ToUpper()].getDescription()]));
  end

  else begin
    writeLn(Format('command ''%s'' not found',[Self.FCommand]));
    Self.FCommand := 'help';
    TCommands.GetInstance().ExecuteCommandLine();
  end;
end;

class function TCommands.GetInstance: TCommands;
begin
  if not assigned(Commands) then
    Commands := TCommands.Create();

  result := Commands;
end;

procedure TCommands.ParseComandLine;
begin
  var TotalParams := ParamCount();
  Var S := EmptyStr;

  if TotalParams = 0 then S := 'help';
  for var i := 1 to TotalParams do S := S + ParamStr(i) + ' ';


  Var M: TMatchCollection :=  TRegEx.Matches(S, RegexArgs);

  Self.FCommand := S;
  Self.FCommand := Self.FCommand.Replace('-','',[rfReplaceall]);

  for var i := 0 to Pred(m.Count) do begin
    Var Math:TMatch := m.Item[i];

    if math.Success then begin
      var Arg := math.Value.Trim.Split([' ']);
      if Length(Arg) >= 2 then begin
        S := emptyStr;
        for var j := 1 to Length(arg)-1 do begin
          S := S  + arg[j].Trim + ' '
        end;

        Self.FArgs.Add(Arg[0], S.Trim);
      end
      else Self.FArgs.Add(Arg[0], '');




      Self.FCommand := Self.FCommand.Replace(math.Value, '');
    end;

  end;

  Self.FCommand := Self.FCommand.Trim;
end;

initialization
  TCommands.GetInstance();

finalization
  TCommands.Commands.Free;


end.
