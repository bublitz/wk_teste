program WKteste;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  uModelos in 'uModelos.pas',
  uPedidoDAO in 'uPedidoDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
