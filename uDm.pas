{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}



unit uDm;

interface

uses
  System.SysUtils,
  FireDAC.Comp.BatchMove, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.BatchMove.DataSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  System.Threading, System.Classes, FireDAC.Comp.BatchMove.SQL,
  FireDAC.VCLUI.Wait, Vcl.StdCtrls, IBX.IBDatabase, IBX.IBExtract;
//  uIConexoes, uConexoes;

type
  TdmCon = class(TDataModule)
    FDBatchMove1: TFDBatchMove;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDBatchMoveDataSetWriter1: TFDBatchMoveDataSetWriter;
    FDCommand1: TFDCommand;
    qryOrigem: TFDQuery;
    qryDestino: TFDQuery;
    qryTabelas: TFDQuery;
    dsTabelas: TDataSource;
    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    qryGridTabelas: TFDQuery;
    dsGridTabelas: TDataSource;
    FDBatchMoveSQLReader1: TFDBatchMoveSQLReader;
    IBExtract1: TIBExtract;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    procedure FDBatchMove1Progress(ASender: TObject; APhase: TFDBatchMovePhase);
  private
    Task : ITask;
    oEvento: TNotifyEvent;
    procedure CarregarTabelasSistema;
    procedure CarregarTabelasPersonalizadas;
    procedure ExecuteCommand(cComando: String);
    procedure ExecuteCommandDestino(cComando: String);
    procedure ExecuteCommandOrigem(cComando: String);
    procedure Logar(cMsg: String);
    procedure AtualizarMigradas(cTabela: String);
    procedure LogarErros(cMsg: String);
    procedure MoverTabelas;
    procedure Notificar(Sender: TObject);
    { Private declarations }
  public
//    oConexaoOracle: iModelConexao;
//    oConexaoFirebird: iModelConexao;
    FmeLog: TMemo;
    FmeErros: TMemo;
    procedure MoverDadosTabela(cTabela: String);
    procedure MoverTabelasSistema;
    procedure MoverTabelasSistemaParalelo;
    procedure MoverTabelasPersonalizadas;
    { Public declarations }
  end;

var
  dmCon: TdmCon;

implementation

uses uLog, uMoveDados, System.Generics.Collections;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCon }

procedure TdmCon.MoverDadosTabela(cTabela: String);
begin
  qryOrigem.SQL.Text := 'SELECT * FROM ' + cTabela;
  qryOrigem.Open;

  ExecuteCommandDestino('TRUNCATE TABLE ' + cTabela);

  qryDestino.SQL.Text := 'SELECT * FROM ' + cTabela;
  qryDestino.Open;

  FDBatchMove1.Execute;
end;

procedure TdmCon.CarregarTabelasPersonalizadas;
begin
  qryTabelas.Close;
  qryTabelas.SQL.Text := 'SELECT * FROM MIGRATABELAS WHERE MIGRAR = '+ QuotedStr('S') +
                         ' AND PERSONALIZADA = ' + QuotedStr('S') + ' AND LINHAS > 0 AND MIGRADA <> ' + QuotedStr('S') +
                         ' ORDER BY LINHAS';
  qryTabelas.Open;
  qryTabelas.FetchAll;
end;

procedure TdmCon.CarregarTabelasSistema;
begin
  qryTabelas.Close;
  qryTabelas.SQL.Text := 'SELECT * FROM MIGRATABELAS WHERE MIGRAR = '+ QuotedStr('S') +
                         ' AND PERSONALIZADA <> ' + QuotedStr('S') + ' AND LINHAS >= 10 AND LINHAS <= 100 AND MIGRADA <> ' + QuotedStr('S') +
                         ' ORDER BY LINHAS';
  qryTabelas.Open;
  qryTabelas.FetchAll;
end;

procedure TdmCon.Logar(cMsg: String);
begin
  TLog.New.Logar(cMsg);
  FmeLog.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + cMsg);
end;

procedure TdmCon.LogarErros(cMsg: String);
begin
  TLog.New.Logar(cMsg);
  FmeErros.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + cMsg);
end;

procedure TdmCon.ExecuteCommandDestino(cComando: String);
begin
  FDConOracle.ExecSQL(cComando);
end;

procedure TdmCon.ExecuteCommandOrigem(cComando: String);
begin
  FDConFireBird.ExecSQL(cComando);
