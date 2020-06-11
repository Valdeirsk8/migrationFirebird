unit Core.Revert;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IoUtils,

  FireDAC.Comp.Client, FireDAC.Comp.DataSet,

  Core.ScriptExecutor,

  Conn.Connection.DB.Firebird, Conn.connection.Singleton.Firebird;

type

  TRevert = class
  private
    FConexao : TConnConnectionFirebird;
    ScriptExecutor : TScriptExecutor;
    procedure ExecuteScript(aFileName: String);
    function GetListExecutedFiles: TArray<String>;
    function ReadIntValue(aMsg: String): Integer;
    procedure UpdateScriptExecuted(aFileName:String);

  public
    Constructor Create();
    Destructor Destroy(); override;

    function Execute(): TRevert;
    class function New():TRevert;
  end;


implementation

{ TRevert }

constructor TRevert.Create;
begin
  inherited Create();
  Self.FConexao                  := TConexaoSingleton.GetInstance();
  Self.ScriptExecutor            := TScriptExecutor.New();

end;

destructor TRevert.Destroy;
begin
  FreeAndNil(ScriptExecutor);
  inherited;
end;

class function TRevert.New: TRevert;
begin
  Result := TRevert.Create();
end;

procedure TRevert.UpdateScriptExecuted(aFileName:String);
Const
  _Sql :String = ' DELETE FROM HISTORY_MIGRATION WHERE FILE_NAME = :FILE_NAME';
begin
  var Q := Self.FConexao.GetQuery(_Sql);
  try
    Var FileName := ExtractFileName(aFileName);

    Q.ParamByName('FILE_NAME').AsString := FileName.Replace('r_', 'v_');
    Q.ExecSQL;

    writeLn('Revert executed ', FileName);
  finally
    FreeAndNil(Q);
  end;
end;

procedure TRevert.ExecuteScript(aFileName:String);
begin
  Self.FConexao.StartTransaction();
  try
    ScriptExecutor.Script.SQLScripts.Clear();
    ScriptExecutor.Script.SQLScriptFileName := aFileName;

    if ScriptExecutor.Script.ExecuteAll() then begin
      UpdateScriptExecuted(aFileName);
      Self.FConexao.CommitTransaction();
    end
    else self.FConexao.RollbackTransaction();

  except
    on E:Exception do begin
      Self.FConexao.RollbackTransaction();
      raise;
    end;

  end;

end;

function TRevert.Execute: TRevert;
begin
  Result := Self;
  Var ArrayOfFiles :TArray<String> := GetListExecutedFiles();

  for var sFileName : String in ArrayOfFiles do begin
    Var Dir := TPath.Combine(GetCurrentDir, sFileName);
    Self.ExecuteScript(Dir);
  end;

end;

function TRevert.GetListExecutedFiles():TArray<String>;
const
  _Sql:String = 'SELECT A.FILE_NAME FROM HISTORY_MIGRATION A WHERE A.EXECUTED AND ID_HISTORY > %d';
begin
  Var ID_History := ReadIntValue('To it version would you like to Revert? ');

  var Query :TFDQuery := Self.FConexao.GetQuery(_Sql, [ID_History]);
  try
    Query.Last;
    SetLength(Result, Query.RecordCount);
    while not Query.bof do begin
      Result[pred(Query.RecNo)] := Query.FieldByName('FILE_NAME').AsString.Replace('v_', 'r_');

      Query.Prior();
    end;

  finally
    FreeAndNil(Query);
  end;
end;

function TRevert.ReadIntValue(aMsg:String):Integer;
begin
  Result := -1;

   var Value : String;
   var outValue:Integer;
  repeat

    WriteLN(aMsg); Read(Value);

  until TryStrToInt(Value, outValue);

  Result := StrToInt(Value);
end;


end.
