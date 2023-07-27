unit view.assistenteinicial;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, EditBtn, MaskEdit, DBCtrls, uframetitulo, view.buttons,
  uframeendereco, uframecnpj, BufDataset, DB;

type

  { TPageControl }

  TPageControl = class(ComCtrls.TPageControl)
    public
      procedure AdjustClientRect(var ARect: TRect); override;
  end;


type

  { TfrmAssistenteInicial }

  TfrmAssistenteInicial = class(TfrmBasButtons)
    bdsEmpresabairro: TStringField;
    bdsEmpresacep: TStringField;
    bdsEmpresacidade: TStringField;
    bdsEmpresacnpj: TStringField;
    bdsEmpresacomplemento: TStringField;
    bdsEmpresaendereco: TStringField;
    bdsEmpresaidcidade: TLongintField;
    bdsEmpresainscricaoestadual: TStringField;
    bdsEmpresanome: TStringField;
    bdsEmpresanumero: TStringField;
    bdsEmpresarazaosocial: TStringField;
    btnServidorTeste: TButton;
    bdsEmpresa: TBufDataset;
    DataSource1: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    edAdminNome: TEdit;
    edAdminSenha: TEdit;
    edBdPassword: TEdit;
    edBdUserName: TEdit;
    edHostName: TEdit;
    edtAdminUsername: TEdit;
    edtBancoDeDados: TFileNameEdit;
    edtPorta: TEdit;
    frameCNPJ1: TframeCNPJ;
    FrameEndereco1: TFrameEndereco;
    frameTitulo1: TframeTitulo;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblServidorTesteConexao: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure acGenerico1Execute(Sender: TObject);
    procedure acGenerico2Execute(Sender: TObject);
    procedure btnServidorTesteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet1Hide(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
  private
    FCheckServer: Boolean;
    procedure SetCheckServer(AValue: Boolean);
  protected
    procedure Clear; override;
  public
    property CheckServer: Boolean read FCheckServer write SetCheckServer;
  end;

const
  C_AVANCAR = 'Avançar';
  C_CONCLUIR = 'Concluir';

var
  frmAssistenteInicial: TfrmAssistenteInicial;

implementation

uses uconst;

{$R *.lfm}

{ TPageControl }

procedure TPageControl.AdjustClientRect(var ARect: TRect);
begin
  inherited AdjustClientRect(ARect);
  ARect.Top := ARect.Top -4;
  ARect.Left := ARect.Left -4;
  ARect.Bottom := ARect.Bottom +4;
  ARect.Right := ARect.Right +4;
end;

{ TfrmAssistenteInicial }

procedure TfrmAssistenteInicial.FormCreate(Sender: TObject);
begin

  inherited;
  PageControl1.ActivePage := TabSheet2;
 // PageControl1.ShowTabs := false;

  acGenerico1.Caption := 'Avançar';
  acGenerico1.Visible := true;
  acGenerico1.Enabled := true;

  acGenerico2.Caption := 'Voltar';
  acGenerico2.Visible := true;
  acGenerico2.Enabled := false;
  CheckServer := false;

end;

procedure TfrmAssistenteInicial.TabSheet1Hide(Sender: TObject);
begin
  // Cadastra o administrador do sistema
  Sistema.Administrativo.User.Nome := edAdminNome.Text;
  Sistema.Administrativo.User.Username := edtAdminUsername.Text;
  Sistema.Administrativo.User.Password := edAdminSenha.Text;
  if Sistema.Administrativo.User.Post = 0 then
  begin
    Sistema.Mensagem.Erro('Falha ao cadastrar o usuário');
  end;
end;

procedure TfrmAssistenteInicial.TabSheet1Show(Sender: TObject);
begin
  SetFocus(edAdminNome);
end;

procedure TfrmAssistenteInicial.TabSheet3Show(Sender: TObject);
begin
  bdsEmpresa.Open;
end;

procedure TfrmAssistenteInicial.SetCheckServer(AValue: Boolean);
begin
  FCheckServer := AValue;
  if AValue = false then
  begin
    lblServidorTesteConexao.Caption := 'Failed';
    lblServidorTesteConexao.Font.Color := clRed;
  end else begin
    lblServidorTesteConexao.Caption := 'Ok';
    lblServidorTesteConexao.Font.Color := clGreen;
  end;
end;

procedure TfrmAssistenteInicial.Clear;
begin

  inherited Clear;
  edtBancoDeDados.Clear;
  lblServidorTesteConexao.Caption := '';
  edBdUserName.Caption := 'SYSDBA';
  edBdPassword.Caption := 'masterkey';
  edtPorta.Text := '3050';
  edHostName.Text := 'localhost';
  edtBancoDeDados.Text := Sistema.Config.Database.DatabaseName;
  edAdminNome.Text := 'Administrador';
  edtAdminUsername.Text := 'admin';
  edAdminSenha.Text := 'admin';

end;

procedure TfrmAssistenteInicial.acGenerico2Execute(Sender: TObject);
begin

   PageControl1.ActivePageIndex := 0;
   acGenerico2.Enabled := PageControl1.TabIndex > 0;
   acGenerico1.Caption := C_AVANCAR;

end;

procedure TfrmAssistenteInicial.btnServidorTesteClick(Sender: TObject);
begin
  with Sistema.Config.Database do
  begin
    CheckTransaction := true;
    DataBaseName := edtBancoDeDados.FileName;
    HostName := edHostName.Text;
    Port := StrToIntDef(edtPorta.Text, 3050);
    UserName := edBdUserName.Text;
    Password := edBdPassword.Text;
    Save;
    CheckServer := CheckDBConnection;
  end;

end;

procedure TfrmAssistenteInicial.acGenerico1Execute(Sender: TObject);
begin
  if acGenerico1.Caption = C_CONCLUIR then
  begin

  end else begin
    acGenerico2.Enabled := PageControl1.TabIndex > 0;

    if not CheckServer then
    begin
      Sistema.Mensagem.Alerta(SMSGFalhaConexaoBD);
      exit;
    end;

    PageControl1.TabIndex := PageControl1.TabIndex + 1;

    if PageControl1.TabIndex = (PageControl1.PageCount -1) then
    begin
      acGenerico1.Caption := C_CONCLUIR;
    end else begin
      acGenerico1.Caption := C_AVANCAR;
    end;
  end;
end;

end.

