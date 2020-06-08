unit model.init;

interface

uses
  System.Classes, System.SysUtils, System.IoUtils,

  Common.Types,

  JsonDataObjects;

type
  TInit = class
  private
    FDataBase: String;
    FPort: Integer;
    FuserName: string;
    FPassword: string;
    FcharSet: string;
    FServer: String;
  public
    property DataBase: String read FDataBase write FDataBase;
    property Server: String read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property userName: string read FuserName write FuserName;
    property Password: string read FPassword write FPassword;
    property charSet: string read FcharSet write FcharSet;

    function LoadFromFile(aFileName:String = ''): TInit;
    function SaveToFile(aFileName:String): Tinit;

    class function new():Tinit;
  end;


implementation

{ TInit }

function TInit.LoadFromFile(aFileName: String):TInit;
var
  aJson :TJsonObject;
begin
  Result := Self;
  aJson := TJsonObject.Create();
  try
    if aFileName.isEmpty then begin
      var ArrayOfFiles : TArray<String> := TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.ConfigMigration);
      if Length(ArrayOfFiles) > 0 then aFileName := ArrayOfFiles[0];

    end;

    if aFileName.isEmpty then
       raise EFilerError.CreateFMT('[TInit][LoadFromFile] ' + msgFileNotFoundByExt, [TMigrationFileExt.ConfigMigration]);

    aJson.LoadFromFile(aFileName);

    self.DataBase := aJson.Values['database'].Value;
    self.Server   := aJson.Values['server'].Value;
    self.Port     := aJson.Values['port'].IntValue;
    self.userName := aJson.Values['username'].Value;
    self.Password := aJson.Values['password'].Value;
    self.charSet  := aJson.Values['charset'].Value;

  finally
    aJson.Free;
  end;

end;

class function TInit.new: Tinit;
begin
  Result := TInit.Create();
end;

function TInit.SaveToFile(aFileName: String):TInit;
var aJson : TJsonObject;
begin
  Result := Self;
  aJson  := TJsonObject.Create();
  try
    aJson.S['database'] := EmptyStr;
    aJson.s['server']   := EmptyStr;
    aJson.i['port']     := 3050;
    aJson.S['username'] := EmptyStr;
    aJson.S['password'] := EmptyStr;
    aJson.S['charset']  := EmptyStr;

    aJson.SaveToFile(aFileName, False);

  finally
    aJson.Free;
  end;
end;

end.
