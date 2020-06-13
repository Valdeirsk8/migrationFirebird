unit uCommand.initMigration;

interface

uses
  System.Classes, System.SysUtils, System.DateUtils, System.IoUtils,


  uCommands;

Type
  TCommandInitMigration = class(TInterfacedObject, ICommand)
    function Execute(aArgs:TArgs):Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation


{ TCommandInitMigration }

uses Model.initMigration, common.Types;

function TCommandInitMigration.Execute(aArgs:TArgs): Boolean;
var
  Data : TDateTime;
  aFileNameVersion :String;
  aFileNameRevert  :String;
begin

  if TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.ConfigMigration)[0].IsEmpty then
   raise EFilerError.CreateFMT(msgFileNotFoundByExt, [TMigrationFileExt.ConfigMigration]);

  Data             := Now;
  aFileNameVersion := FormatDateTime(TMigrationFormat.Migration, Data) + TMigrationFileExt.Migration;
  aFileNameRevert  := FormatDateTime(TMigrationFormat.Revert, Data)    + TMigrationFileExt.Migration;

  TinitMigration.New().SaveToFile(Tpath.Combine(GetCurrentDir, aFileNameVersion)).Free;
  TinitMigration.New().SaveToFile(Tpath.Combine(GetCurrentDir, aFileNameRevert )).Free;

  writeLn(Format(msgFileGeneratedSuccessfully, [aFileNameVersion]));
  writeLn(Format(msgFileGeneratedSuccessfully, [aFileNameRevert]));

  result := true;
end;

function TCommandInitMigration.getCommandName: String;
begin
  result := 'init migration';
end;

function TCommandInitMigration.getDescription: String;
begin
  Result := 'inicializa uma nova migration para um projeto já configurado.';
end;

initialization
  TCommands.GetInstance().RegisterCommand(TCommandInitMigration.Create());

end.
