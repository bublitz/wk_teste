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
    Left = 480
    Top = 392
    Width = 75
    Height = 15
    Caption = 'lblTotalPedido'
  end
  object Label1: TLabel
    Left = 64
    Top = 27
    Width = 79
    Height = 15
    Caption = 'C'#243'digo Cliente'
  end
  object Label2: TLabel
    Left = 201
    Top = 27
    Width = 73
    Height = 15
    Caption = 'Nome Cliente'
  end
  object Label3: TLabel
    Left = 344
    Top = 27
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object Label4: TLabel
    Left = 496
    Top = 27
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object Label5: TLabel
    Left = 64
    Top = 91
    Width = 85
    Height = 15
    Caption = 'C'#243'digo Produto'
  end
  object Label6: TLabel
    Left = 201
    Top = 91
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object Label7: TLabel
    Left = 344
    Top = 91
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object Label8: TLabel
    Left = 496
    Top = 91
    Width = 71
    Height = 15
    Caption = 'Valor Unit'#225'rio'
  end
  object Bevel1: TBevel
    Left = 56
    Top = 16
    Width = 586
    Height = 61
  end
  object Bevel2: TBevel
    Left = 56
    Top = 82
    Width = 586
    Height = 61
  end
  object SpeedButton1: TSpeedButton
    Left = 656
    Top = 27
    Width = 81
    Height = 27
    Caption = 'Limpar'
    OnClick = SpeedButton1Click
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
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 1
    OnChange = edtCodClienteChange
    OnExit = edtCodClienteExit
  end
  object edtNomeCliente: TEdit
    Left = 201
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object edtCidade: TEdit
    Left = 344
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 3
  end
  object edtUF: TEdit
    Left = 496
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 4
  end
  object edtCodProduto: TEdit
    Left = 64
    Top = 112
    Width = 121
    Height = 23
    TabOrder = 5
    OnExit = edtCodProdutoExit
  end
  object edtDescProduto: TEdit
    Left = 201
    Top = 112
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object edtQuantidade: TEdit
    Left = 344
    Top = 112
    Width = 121
    Height = 23
    TabOrder = 7
  end
  object edtValorUnit: TEdit
    Left = 496
    Top = 112
    Width = 121
    Height = 23
    TabOrder = 8
  end
  object grdItens: TDBGrid
    Left = 64
    Top = 200
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
        Title.Caption = 'C'#243'digo'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Title.Caption = 'Descri'#231#227'o'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quantidade'
        Title.Alignment = taRightJustify
        Title.Caption = 'Qtde'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vlr_unit'
        Title.Alignment = taRightJustify
        Title.Caption = 'Unit'#225'rio'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vlr_total'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total'
        Width = 100
        Visible = True
      end>
  end
  object btnInserirItem: TButton
    Left = 64
    Top = 160
    Width = 120
    Height = 25
    Caption = 'Inserir Item'
    TabOrder = 10
    OnClick = btnInserirItemClick
  end
  object btnCarregarPedido: TButton
    Left = 201
    Top = 160
    Width = 120
    Height = 25
    Caption = 'Carregar Pedido'
    TabOrder = 11
    OnClick = btnCarregarPedidoClick
  end
  object btnGravar: TButton
    Left = 344
    Top = 160
    Width = 120
    Height = 25
    Caption = 'Gravar'
    TabOrder = 12
    OnClick = btnGravarClick
  end
  object btnCancelarPedido: TButton
    Left = 496
    Top = 160
    Width = 120
    Height = 25
    Caption = 'Cancelar Pedido'
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
    Top = 240
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
    Top = 248
  end
end
