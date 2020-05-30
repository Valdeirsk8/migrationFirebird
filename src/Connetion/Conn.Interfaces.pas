unit Conn.Interfaces;

interface

uses
  System.Classes, System.SysUtils,

  FireDac.Comp.Client;

type
  IConnection = interface
    ['{9A412C87-7BE5-442B-BEBC-25B20321DBCF}']
    function GetConnection:TFDConnection;
    function GetQuery(aSql:String):TFDQuery; overload;
    function GetQuery():TFDQuery; overload;
    function GetQuery(aSql:String; Const Args : array of const):TFDQuery;overload;

    function StartTransaction:Boolean;
    function CommitTransaction:Boolean;
    function RollbackTransaction:Boolean;
    function ExecuteCommand(aSql:String):Boolean;
    function GetGenerator(aGeneratorName:String; aStep:Integer = 1):Integer;
  end;

implementation

end.
