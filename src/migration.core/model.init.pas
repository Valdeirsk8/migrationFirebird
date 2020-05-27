unit model.init;

interface

uses
  System.Classes, System.SysUtils,

  JsonDataObjects;

type
  TInit = class
  private
    FDataBase: String;
    FPort: Integer;
    FuserName: string;
    FPassword: string;
    FcharSet: string;
  public
    property DataBase: String read FDataBase write FDataBase;
    property Port: Integer read FPort write FPort;
    property userName: string read FuserName write FuserName;
    property Password: string read FPassword write FPassword;
    property charSet: string read FcharSet write FcharSet;

    function LoadFromFile(aFileName:String): TInit;
    function SaveToFile(aFileName:String): Tinit;

    class function new():Tinit;
  end;


implementation

{ TInit }

function TInit.LoadFromFile(aFileName: String):TInit;
begin
  Result := Self;
  var aJson :TJsonObject := TJsonObject.Create();
  try
    aJson.LoadFromFile(aFileName);

    self.DataBase := aJson.Values['database'].Value;
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
begin
  Result := Self;
  var aJson : TJsonObject := TJsonObject.Create();
  try
    aJson.S['database'] := EmptyStr;
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
