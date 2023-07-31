unit uconst;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms;

const

  C_APP_TITLE = 'X-Tudo';
  C_INI_FORM = 'form.json';

  // Ícones SVG
  C_SVG_CLOSE = 'closesvg';
  C_SVG_SEARCH = 'search';


  C_OK = 'Ok';
  C_ATENCAO = 'Atenção';
  C_ERRO = 'Erro';
  C_EXCLUIR = 'Excluir';
  C_CANCELAR = 'Cancelar';

  // Mask
  C_CNPJ_MASK = '99.999.999/9999-99;1;_';

  // MINIMAL PASSWORD LENGTH
  C_MIN_PASSWORD_LENGHT = '5';

resourcestring

  SMSTituloExcluir = 'Confirma a exclusão?';
  SMSGExcluir = 'Deseja realmente excluir';

  // Validação
  SMSGCampoObrigatorio = 'Desculpe, mas o campo %s, é obrigatário.';
  SMSGFieldNotFoundInDataSet = 'Field %s not found in DataSet.';
  SMSGSenhaTamanhoMinimo = 'A senha deve ter no mínimo ' + C_MIN_PASSWORD_LENGHT + ' caracteres.';

  // Banco de dados
  SMSGFalhaConexaoBD = 'Falha na conexão com o banco de dados.';

implementation

end.

