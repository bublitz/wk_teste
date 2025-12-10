unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  IniFiles;

type
  TDM = class(TDataModule)
    con: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConectaBanco;
    function ProximoPedido: integer;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.ConectaBanco;
var
  Ini: TIniFile;

begin
Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    FDPhysMySQLDriverLink1.VendorLib := Ini.ReadString('Database', 'DriverDll', '');
    con.Params.Clear;
    con.DriverName := 'MySQL';
    con.Params.Add('Server='   + Ini.ReadString('Database', 'Server', 'localhost'));
    con.Params.Add('Port='     + Ini.ReadString('Database', 'Port', '3306'));
    con.Params.Add('Database=' + Ini.ReadString('Database', 'Database', 'wkteste'));
    con.Params.Add('User_Name='+ Ini.ReadString('Database', 'Username', 'root'));
    con.Params.Add('Password=' + Ini.ReadString('Database', 'Password', 'senha'));
    con.LoginPrompt := False;
    con.Connected := True;
  finally
    Ini.Free;
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConectaBanco;
end;

function TDM.ProximoPedido: integer;
const
  sql = 'SELECT COALESCE(MAX(numero_pedido),0)+1 AS prox FROM pedidos;';

begin
  Result := con.ExecSQLScalar(sql);
end;

end.
