{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}


unit uCarregaConfiguracoes;

interface

uses
  System.Classes, IniFiles, uParametrosConexao, uEnum, uLog,
  System.SysUtils, System.ioutils, Winapi.Windows, ShellApi, TlHelp32, Forms, StrUtils;

type
  ICarregaConfiguracoes = interface
  ['{EF8A0C2B-1935-411E-82A6-DD08E34A64CE}']
    function GetConfiguracaoOrigem: IParametrosConexao;
    function GetConfiguracaoDestino: IParametrosConexao;
  end;

  TCarregaConfiguracoes = class(TInterfacedObject, ICarregaConfiguracoes)
    FServer: string;
    FPorta: string;
    FBanco: string;
    FUsuario: string;
    FSenha: string;
    FDriverID: string;
    function CarregarConfiguracoes(AcSessao: String): IParametrosConexao;
  public
    class function new: ICarregaConfiguracoes;
    function GetConfiguracaoOrigem: IParametrosConexao;
    function GetConfiguracaoDestino: IParametrosConexao;
  end;

implementation

{ TCarregaConfiguracoes }

class function TCarregaConfiguracoes.new: ICarregaConfiguracoes;
begin
  Result := TCarregaConfiguracoes.Create;
end;

function TCarregaConfiguracoes.GetConfiguracaoOrigem: IParametrosConexao;
begin
  Result := CarregarConfiguracoes('Origem');
end;

function TCarregaConfiguracoes.GetConfiguracaoDestino: IParametrosConexao;
begin
  Result := CarregarConfiguracoes('Destino');
end;

function TCarregaConfiguracoes.CarregarConfiguracoes(AcSessao: String): IParametrosConexao;
var
  FIni: TIniFile;
begin
  try
    TLog.New.Logar('Lendo configuração...');
    try
      FIni := TIniFile.Create(ExtractFileDir(Forms.Application.ExeName) + '\' +
                              ReplaceStr(ExtractFileName(Forms.Application.ExeName), '.exe', '.ini'));

      FServer   := FIni.ReadString(AcSessao, 'Server', EmptyStr);
      FPorta    := FIni.ReadString(AcSessao, 'Porta', EmptyStr);
      FBanco    := FIni.ReadString(AcSessao, 'Banco', EmptyStr);
      FUsuario  := FIni.ReadString(AcSessao, 'Usuario', EmptyStr);
      FSenha    := FIni.ReadString(AcSessao, 'Senha', EmptyStr);
      FDriverID := FIni.ReadString(AcSessao, 'DriverID', EmptyStr);
    finally
      Fini.Free;
    end;
    Result := TParametrosConexao.New( FServer
                          , FPorta
                          , FBanco
                          , FUsuario
                          , FSenha
                          , FDriverID
                          );
  except
    on E: Exception do
    begin
      TLog.New.Logar('Erro ao ler configurações: ' + E.Message);
    end
  end;
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

