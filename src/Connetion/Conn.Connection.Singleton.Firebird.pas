unit Conn.Connection.Singleton.Firebird;

interface

uses
  System.Classes, System.SysUtils,

  Conn.Connection.Db.Firebird;

type
  TConexaoSingleton = class
  private
    class var FInstance: TConnConnectionFirebird;
  public
    class function GetInstance: TConnConnectionFirebird;
  end;

implementation


class function TConexaoSingleton.GetInstance: TConnConnectionFirebird;
begin
  If FInstance = nil Then begin
    FInstance := TConnConnectionFirebird.Create();
  end;
  Result := FInstance;
end;

initialization

finalization
  if assigned(TConexaoSingleton.FInstance) then
    TConexaoSingleton.FInstance.Free;



end.
