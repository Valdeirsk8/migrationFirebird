unit Conn.Connection;

interface

Uses
  System.SysUtils, System.IniFiles, System.Classes, Data.DB, CodeSiteLogging,

  FireDAC.UI.Intf, FireDAC.Stan.Pool, FireDAC.Stan.Param,
  FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Stan.Error, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Phys.Intf, FireDAC.Phys.FBDef, FireDAC.Phys.FB,
  FireDAC.Phys, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  {$IFDEF  FMX}     FireDAC.FMXUI.Wait,
  {$ELSEIF Console} FireDAC.ConsoleUI.Wait,
  {$ELSE}           FireDAC.VCLUI.Wait,
  {$ENDIF}

  FireDAC.Comp.UI,

  Conn.Interfaces;


type
  TConnConnection = class(TInterfacedObject, IConnection)
  private
    procedure ConnectDataBase;

  protected
    FDataBase : TFDConnection;
    FDriverFirebird : TFDPhysFBDriverLink;
    FDWaitCursor: TFDGUIxWaitCursor;

    procedure ConfigConnection; virtual;Abstract;
    procedure ConfigDriverLink; virtual;Abstract;
    procedure ConfigWaitCursor; virtual;Abstract;
  public
    constructor Create(); Virtual;
    destructor Destroy; override;

    // IConexao
    function GetConnection: TFDConnection;
    function GetQuery(aSql: String): TFDQuery; overload;
    function GetQuery(): TFDQuery; overload; Virtual;
    function GetQuery(aSql:String; Const Args : array of const): TFDQuery; overload; Virtual;

    function StartTransaction: Boolean;
    function CommitTransaction: Boolean;
    function RollbackTransaction: Boolean;
    function ExecuteCommand(aSql: String): Boolean;

    function GetGenerator(aGeneratorName: String; aStep:Integer = 1): Integer;
  end;

implementation

constructor TConnConnection.Create();
begin
  inherited Create;
  Try
    FDataBase := TFDConnection.Create(nil);
    ConfigConnection;

    FDriverFirebird := TFDPhysFBDriverLink.Create(nil);
    ConfigDriverLink;

    FDWaitCursor := TFDGUIxWaitCursor.Create(nil);
    ConfigWaitCursor;

    Self.ConnectDataBase;
  Except
    on E: Exception do raise
  End;

end;

destructor TConnConnection.Destroy;
begin
  if Assigned(FDWaitCursor)    then FreeAndNil(FDWaitCursor);
  if Assigned(FDriverFirebird) then FreeAndNil(FDriverFirebird);
  if Assigned(FDataBase)       then FreeAndNil(FDataBase);
  inherited;
end;

function TConnConnection.ExecuteCommand(aSql: String): Boolean;
Var
 Q:TFDQuery;
begin
  Result := False;
  Q      := Self.GetQuery();
  try
    try
      Q.SQL.Clear;
      Q.SQL.Append(aSql);

      Self.StartTransaction;
      Q.ExecSQL;
      Self.CommitTransaction;
      Result := True;
    except
      on E: Exception do begin
        Self.RollbackTransaction;
        raise Exception.Create('[Error][ExecutaComandos] erro ao executar.' + #13 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Q);
  end;
end;

function TConnConnection.StartTransaction: Boolean;
begin
  Result := False;
  if not FDataBase.Connected then FDataBase.Open;
  FDataBase.StartTransaction;
  Result := True;
end;

function TConnConnection.CommitTransaction: Boolean;
begin
  Result := False;
  if FDataBase.Connected then FDataBase.Commit
  else raise Exception.Create('Não foi possivel Persistir os dados porque o Banco não esta Conectado!.');
  Result := True;
end;

function TConnConnection.GetQuery(aSql: String): TFDQuery;
begin
  try
    Result          := GetQuery();
    Result.SQL.Text := aSql;

    if Result.ParamCount = 0 then Result.Open();

  except
    on E: Exception do begin
      if assigned(Result) then FreeAndNil(Result);
      raise
    end;

  end;
end;

function TConnConnection.RollbackTransaction: Boolean;
begin
  Result := False;
  if FDataBase.Connected then FDataBase.Rollback;
  Result := True;
end;

procedure TConnConnection.ConnectDataBase;
begin
  try
    FDataBase.Open;
  except
    On E: Exception do raise Exception.Create('[Error][ConnectDataBase]: ' + E.Message);
  end;
end;

function TConnConnection.GetConnection: TFDConnection;
begin
  Result := Self.FDataBase;
end;

function TConnConnection.GetQuery: TFDQuery;
begin
  Result                               := TFDQuery.Create(nil);
  Result.Connection                    := Self.GetConnection;
  Result.CachedUpdates                 := True;
  Result.OptionsIntf.FetchOptions.Mode := fmAll;
end;

function TConnConnection.GetQuery(aSql: String; const Args: array of const): TFDQuery;
begin
  Result := Self.GetQuery(Format(aSql, Args));
end;

function TConnConnection.GetGenerator(aGeneratorName: String; aStep:Integer = 1): Integer;
var
  Q: TFDQuery;
begin
  Result := -1;
  Q      := Self.GetQuery('Select Gen_ID(%s, %d) as ID From RDB$DATABASE;',[aGeneratorName, aStep]);
  try
    Result := Q.FieldByName('ID').AsInteger;
  finally
    FreeAndNil(Q);
  end;
end;





end.
