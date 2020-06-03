unit Core.Migration;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IoUtils,

  FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,

  Conn.Connection.DB.Firebird, Conn.connection.Singleton.Firebird;

type

  TMigration = class
  private
    FConexao : TConnConnectionFirebird;
    ScriptExecutor : TFDScript;
    function GetListNoExecutedFiles: TList<String>;
    procedure InsertFilesOnDataBase;
    procedure CreateTheHistoryTable;
  public
    constructor Create();
    Destructor Destroy(); override;

    function Execute():TMigration;
    class function New():TMigration;
  end;

implementation

{ TMigration }

uses common.Types;

constructor TMigration.Create;
begin
  inherited Create();
  Self.FConexao                  := TConexaoSingleton.GetInstance();
  Self.ScriptExecutor            := TFDSCript.Create(nil);
  Self.ScriptExecutor.Connection := Self.FConexao.GetConnection;

end;

destructor TMigration.Destroy;
begin
  FreeAndNil(ScriptExecutor);
  inherited;
end;

function TMigration.Execute: TMigration;
begin
  Result := Self;

end;

class function TMigration.New: TMigration;
begin
  Result := TMigration.Create();

end;

function TMigration.GetListNoExecutedFiles():TList<String>;
begin
  InsertFilesOnDataBase();


end;

procedure TMigration.InsertFilesOnDataBase();
Const
  _Sql : String = '';

Var
  ArrayOfFiles : TArray<String>;
  QueryFiles : TFDQuery;
begin
  CreateTheHistoryTable();
  ArrayOfFiles := TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.Migration);

  QueryFiles := Self.FConexao.GetQuery(_Sql);

end;

procedure TMigration.CreateTheHistoryTable();
begin
  { TODO : Need to be implemented }
end;


end.
