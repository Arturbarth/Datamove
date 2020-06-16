unit uThreadMoveTabela;

interface

uses
  System.Classes, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.FB, uConexoes, uParametrosConexao, uEnum, Vcl.StdCtrls;

type
  TThreadMoveTabelas = class(TThread)
  private
    FcMsg: String;
    FeTpLog: tpLog;
    FModelFirebird: TModelConexao;
    FModelOracle: TModelConexao;
    qryTabelas: TFDQuery;
    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;
    procedure Logar(eTpLog: tpLog; cMsg: String);
    procedure SyncLogar;
    procedure ConfigurarConexoes;
    procedure MoverTabela(cTabela: String; nLinhas: Integer);
  protected
    procedure Execute; override;
  public
    FmeLog: TMemo;
    FmeErros: TMemo;
    FConsulta: String;
    FTabela: String;
    FLinhas: Integer;
    FpbStatus: TProgressBar;
    FnTotalTabelas: Integer;
    FnTabelaAtual: Integer;
    Finalizou: Boolean;
    FParOracle, FParmFirebird: IParametrosConexao;
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, uLog, uMoveDados;
{ TThreadMoveTabelas }

procedure TThreadMoveTabelas.Execute;
begin
  try
    ConfigurarConexoes;
    MoverTabela(FTabela, FLinhas);
  finally
    Finalizou := true;
  end;
end;

procedure TThreadMoveTabelas.MoverTabela(cTabela: String; nLinhas: Integer);
var
  dtini, dtfim, total: TDateTime;
  oMove: TMoveDados;
begin
  try
    try
      Logar(tplLog, ' : Inciando copia da tabela ' + cTabela + '('+ IntToStr(nLinhas) +' registros) - Tabela' + IntToStr(FnTabelaAtual) + ' de ' + IntToStr(FnTotalTabelas));
      dtini := Now;
      oMove := TMoveDados.Create(FDConFirebird, FDConOracle);
      oMove.MoverDadosTabela(cTabela);
      total := Now-dtini;
      Logar(tplLog, ' : Finalizada copia da tabela ' + cTabela + ' com ' +
             IntToStr(nLinhas) + ' registros ' +
             ' em ' + FormatDateTime('hh:mm:sssss', total));
    except
      on e: Exception do
        begin
        Logar(tplErro,' : Erro: ' + cTabela + ' :: '  + e.message);
      end;
    end;
  finally
    oMove.Free;
  end;
end;

procedure TThreadMoveTabelas.ConfigurarConexoes;
//var
//  oParOracle, oParmFirebird: IParametrosConexao;
begin
//  oParmFirebird := TParametrosConexao.New('127.0.0.1', '3050', 'E:\Bancos\INDIANAAGRI_MIGRA.FDB', 'VIASOFT', '153', 'FB');
  FModelFirebird := TModelConexao.Create(FParmFirebird);
  FDConFirebird := FModelFirebird.GetConexao;

//  oParOracle := TParametrosConexao.New('127.0.0.1', '1521', 'LOCAL_ORCL', 'VIASOFT', 'VIASOFT', 'Ora');
  FModelOracle := TModelConexao.Create(FParOracle);
  FDConOracle := FModelOracle.GetConexao;

  qryTabelas.Connection := FDConFirebird;
end;


constructor TThreadMoveTabelas.Create(CreateSuspended: Boolean);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;
  qryTabelas := TFDQuery.Create(nil);
end;

destructor TThreadMoveTabelas.Destroy;
begin
  FModelFirebird.Free;
  FModelOracle.Free;
  qryTabelas.Free;
  inherited;
end;

procedure TThreadMoveTabelas.Logar(eTpLog: tpLog; cMsg: String);
begin
  FcMsg := cMsg;
  FeTpLog := eTpLog;
  Synchronize(SyncLogar);
end;


procedure TThreadMoveTabelas.SyncLogar;
begin
  TLog.New.Logar(FcMsg);
  if (FeTpLog = tplLog) then
    FmeLog.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg)
  else if (FeTpLog = tplErro) then
    FmeErros.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg);
  FpbStatus.Position := Round((FnTabelaAtual/FnTotalTabelas)*100);
end;

end.
