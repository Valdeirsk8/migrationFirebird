unit Core.ScriptExecutor;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IoUtils,

  FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,

  Conn.Connection.DB.Firebird, Conn.connection.Singleton.Firebird;

type
  TScriptExecutor = class
  Strict private
    FConexao: TConnConnectionFirebird;
    FScript: TFDScript;

  private
    procedure ConfigScriptExecutor;

  public
    Constructor Create;
    Destructor Destroy; override;
    class function New():TScriptExecutor;


    property Script: TFDScript read FScript;
  end;

implementation

{ TScriptExecutor }

constructor TScriptExecutor.Create;
begin
  inherited Create();
  Self.FConexao := TConexaoSingleton.GetInstance();
  Self.FScript  := TFDSCript.Create(nil);

  Self.ConfigScriptExecutor();
end;

destructor TScriptExecutor.Destroy;
begin
  FreeAndNil(FScript);
  inherited;
end;

class function TScriptExecutor.New: TScriptExecutor;
begin
  Result := TScriptExecutor.Create();
end;

procedure TScriptExecutor.ConfigScriptExecutor();
begin
  Self.Script.Connection := Self.FConexao.GetConnection;
  Self.Script.ScriptOptions.CommitEachNCommands := 1;
  Self.Script.ScriptOptions.EchoCommandTrim := 0;
  Self.Script.ScriptOptions.MaxStringWidth := 0;
  Self.Script.ScriptOptions.BreakOnError := True;
  Self.Script.ScriptOptions.MacroExpand := False;
  Self.Script.ScriptOptions.DriverID := Self.FConexao.GetConnection.Params.DriverID;
  Self.Script.ScriptOptions.SQLDialect := 3;
  Self.Script.ScriptOptions.RaisePLSQLErrors := True;
  Self.Script.FormatOptions.StrsEmpty2Null := True;
  //Self.ScriptExecutor.OnConsolePut := ScriptConsolePut;
  //Self.ScriptExecutor.OnError      := ScriptError;

end;

end.
