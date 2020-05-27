unit uCommand.initMigration;

interface

uses
  System.Classes, System.SysUtils, System.DateUtils, System.IoUtils,


  uCommands;

Type
  TCommandInitMigration = class(TInterfacedObject, ICommand)
    function Execute():Boolean;
    function getCommandName():String;
    function getDescription():String;
  end;


implementation


{ TCommandInitMigration }

uses Model.initMigration, common.Types;

function TCommandInitMigration.Execute: Boolean;
begin

  var arrayFiles :TArray<String> := TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.ConfigMigration);
  if length(arrayFiles) = 0 then raise EFilerError.CreateFMT(msgFileNotFoundByExt, [TMigrationFileExt.ConfigMigration]);

  var Data : TDateTime := Now;
  var aFileNameVersion :String := FormatDateTime(TMigrationFormat.Migration, Data) + TMigrationFormat.Migration;
  var aFileNameRevert  :String := FormatDateTime(TMigrationFormat.Revert, Data)    + TMigrationFormat.Revert;

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
