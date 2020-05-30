unit Core.Migration;

interface

uses
  System.Classes, System.SysUtils, System.IoUtils,

  Conn.Connection.DB.Firebird, Conn.connection.Singleton.Firebird;

type

  TMigration = class
  private
    FConexao : TConnConnectionFirebird;
  public
    function Execute():TMigration;
    class function New():TMigration;
  end;

implementation

{ TMigration }

uses common.Types;

function TMigration.Execute: TMigration;
Var
  ArrayOfFiles:TArray<String>;
  S: String;
begin
  ArrayOfFiles := TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.Migration);

  //TConexaoSingleton.GetInstance().

  for S in ArrayOfFIles do begin
    writeln(s);
  end;

  Result := Self;
end;

class function TMigration.New: TMigration;
begin
  Result          := TMigration.Create();
  Result.FConexao := TConexaoSingleton.GetInstance();
end;

end.
