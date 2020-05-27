unit common.Types;

interface

type

  TMigrationFormat = record
  const
    Migration :String = 'v_ddmmyyyyhhmmss';
    Revert    :String = 'r_ddmmyyyyhhmmss';
  end;

  TMigrationFileExt = record
  const
    ConfigMigration :String = '.configMigration';
    Migration       :String = '.migration';
  end;

  TFindFileExpression = record
  const
    ConfigMigration :String = '*.configMigration';
    Migration       :String = 'v_*.migration';
    Revert          :String = 'r_*.migration';
  end;



resourcestring
  msgFileExists = 'Já existe um arquivo %s no diretorio %s';
  msgFileGeneratedSuccessfully = 'Arquivo %s gerado com sucesso';
  msgFileNotFoundByExt = 'Não foi encontrado um arquivo com a extenção %s';


implementation

end.
