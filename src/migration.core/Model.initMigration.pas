unit Model.initMigration;

interface
uses
  System.Classes, System.SysUtils,

  JsonDataObjects;

type

  TinitMigration = class
  private
    FCommandSql: string;

  public
    property CommandSql: string read FCommandSql write FCommandSql;
    function SaveToFile(aFileName:String):TinitMigration;
    function LoadFromFile(aFileName:String):TinitMigration;
    class function New():TInitMigration;

  end;

implementation

{ TinitMigration }

function TinitMigration.LoadFromFile(aFileName: String): TinitMigration;
begin
  Result := Self;
  var aJson : TjsonObject := TjsonObject.Create;
  try
    self.CommandSql :=  aJson.Values['commandSql'].Value;
  finally
    aJson.Free
  end;
end;

class function TinitMigration.New: TInitMigration;
begin
  Result := TInitMigration.Create();
end;

function TinitMigration.SaveToFile(aFileName: String): TinitMigration;
begin
  Result := Self;
  var aJson:TJsonObject := TjsonObject.Create();
  try
    aJson.S['commandSql'] := EmptyStr;

    ajson.SaveToFile(aFileName, False);

  finally
    aJson.Free;
  end;

end;

end.
