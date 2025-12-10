unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DApt,
  uModelos, uPedidoDAO, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    mtItens: TFDMemTable;
    edtCodProduto: TEdit;
    edtDescProduto: TEdit;
    edtQuantidade: TEdit;
    edtValorUnit: TEdit;
    grdItens: TDBGrid;
    dsItens: TDataSource;
    mtItenscod_produto: TIntegerField;
    mtItensdescricao: TStringField;
    mtItensquantidade: TFloatField;
    mtItensvlr_unit: TCurrencyField;
    mtItensvlr_total: TCurrencyField;
    btnInserirItem: TButton;
    btnCarregarPedido: TButton;
    btnGravar: TButton;
    btnCancelarPedido: TButton;
    lblTotalPedido: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure mtItensAfterPost(DataSet: TDataSet);
    procedure mtItensAfterDelete(DataSet: TDataSet);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure edtCodClienteChange(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    FPedido: TPedido;
    FEditandoItem: Boolean;
    FBookmarkEdicao: TBookmark;
    FPedidoDAO: TPedidoDAO;
    procedure ConfigurarMemTable;
    procedure RecalcularTotalPedido;
    procedure CarregarCliente(ACodigoCliente: Integer);
    procedure CarregarProduto(ACodigoProduto: Integer);
    procedure PreencherPedidoAPartirDoMemTable;
    procedure CarregarMemTableAPartirDoPedido;
    procedure AtualizarVisibilidadeBotoesPedido;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses uDM;

procedure TfrmMain.AtualizarVisibilidadeBotoesPedido;
begin
  // Botões visíveis somente quando código do cliente em branco
  btnCarregarPedido.Visible := edtCodCliente.Text = '';
  btnCancelarPedido.Visible := edtCodCliente.Text = '';
end;

procedure TfrmMain.btnCancelarPedidoClick(Sender: TObject);
var
  S: string;
  Num: Integer;

begin
  S := '';
  if InputQuery('Cancelar pedido', 'Informe o número do pedido:', S) then
  begin
    Num := StrToIntDef(S, 0);
    if Num = 0 then
    begin
      ShowMessage('Número inválido.');
      Exit;
    end;

    if Application.MessageBox(PChar('Deseja realmente cancelar o pedido ' + S + '?'),
      'Atenção!', MB_YESNO+MB_ICONWARNING) = IDYES then
    begin
      try
        FPedidoDAO.CancelarPedido(Num);
        ShowMessage('Pedido cancelado com sucesso.');
      except
        on E: Exception do
          ShowMessage('Erro ao cancelar pedido: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmMain.btnCarregarPedidoClick(Sender: TObject);
var
  S: string;
  Num: Integer;

begin
  S := '';
  if InputQuery('Carregar pedido', 'Informe o número do pedido:', S) then
  begin
    Num := StrToIntDef(S, 0);
    if Num = 0 then
    begin
      ShowMessage('Número inválido.');
      Exit;
    end;

    try
      FPedidoDAO.CarregarPedido(Num, FPedido);
      // Carregar dados do cliente
      edtCodCliente.Text := FPedido.CodigoCliente.ToString;
      CarregarCliente(FPedido.CodigoCliente);
      CarregarMemTableAPartirDoPedido;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar pedido: ' + E.Message);
    end;
  end;
end;

procedure TfrmMain.btnGravarClick(Sender: TObject);
begin
  if edtCodCliente.Text = '' then
  begin
    ShowMessage('Informe o cliente.');
    Exit;
  end;

  if mtItens.IsEmpty then
  begin
    ShowMessage('Inclua pelo menos um item no pedido.');
    Exit;
  end;

  FPedido.CodigoCliente := StrToInt(edtCodCliente.Text);
  FPedido.DataEmissao   := Date;
  FPedido.NumeroPedido  := FPedidoDAO.ObterProximoNumeroPedido;

  PreencherPedidoAPartirDoMemTable;

  try
    FPedidoDAO.GravarPedido(FPedido);
    ShowMessage('Pedido gravado com sucesso! Número: ' +
      FPedido.NumeroPedido.ToString);
  except
    on E: Exception do
      ShowMessage('Erro ao gravar pedido: ' + E.Message);
  end;
end;

procedure TfrmMain.btnInserirItemClick(Sender: TObject);
var
  CodProd: Integer;
  Qtd: Double;
  VlrUnit, VlrTotal: Currency;

begin
  CodProd := StrToIntDef(edtCodProduto.Text, 0);
  Qtd     := StrToFloatDef(edtQuantidade.Text, 0);
  VlrUnit := StrToCurrDef(edtValorUnit.Text, 0);

  if (CodProd = 0) or (Qtd <= 0) or (VlrUnit <= 0) then
  begin
    ShowMessage('Informe produto, quantidade e valor unitário válidos.');
    Exit;
  end;

  VlrTotal := Qtd * VlrUnit;

  if not FEditandoItem then
  begin
    // Inserção
    mtItens.Append;
  end
  else
  begin
    // Edição
    if (FBookmarkEdicao <> nil) and mtItens.BookmarkValid(FBookmarkEdicao) then
      mtItens.Bookmark := FBookmarkEdicao;
    mtItens.Edit;
  end;

  mtItens.FieldByName('cod_produto').AsInteger   := CodProd;
  mtItens.FieldByName('descricao').AsString      := edtDescProduto.Text;
  mtItens.FieldByName('quantidade').AsFloat      := Qtd;
  mtItens.FieldByName('vlr_unit').AsCurrency     := VlrUnit;
  mtItens.FieldByName('vlr_total').AsCurrency    := VlrTotal;
  mtItens.Post;

  FEditandoItem := False;
  FBookmarkEdicao := nil;
  btnInserirItem.Caption := 'Inserir item';

  // Limpar campos de item
  edtCodProduto.Clear;
  edtDescProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnit.Clear;

  edtCodProduto.SetFocus;
end;

procedure TfrmMain.CarregarCliente(ACodigoCliente: Integer);
var
  Qry: TFDQuery;
begin
  if ACodigoCliente = 0 then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.con;
    Qry.SQL.Text :=
      'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :cod';
    Qry.ParamByName('cod').AsInteger := ACodigoCliente;
    Qry.Open;

    if Qry.IsEmpty then
      raise Exception.Create('Cliente não encontrado.');

    edtNomeCliente.Text := Qry.FieldByName('nome').AsString;
    edtCidade.Text      := Qry.FieldByName('cidade').AsString;
    edtUF.Text          := Qry.FieldByName('uf').AsString;
  finally
    Qry.Free;
  end;
end;

procedure TfrmMain.CarregarMemTableAPartirDoPedido;
var
  Item: TPedidoItem;

begin
  mtItens.DisableControls;
  try
    mtItens.EmptyDataSet;
    for Item in FPedido.Itens do
    begin
      mtItens.Append;
      mtItens.FieldByName('cod_produto').AsInteger   := Item.CodigoProduto;
      mtItens.FieldByName('descricao').AsString      := Item.DescricaoProduto;
      mtItens.FieldByName('quantidade').AsFloat      := Item.Quantidade;
      mtItens.FieldByName('vlr_unit').AsCurrency     := Item.ValorUnitario;
      mtItens.FieldByName('vlr_total').AsCurrency    := Item.ValorTotal;
      mtItens.Post;
    end;
  finally
    mtItens.EnableControls;
  end;
  RecalcularTotalPedido;
end;

procedure TfrmMain.CarregarProduto(ACodigoProduto: Integer);
var
  Qry: TFDQuery;
begin
  if ACodigoProduto = 0 then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.con;
    Qry.SQL.Text :=
      'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :cod';
    Qry.ParamByName('cod').AsInteger := ACodigoProduto;
    Qry.Open;

    if Qry.IsEmpty then
      raise Exception.Create('Produto não encontrado.');

    edtDescProduto.Text := Qry.FieldByName('descricao').AsString;
    edtValorUnit.Text   := Qry.FieldByName('preco_venda').AsString;
  finally
    Qry.Free;
  end;
end;

procedure TfrmMain.ConfigurarMemTable;
begin
  mtItens.Close;
  mtItens.FieldDefs.Clear;
  mtItens.FieldDefs.Add('cod_produto', ftInteger);
  mtItens.FieldDefs.Add('descricao', ftString, 150);
  mtItens.FieldDefs.Add('quantidade', ftFloat);
  mtItens.FieldDefs.Add('vlr_unit', ftCurrency);
  mtItens.FieldDefs.Add('vlr_total', ftCurrency);
  mtItens.CreateDataSet;
end;

procedure TfrmMain.edtCodClienteChange(Sender: TObject);
begin
  AtualizarVisibilidadeBotoesPedido;
end;

procedure TfrmMain.edtCodClienteExit(Sender: TObject);
begin
  if edtCodCliente.Text <> '' then
    CarregarCliente(StrToIntDef(edtCodCliente.Text, 0));
end;

procedure TfrmMain.edtCodProdutoExit(Sender: TObject);
begin
  if edtCodProduto.Text <> '' then
    CarregarProduto(StrToIntDef(edtCodProduto.Text, 0));
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Banco: Desconectado';
  DM.ConectaBanco;
  if DM.con.Connected then
    StatusBar1.Panels[0].Text := 'Banco: Conectado';
  FPedido := TPedido.Create;
  FPedidoDAO := TPedidoDAO.Create;
  ConfigurarMemTable;
  AtualizarVisibilidadeBotoesPedido;
end;

procedure TfrmMain.grdItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        // Editar item selecionado
        if not mtItens.IsEmpty then
        begin
          FEditandoItem := True;
          FBookmarkEdicao := mtItens.Bookmark;

          edtCodProduto.Text := mtItens.FieldByName('cod_produto').AsString;
          edtDescProduto.Text:= mtItens.FieldByName('descricao').AsString;
          edtQuantidade.Text := FloatToStr(mtItens.FieldByName('quantidade').AsFloat);
          edtValorUnit.Text  := CurrToStr(mtItens.FieldByName('vlr_unit').AsCurrency);

          btnInserirItem.Caption := 'Atualizar item';
          edtQuantidade.SetFocus;
        end;
      end;
    VK_DELETE:
      begin
        if not mtItens.IsEmpty then
        begin
          if Application.MessageBox('Deseja apagar o item selecionado?',
            'Atenção', MB_YESNO+MB_ICONWARNING) = IDYES then
          begin
            mtItens.Delete;
          end;
        end;
      end;
  end;
end;

procedure TfrmMain.mtItensAfterDelete(DataSet: TDataSet);
begin
  RecalcularTotalPedido;
end;

procedure TfrmMain.mtItensAfterPost(DataSet: TDataSet);
begin
  RecalcularTotalPedido;
end;

procedure TfrmMain.PreencherPedidoAPartirDoMemTable;
var
  Item: TPedidoItem;

begin
  // Limpa itens atuais
  FPedido.Itens.Clear;

  mtItens.DisableControls;
  try
    mtItens.First;
    while not mtItens.Eof do
    begin
      Item := TPedidoItem.Create;
      Item.CodigoProduto   := mtItens.FieldByName('cod_produto').AsInteger;
      Item.DescricaoProduto:= mtItens.FieldByName('descricao').AsString;
      Item.Quantidade      := mtItens.FieldByName('quantidade').AsFloat;
      Item.ValorUnitario   := mtItens.FieldByName('vlr_unit').AsCurrency;
      Item.ValorTotal      := mtItens.FieldByName('vlr_total').AsCurrency;
      FPedido.Itens.Add(Item);

      mtItens.Next;
    end;
  finally
    mtItens.EnableControls;
  end;
end;

procedure TfrmMain.RecalcularTotalPedido;
var
  Total: Currency;
begin
  Total := 0;
  mtItens.DisableControls;
  try
    mtItens.First;
    while not mtItens.Eof do
    begin
      Total := Total + mtItens.FieldByName('vlr_total').AsCurrency;
      mtItens.Next;
    end;
  finally
    mtItens.EnableControls;
  end;
  lblTotalPedido.Caption := FormatFloat('R$ ,0.00', Total);
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  edtCodCliente.Text := '';
  edtNomeCliente.Text := '';
  edtCidade.Text := '';
  edtUF.Text := '';
  edtCodProduto.Text := '';
  edtDescProduto.Text := '';
  edtQuantidade.Text := '';
  edtValorUnit.Text := '';
  RecalcularTotalPedido;
  lblTotalPedido.Caption := '';
end;

end.
