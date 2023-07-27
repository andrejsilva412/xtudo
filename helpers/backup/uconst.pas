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


  C_OK = 'Ok';
  C_ATENCAO = 'Atenção';
  C_ERRO = 'Erro';
  C_EXCLUIR = 'Excluir';
  C_CANCELAR = 'Cancelar';

  // Mask
  C_CNPJ_MASK = '99.999.999/9999-99;1;_';

resourcestring

  SMSTituloExcluir = 'Confirma a exclusão?';
  SMSGExcluir = 'Deseja realmente excluir';

  // Banco de dados
  SMSGFalhaConexaoBD = 'Falha na conexão com o banco de dados.';

implementation

end.

