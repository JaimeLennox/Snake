program Snake;

{$MODE Delphi}

uses
  Forms, Interfaces,
  TSnake in 'TSnake.pas' {fSnake},
  SnakeObjects in 'SnakeObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfSnake, fSnake);
  Application.Run;
end.
