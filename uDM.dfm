object DM: TDM
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object con: TFDConnection
    Params.Strings = (
      'DriverID=MySQL')
    Left = 56
    Top = 32
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 200
    Top = 80
  end
end
