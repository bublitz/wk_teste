object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 441
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object lblTotalPedido: TLabel
    Left = 464
    Top = 376
    Width = 75
    Height = 15
    Caption = 'lblTotalPedido'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 745
    Height = 19
    Panels = <
      item
        Text = 'Banco:'
        Width = 250
      end
      item
        Text = 'Pedidos:'
        Width = 50
      end>
  end
  object edtCodCliente: TEdit
    Left = 64
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'edtCodCliente'
    OnChange = edtCodClienteChange
    OnExit = edtCodClienteExit
  end
  object edtNomeCliente: TEdit
    Left = 201
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 2
    Text = 'edtNomeCliente'
  end
  object edtCidade: TEdit
    Left = 344
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 3
    Text = 'edtCidade'
  end
  object edtUF: TEdit
    Left = 496
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 4
    Text = 'edtUF'
  end
  object edtCodProduto: TEdit
    Left = 64
    Top = 96
    Width = 121
    Height = 23
    TabOrder = 5
    Text = 'edtCodProduto'
    OnExit = edtCodProdutoExit
  end
  object edtDescProduto: TEdit
    Left = 201
    Top = 96
    Width = 121
    Height = 23
    TabOrder = 6
    Text = 'edtDescProduto'
  end
  object edtQuantidade: TEdit
    Left = 344
    Top = 96
    Width = 121
    Height = 23
    TabOrder = 7
    Text = 'edtQuantidade'
  end
  object edtValorUnit: TEdit
    Left = 496
    Top = 96
    Width = 121
    Height = 23
    TabOrder = 8
    Text = 'edtValorUnit'
  end
  object grdItens: TDBGrid
    Left = 48
    Top = 184
    Width = 496
    Height = 177
    DataSource = dsItens
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnKeyDown = grdItensKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'cod_produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quantidade'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vlr_unit'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vlr_total'
        Visible = True
      end>
  end
  object btnInserirItem: TButton
    Left = 64
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btnInserirItem'
    TabOrder = 10
    OnClick = btnInserirItemClick
  end
  object btnCarregarPedido: TButton
    Left = 201
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btnCarregarPedido'
    TabOrder = 11
    OnClick = btnCarregarPedidoClick
  end
  object btnGravar: TButton
    Left = 344
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btnGravar'
    TabOrder = 12
    OnClick = btnGravarClick
  end
  object btnCancelarPedido: TButton
    Left = 496
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btnCancelarPedido'
    TabOrder = 13
    OnClick = btnCancelarPedidoClick
  end
  object mtItens: TFDMemTable
    AfterPost = mtItensAfterPost
    AfterDelete = mtItensAfterDelete
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 368
    Top = 224
    object mtItenscod_produto: TIntegerField
      FieldName = 'cod_produto'
    end
    object mtItensdescricao: TStringField
      FieldName = 'descricao'
    end
    object mtItensquantidade: TFloatField
      FieldName = 'quantidade'
    end
    object mtItensvlr_unit: TCurrencyField
      FieldName = 'vlr_unit'
    end
    object mtItensvlr_total: TCurrencyField
      FieldName = 'vlr_total'
    end
  end
  object dsItens: TDataSource
    DataSet = mtItens
    Left = 448
    Top = 232
  end
end
