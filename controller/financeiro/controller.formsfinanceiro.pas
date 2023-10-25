unit controller.formsfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  SysUtils, Controls, utypes;

type

  { TFormFinanceiro }

  TFormFinanceiro = class
    private
      function View(AView: TView; AList: Boolean; AID: Integer): Integer;
    public
      function Banco: Integer; overload;
      function Banco(AID: Integer): Integer; overload;
      function ContaCorrente: Integer; overload;
      function ContaCorrente(AID: Integer): Integer; overload;
      function Movimento: Integer; overload;
      function MovimentoEntrada(AIDContaCorrente: Integer): Integer;
      function MovimentoSaida(AIDContaCorrente: Integer): Integer;
  end;

implementation

uses utils, view.main, view.banco, view.cadbanco,
  view.contacorrente, view.cadcontacorrente,
  view.movfinanceiro, view.cadmovfinanceiro;

{ TFormFinanceiro }

function TFormFinanceiro.View(AView: TView; AList: Boolean; AID: Integer
  ): Integer;
begin
  case AView of
    vBanco: begin
      if (AList) then
      begin
        if not FormExists(TfrmBanco) then
          frmBanco := TfrmBanco.Create(nil);
        frmMain.TDINoteBook1.ShowFormInPage(frmBanco);
        Result := mrIgnore;
      end else begin
        frmCadBanco := TfrmCadBanco.Create(nil);
        try
          if AID = 0 then
            frmCadBanco.Insert
          else
            frmCadBanco.Edit(AID);
          Result := frmCadBanco.ShowModal;
        finally
          FreeAndNil(frmCadBanco);
        end;
      end;
    end;
    vContaCorrente: begin
      if (AList) then
      begin
        if not FormExists(TfrmContaCorrente) then
          frmContaCorrente := TfrmContaCorrente.Create(nil);
        frmMain.TDINoteBook1.ShowFormInPage(frmContaCorrente);
        Result := mrIgnore;
      end else begin
        frmCadContaCorrente := TfrmCadContaCorrente.Create(nil);
        try
          if AID = 0 then
            frmCadContaCorrente.Insert
          else
            frmCadContaCorrente.Edit(AID);
          Result := frmCadContaCorrente.ShowModal;
        finally
          FreeAndNil(frmCadContaCorrente);
        end;
      end;
    end;
    vMovFinanceiro: begin
      if not FormExists(TfrmMovFinanceiro) then
        frmMovFinanceiro := TfrmMovFinanceiro.Create(nil);
      frmMain.TDINoteBook1.ShowFormInPage(frmMovFinanceiro);
      Result := mrIgnore;
    end;
    vCadMovFinanceiroEntrada, vCadMovFinanceiroSaida: begin
      frmCadMovFinanceiro := TfrmCadMovFinanceiro.Create(nil);
      try
        frmCadMovFinanceiro.Tipo := iif(AView = vCadMovFinanceiroEntrada, tEntrada, tSaida);
        frmCadMovFinanceiro.IDContaCorrente := AID;
       Result := frmCadMovFinanceiro.ShowModal;
      finally
        FreeAndNil(frmCadMovFinanceiro);
      end;
    end;
  end;
end;

function TFormFinanceiro.Banco: Integer;
begin
  Result := View(vBanco, true, 0);
end;

function TFormFinanceiro.Banco(AID: Integer): Integer;
begin
  Result := View(vBanco, false, AID);
end;

function TFormFinanceiro.ContaCorrente: Integer;
begin
  Result := View(vContaCorrente, true, 0);
end;

function TFormFinanceiro.ContaCorrente(AID: Integer): Integer;
begin
  Result := View(vContaCorrente, false, AID);
end;

function TFormFinanceiro.Movimento: Integer;
begin

  Result := View(vMovFinanceiro, true, 0);

end;

function TFormFinanceiro.MovimentoEntrada(AIDContaCorrente: Integer): Integer;
begin
  Result := View(vCadMovFinanceiroEntrada, false, AIDContaCorrente);
end;

function TFormFinanceiro.MovimentoSaida(AIDContaCorrente: Integer): Integer;
begin
  Result := View(vCadMovFinanceiroSaida, false, AIDContaCorrente);
end;

end.