end;

procedure TdmCon.FDBatchMove1Progress(ASender: TObject; APhase: TFDBatchMovePhase);
begin
  //
end;

procedure TdmCon.ExecuteCommand(cComando: String);
begin
  FDCommand1.CommandText.Clear;
  FDCommand1.CommandText.Add(cComando);
  FDCommand1.Execute();
end;

procedure TdmCon.MoverTabelas;
var
  cTabela: String;
  dtini, dtfim, total: TDateTime;
begin
  qryTabelas.First;
  while (not qryTabelas.Eof) do
    begin
    try
      cTabela := Trim(qryTabelas.FieldByName('TABELA').AsString);
      Logar(' : Inciando copia da tabela ' + cTabela + ' - Tabela ' + IntToStr(qryTabelas.RecNo) + ' de ' + IntToStr(qryTabelas.RecordCount));
      dtini := Now;
      MoverDadosTabela(cTabela);
      AtualizarMigradas(cTabela);
      total := Now-dtini;
      Logar(' : Finalizada copia da tabela ' + cTabela + ' com ' +
             qryTabelas.FieldByName('LINHAS').AsString + ' registros ' +
             ' em ' + FormatDateTime('hh:mm:sssss', total));
    except
      on e: Exception do
        begin
        LogarErros(' : Erro: ' + cTabela + ' :: '  + e.message);
      end;
    end;
    qryTabelas.next;
  end;
end;

procedure TdmCon.MoverTabelasPersonalizadas;

begin
  FmeLog.Clear;
  FmeErros.Clear;
  Logar(' : Iniciando cópia das tabelas PERSONALIZADAS ::');
  CarregarTabelasPersonalizadas;
  MoverTabelas;
end;

procedure TdmCon.AtualizarMigradas(cTabela: String);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FDConFireBird;
  qry.SQL.Text := 'SELECT * FROM MIGRATABELAS WHERE TABELA = :TABELA';
  qry.ParamByName('TABELA').Value := cTabela;
  qry.Open();
  qry.Edit;
  qry.FieldByName('MIGRADA').Value := 'S';
  qry.Post;
end;

procedure TdmCon.MoverTabelasSistema;
var
  cTabela: String;
begin
  FmeLog.Clear;
  FmeErros.Clear;
  Logar(' : Iniciando cópia das tabelas PADRÕES do SISTEMA ::');
  CarregarTabelasSistema;
  MoverTabelas;
end;

procedure TdmCon.Notificar(Sender: TObject);
begin
  Logar(' : Finalizada copia da tabela '); // + Sender + ' com ' +
//             qryTabelas.FieldByName('LINHAS').AsString + ' registros ' +
//             ' em ' + FormatDateTime('hh:mm:sssss', total));
end;

procedure TdmCon.MoverTabelasSistemaParalelo;
var
  cTabela: String;
  dtini, dtfim, total: TDateTime;
  pool: TThreadpool;
  TaskList: TList<ITask>;
begin
  FmeLog.Clear;
  FmeErros.Clear;
  Logar(' : Iniciando cópia das tabelas PADRÕES do SISTEMA ::');
  CarregarTabelasSistema;
  while (not qryTabelas.Eof) do
    begin
//    try
      cTabela := Trim(qryTabelas.FieldByName('TABELA').AsString);
      Logar(' : Inciando copia da tabela ' + cTabela + ' - Tabela ' + IntToStr(qryTabelas.RecNo) + ' de ' + IntToStr(qryTabelas.RecordCount));
//      dtini := Now;
//      TMoveDados.New().MoverDadosTabela(cTabela);
//      AtualizarMigradas(cTabela);
//      total := Now-dtini;
//      Logar(' : Finalizada copia da tabela ' + cTabela + ' com ' +
//             qryTabelas.FieldByName('LINHAS').AsString + ' registros ' +
//             ' em ' + FormatDateTime('hh:mm:sssss', total));
//    except
//      on e: Exception do
//        begin
//        LogarErros(' : Erro: ' + cTabela + ' :: '  + e.message);
//      end;
//    end;
//    Task := TTask.Create(
    qryTabelas.next;
  end;

  TTask.WaitForAll(TaskList.ToArray);
end;

end.

{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}

