unit uCommand.Help;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, System.Math,


   uCommands;

Type
  TCommandHelp = class(TInterfacedObject, ICommand)
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation

{ TCommandHelp }

function TCommandHelp.Execute: Boolean;

begin
  Const separador :String = ':';
  var Commands : TCommands := TCommands.GetInstance();
  Var slist := TStringList.Create();
  try

    for var sCommand in Commands.Keys do begin
      Var sCommandName := Commands.Items[sCommand].getCommandName;
      Var sDescription := Commands.Items[sCommand].getDescription;

      sList.Add(Format('%s %s %s',[sCommandName, separador ,sDescription]));
    end;

    var maxPosition :integer := 0;
    for Var S:String in sList do
      maxPosition := max(Pos(separador, S), maxPosition);

    for var i := 0 to pred(sList.Count) do begin
      Var arrayS :Tarray<string> := sList.Strings[i].Split(separador.ToCharArray);
      if Length(arrayS) = 2 then
        sList.Strings[i] := format('%s %s %s',[arrayS[0].padRight(maxPosition, Char(' ')), Separador, arrayS[1].Trim]);
    end;

    writeln(Format('%s%s%s',[''.padRight(40,'.') , 'Commands usages', ''.PadLeft(40,'.')]));

    writeln(sList.Text);

    Result := True;

  finally
    sList.Free;

  end;
end;

function TCommandHelp.getCommandName: String;
begin
  Result := 'help';
end;

function TCommandHelp.getDescription: String;
begin
  result := 'Comando de ajuda';
end;

initialization
  TCommands.GetInstance().RegisterCommand(TCommandHelp.Create());

end.
