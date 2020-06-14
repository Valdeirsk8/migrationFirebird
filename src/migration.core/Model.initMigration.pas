unit Model.initMigration;

interface
uses
  System.Classes, System.SysUtils, System.StrUtils,

  JsonDataObjects;

type

  TinitMigration = class
  private
    FCommandSql: string;


  public
    property CommandSql: string read FCommandSql write FCommandSql;
    function SaveToFile(aFileName:String):TinitMigration;
    class function New(): TInitMigration;

  end;

implementation

{ TinitMigration }

class function TinitMigration.New(): TInitMigration;
begin
  Result := TInitMigration.Create();
end;

function TinitMigration.SaveToFile(aFileName: String): TinitMigration;
begin
  Result := Self;
  var aFile : TStringList := TStringList.Create();
  try
    aFile.Add('--Type your SQL command here.');
    aFile.SaveToFile(aFileName);

  finally
    aFile.Free;
  end;

end;

end.
