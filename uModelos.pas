unit uModelos;

interface

uses
  System.Generics.Collections, System.SysUtils;

type
  TCliente = class
  public
    Codigo: Integer;
    Nome: string;
    Cidade: string;
    UF: string;
  end;

  TProduto = class
  public
    Codigo: Integer;
    Descricao: string;
    PrecoVenda: Currency;
  end;

  TPedidoItem = class
  public
    CodigoProduto: Integer;
    DescricaoProduto: string;
    Quantidade: Double;
    ValorUnitario: Currency;
    ValorTotal: Currency;
  end;

  TPedido = class
  private
    FItens: TObjectList<TPedidoItem>;
    function GetValorTotal: Currency;
  public
    NumeroPedido: Integer;
    DataEmissao: TDateTime;
    CodigoCliente: Integer;

    constructor Create;
    destructor Destroy; override;

    property Itens: TObjectList<TPedidoItem> read FItens;
    property ValorTotal: Currency read GetValorTotal;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  inherited;
  FItens := TObjectList<TPedidoItem>.Create(True); // OwnsObjects = True
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

function TPedido.GetValorTotal: Currency;
var
  Item: TPedidoItem;
begin
  Result := 0;
  for Item in FItens do
    Result := Result + Item.ValorTotal;
end;

end.
