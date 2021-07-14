{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}


unit uParametrosConexao;

interface

uses
  uEnum;

type
  IParametrosConexao = interface
    ['{63587B88-E13E-4DB7-A93D-12D6D4B3D6F8}']
    function GetServer: string;
    function GetPorta: string;
    function GetBanco: string;
    function GetUsuario: string;
    function GetSenha: string;
    function GetDriverID: string;
  end;

  TParametrosConexao = class(TInterfacedObject, IParametrosConexao)
  private
    FBanco: string;
    FPooled: Boolean;
    FSenha: string;
    FUsuario: string;
    FPorta: string;
    FServer: string;
    FDriverID: string;
    procedure SetBanco(const Value: string);
    procedure SetPooled(const Value: Boolean);
    procedure SetPorta(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetServer(const Value: string);
    procedure SetUsuario(const Value: string);
    function GetBanco: string;
    function GetPorta: string;
    function GetSenha: string;
    function GetServer: string;
    function GetUsuario: string;
    procedure SetDriverID(const Value: string);
    function GetDriverID: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property Server: string read GetServer write SetServer;
    property Porta: string read GetPorta write SetPorta;
    property Banco: string read GetBanco write SetBanco;
    property Usuario: string read GetUsuario write SetUsuario;
    property Senha: string read GetSenha write SetSenha;
    property DriverID: string read GetDriverID write SetDriverID;
    property Pooled: Boolean read FPooled write SetPooled;
    constructor Create(AServer, APorta, ABanco, AUsuario, ASenha, ADriverID: string); overload;
    class function New(AServer, APorta, ABanco, AUsuario, ASenha, ADriverID: string): IParametrosConexao;
  published
    { published declarations }
  end;

implementation

{ TParametrosConexao }

constructor TParametrosConexao.Create(AServer, APorta, ABanco, AUsuario, ASenha, ADriverID: string);
begin
  SetServer(AServer);
  SetPorta(APorta);
  SetBanco(ABanco);
  SetUsuario(AUsuario);
  SetSenha(ASenha);
  SetDriverID(ADriverID);
end;

function TParametrosConexao.GetBanco: string;
begin
  Result := FBanco;
end;

function TParametrosConexao.GetDriverID: string;
begin
  Result := FDriverID;
end;

function TParametrosConexao.GetPorta: string;
begin
  Result := FPorta;
end;

function TParametrosConexao.GetSenha: string;
begin
  Result := FSenha;
end;

function TParametrosConexao.GetServer: string;
begin
  Result := FServer;
end;

function TParametrosConexao.GetUsuario: string;
begin
  Result := FUsuario;
end;

class function TParametrosConexao.New(AServer, APorta, ABanco, AUsuario, ASenha, ADriverID: string): IParametrosConexao;
begin
  Result := TParametrosConexao.Create(AServer, APorta, ABanco, AUsuario, ASenha, ADriverID);
end;

procedure TParametrosConexao.SetBanco(const Value: string);
begin
  FBanco := Value;
end;

procedure TParametrosConexao.SetDriverID(const Value: string);
begin
  FDriverID := Value;
end;

procedure TParametrosConexao.SetPooled(const Value: Boolean);
begin
  FPooled := Value;
end;

procedure TParametrosConexao.SetPorta(const Value: string);
begin
  FPorta := Value;
end;

procedure TParametrosConexao.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TParametrosConexao.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TParametrosConexao.SetUsuario(const Value: string);
begin
  FUsuario := Value;
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

