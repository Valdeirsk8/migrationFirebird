program migration;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uCommand.Help in 'src\comands.core\uCommand.Help.pas',
  uCommands in 'src\comands.core\uCommands.pas',
  uCommand.init in 'src\comands\uCommand.init.pas',
  uCommand.initMigration in 'src\comands\uCommand.initMigration.pas',
  uCommand.migrate in 'src\comands\uCommand.migrate.pas',
  uCommand.revert in 'src\comands\uCommand.revert.pas',
  model.init in 'src\migration.core\model.init.pas',
  Model.initMigration in 'src\migration.core\Model.initMigration.pas',
  common.Types in 'src\_common\common.Types.pas',
  Core.Migration in 'src\migration.core\Core.Migration.pas',
  Conn.Connection.DB.Firebird in 'src\Connetion\Conn.Connection.DB.Firebird.pas',
  Conn.Connection in 'src\Connetion\Conn.Connection.pas',
  Conn.Connection.Singleton.Firebird in 'src\Connetion\Conn.Connection.Singleton.Firebird.pas',
  Conn.Interfaces in 'src\Connetion\Conn.Interfaces.pas',
  Core.Revert in 'src\migration.core\Core.Revert.pas',
  Core.ScriptExecutor in 'src\migration.core\Core.ScriptExecutor.pas';

Var
  sCommand : String;
begin
  ReportMemoryLeaksOnShutdown := True;

  try
    TCommands.GetInstance().ParseComandLine();
    TCommands.GetInstance().ExecuteCommandLine();

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
