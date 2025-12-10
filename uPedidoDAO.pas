unit uPedidoDAO;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.Client,
  uModelos, uDM;

type
  TPedidoDAO = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    function ObterProximoNumeroPedido: Integer;
    procedure GravarPedido(APedido: TPedido);
    procedure CarregarPedido(ANumeroPedido: Integer; APedido: TPedido);
    procedure CancelarPedido(ANumeroPedido: Integer);
  end;

implementation

{ TPedidoDAO }

constructor TPedidoDAO.Create;
begin
  FConn := DM.con;
end;

function TPedidoDAO.ObterProximoNumeroPedido: Integer;
begin
  Result := DM.ProximoPedido;
end;

procedure TPedidoDAO.GravarPedido(APedido: TPedido);
var
  QryCab, QryItem: TFDQuery;
  Item: TPedidoItem;
begin
  FConn.StartTransaction;
  try
    // CABEÇALHO
    QryCab := TFDQuery.Create(nil);
    try
      QryCab.Connection := FConn;
      QryCab.SQL.Text :=
        'INSERT INTO pedidos (numero_pedido, data_emissao, codigo_cliente, valor_total) ' +
        'VALUES (:numero_pedido, :data_emissao, :codigo_cliente, :valor_total)';

      QryCab.ParamByName('numero_pedido').AsInteger  := APedido.NumeroPedido;
      QryCab.ParamByName('data_emissao').AsDate      := APedido.DataEmissao;
      QryCab.ParamByName('codigo_cliente').AsInteger := APedido.CodigoCliente;
      QryCab.ParamByName('valor_total').AsCurrency   := APedido.ValorTotal;

      QryCab.ExecSQL;
    finally
      QryCab.Free;
    end;

    // ITENS
    QryItem := TFDQuery.Create(nil);
    try
      QryItem.Connection := FConn;
      QryItem.SQL.Text :=
        'INSERT INTO pedidos_produtos ' +
        ' (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
        'VALUES ' +
        ' (:numero_pedido, :codigo_produto, :quantidade, :valor_unitario, :valor_total)';

      for Item in APedido.Itens do
      begin
        QryItem.ParamByName('numero_pedido').AsInteger   := APedido.NumeroPedido;
        QryItem.ParamByName('codigo_produto').AsInteger  := Item.CodigoProduto;
        QryItem.ParamByName('quantidade').AsFloat        := Item.Quantidade;
        QryItem.ParamByName('valor_unitario').AsCurrency := Item.ValorUnitario;
        QryItem.ParamByName('valor_total').AsCurrency    := Item.ValorTotal;
        QryItem.ExecSQL;
      end;
    finally
      QryItem.Free;
    end;

    FConn.Commit;
  except
    FConn.Rollback;
    raise;
  end;
end;

procedure TPedidoDAO.CarregarPedido(ANumeroPedido: Integer; APedido: TPedido);
var
  QryCab, QryItem: TFDQuery;
  Item: TPedidoItem;
begin
  // Cabeçalho
  QryCab := TFDQuery.Create(nil);
  try
    QryCab.Connection := FConn;
    QryCab.SQL.Text :=
      'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total ' +
      'FROM pedidos WHERE numero_pedido = :num';
    QryCab.ParamByName('num').AsInteger := ANumeroPedido;
    QryCab.Open;

    if QryCab.IsEmpty then
      raise Exception.Create('Pedido não encontrado.');

    APedido.NumeroPedido := QryCab.FieldByName('numero_pedido').AsInteger;
    APedido.DataEmissao  := QryCab.FieldByName('data_emissao').AsDateTime;
    APedido.CodigoCliente:= QryCab.FieldByName('codigo_cliente').AsInteger;
    APedido.Itens.Clear;
  finally
    QryCab.Free;
  end;

  // Itens
  QryItem := TFDQuery.Create(nil);
  try
    QryItem.Connection := FConn;
    QryItem.SQL.Text :=
      'SELECT codigo_produto, quantidade, valor_unitario, valor_total ' +
      'FROM pedidos_produtos ' +
      'WHERE numero_pedido = :num';
    QryItem.ParamByName('num').AsInteger := ANumeroPedido;
    QryItem.Open;

    while not QryItem.Eof do
    begin
      Item := TPedidoItem.Create;
      Item.CodigoProduto := QryItem.FieldByName('codigo_produto').AsInteger;
      Item.Quantidade    := QryItem.FieldByName('quantidade').AsFloat;
      Item.ValorUnitario := QryItem.FieldByName('valor_unitario').AsCurrency;
      Item.ValorTotal    := QryItem.FieldByName('valor_total').AsCurrency;
      // Descrição você pode buscar em produtos ou deixar vazio aqui e preencher na UI
      APedido.Itens.Add(Item);

      QryItem.Next;
    end;
  finally
    QryItem.Free;
  end;
end;

procedure TPedidoDAO.CancelarPedido(ANumeroPedido: Integer);
var
  Qry: TFDQuery;
begin
  FConn.StartTransaction;
  try
    Qry := TFDQuery.Create(nil);
    try
      Qry.Connection := FConn;

      // Deleta itens
      Qry.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :num';
      Qry.ParamByName('num').AsInteger := ANumeroPedido;
      Qry.ExecSQL;

      // Deleta cabeçalho
      Qry.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :num';
      Qry.ParamByName('num').AsInteger := ANumeroPedido;
      Qry.ExecSQL;
    finally
      Qry.Free;
    end;

    FConn.Commit;
  except
    FConn.Rollback;
    raise;
  end;
end;

end.
