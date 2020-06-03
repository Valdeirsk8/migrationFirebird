unit Conn.Connection.DB.Firebird;

interface

uses
  System.Classes, System.SysUtils, System.IniFiles,

  Model.init,

  Conn.Interfaces, Conn.Connection;

type
  TConnConnectionFirebird = class(TConnConnection)
  private
    FDefConnection:TInit;
  protected
    procedure ConfigConnection; override;
    procedure ConfigDriverLink; override;
    procedure ConfigWaitCursor; override;

  public
    Constructor Create();override;
    Destructor Destroy();Override;

  end;

implementation

{ TConnConnectionFirebird }

procedure TConnConnectionFirebird.ConfigConnection;
begin
  Self.GetConnection.DriverName                    := 'FB';

  Self.GetConnection.Params.Values['Database']     := FDefConnection.DataBase;
  Self.GetConnection.Params.Values['Server']       := FDefConnection.Server;
  Self.GetConnection.Params.Values['Port']         := FDefConnection.Port.ToString;
  Self.GetConnection.Params.Values['User_Name']    := FDefConnection.UserName;
  Self.GetConnection.Params.Values['Password']     := FDefConnection.PassWord;
  Self.GetConnection.Params.Values['Charset']      := FDefConnection.CharSet;

  Self.GetConnection.Params.Values['GUIDEndian']   := 'Big';
  Self.GetConnection.Params.Values['PageSize']     :='16384';
  Self.GetConnection.Params.Values['DropDatabase'] :='No';
  Self.GetConnection.Params.Values['Protocol']     := 'TCPIP';
  Self.GetConnection.Params.Values['OpenMode']     := 'OpenOrCreate';
  Self.GetConnection.LoginPrompt                   := False;
  Self.GetConnection.TxOptions.AutoCommit          := True;
end;

procedure TConnConnectionFirebird.ConfigDriverLink;
begin
  Self.FDriverFirebird.DriverID  := 'FB';
  Self.FDriverFirebird.VendorLib := 'fbclient.dll';
end;

procedure TConnConnectionFirebird.ConfigWaitCursor;
begin
  {$IFDEF CONSOLE}
    FDWaitCursor.Provider := 'Console';
  {$ELSEIF FMX}
    FDWaitCursor.Provider := 'FMX';
  {$ELSE}
    FDWaitCursor.Provider := 'Forms';
  {$ENDIF}


end;

constructor TConnConnectionFirebird.Create;
begin
  FDefConnection := TInit.New().LoadFromFile;
  inherited Create();
end;

destructor TConnConnectionFirebird.Destroy;
begin
  if assigned(FDefConnection) then FreeAndNil(FDefConnection);

  inherited;
end;

end.
