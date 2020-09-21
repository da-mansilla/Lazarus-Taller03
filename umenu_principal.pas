unit umenu_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids, Spin,
  ExtCtrls, Buttons, ComCtrls;

type

  { TfrmMenu }

  TfrmMenu = class(TForm)
    btnSalir: TButton;
    btnRegistrar: TButton;
    btnBuscarPorCodigo: TButton;
    btnOrdenarPrecio: TButton;
    btnOrdenarDescrpcion: TButton;
    btnCargarAlAzar: TButton;
    cbxTipo: TComboBox;
    cbxCantidadArticulosPorTipo: TComboBox;
    chkEstado: TCheckBox;
    edtDescripcion: TEdit;
    edtBuscarPorCodigo: TEdit;
    edtStock: TEdit;
    edtCodigo: TEdit;
    edtPrecio: TFloatSpinEdit;
    grdArticulos: TStringGrid;
    Image1: TImage;
    Label1: TLabel;
    lblEditando: TLabel;
    lblEstado: TLabel;
    lblDescripcion: TLabel;
    lblBuscarPorCodigo: TLabel;
    lblCantidadStockMinimo: TLabel;
    lblTituloStockMinimo: TLabel;
    lblTituloCantidadTipoArticulo: TLabel;
    lblNumeroArticulos: TLabel;
    lblTipo: TLabel;
    lblPrecio: TLabel;
    lblCodigo: TLabel;
    lblTitulo: TLabel;

    procedure btnBuscarPorCodigoClick(Sender: TObject);
    procedure btnCargarAlAzarClick(Sender: TObject);
    procedure btnOrdenarDescrpcionClick(Sender: TObject);
    procedure btnOrdenarPrecioClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure cbxCantidadArticulosPorTipoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdArticulosButtonClick(Sender: TObject; aCol, aRow: Integer);





    procedure lblTituloCantidadTipoArticuloClick(Sender: TObject);
  private

  public

  end;

TString10 = String[10];
TString50 = String[50];
TArticulo = record
    codigo : integer;
    precioUnitario : real;
    descripcion: TString50;
    estado: TString10;
    stock : integer;
    tipoArticulo : char;
end;

TListaArticulos = array [1..100] of TArticulo;
TlistaDescripcion = array [1..20] of String;


var
  frmMenu: TfrmMenu;
  vectorArticulos : TListaArticulos;
  Nro_Articulos : integer;
  cantidadArticulosA: integer;
  cantidadArticulosB: integer;
  cantidadArticulosC: integer;
  modoEdicion: boolean;
  indiceArticuloEditar: integer;

implementation

{$R *.lfm}

{ TfrmMenu }



procedure TfrmMenu.btnSalirClick(Sender: TObject);
begin
  Close;
end;

function calcularStockMinimo(tipo : char) : integer;
var
  minimo,i: integer;
  flag : boolean;
begin
  flag:= true;
  minimo:= 0;
  for i:=1 to Nro_Articulos do
  begin
       if vectorArticulos[i].tipoArticulo = tipo then
       begin
         if flag then
            begin
               minimo := vectorArticulos[i].stock;
               flag:= false;
            end
         else
         begin
            if vectorArticulos[i].stock < minimo then
               minimo:= vectorArticulos[i].stock
         end;
       end;
  end;
  calcularStockMinimo:= minimo
end;

procedure actualizarCantidadProductos();
var
  index: integer;
begin

   index := frmMenu.cbxCantidadArticulosPorTipo.ItemIndex;
   if index >= 0 then
   begin

       if frmMenu.cbxCantidadArticulosPorTipo.Items[index] = 'A' then
          begin
             frmMenu.lblNumeroArticulos.Caption := IntToStr(cantidadArticulosA);
             frmMenu.lblCantidadStockMinimo.Caption := IntToStr(calcularStockMinimo('A'))
          end;


       if frmMenu.cbxCantidadArticulosPorTipo.Items[index] = 'B' then
          begin
             frmMenu.lblNumeroArticulos.Caption := IntToStr(cantidadArticulosB);
             frmMenu.lblCantidadStockMinimo.Caption := IntToStr(calcularStockMinimo('B'))
          end;

       if frmMenu.cbxCantidadArticulosPorTipo.Items[index] = 'C' then
          begin
             frmMenu.lblNumeroArticulos.Caption := IntToStr(cantidadArticulosC);
             frmMenu.lblCantidadStockMinimo.Caption := IntToStr(calcularStockMinimo('C'))
          end;
   end;
end;


procedure TfrmMenu.cbxCantidadArticulosPorTipoChange(Sender: TObject);
begin
   actualizarCantidadProductos();
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
var
  FBackImage: TPicture;
begin
  FBackImage := TPicture.Create;
  FBackImage.LoadFromFile('fondo.png');
end;

procedure TfrmMenu.grdArticulosButtonClick(Sender: TObject; aCol, aRow: Integer
  );
begin
     // Este procedimiento se ejecuta cada vez que se pulsa el boton que se encuentra
     // dentro de cada una de las filas del String Grid

     // El indice de la fila donde se selecciono se guarda en la variable aRow
    indiceArticuloEditar:=aRow;

    // Volver a rellenar los campos con los datos que se encuentran en el vector
    frmMenu.edtCodigo.Text := IntToStr(vectorArticulos[aRow].codigo);
    frmMenu.edtPrecio.Text := FloatToStr(vectorArticulos[aRow].precioUnitario);
    frmMenu.edtStock.Text := IntToStr(vectorArticulos[aRow].stock);
    frmMenu.cbxTipo.Text := vectorArticulos[aRow].tipoArticulo;
    frmMenu.edtDescripcion.Text := vectorArticulos[aRow].descripcion;
    if vectorArticulos[aRow].estado = 'Activo' then
       frmMenu.chkEstado.Checked := True
    else
      frmMenu.chkEstado.Checked := False;

    // Esta variable permitira saber si hay que agregar un nuevo valor o solo editar uno ya existente
    modoEdicion := true;
    frmMenu.lblEditando.Visible := True;
    frmMenu.btnRegistrar.Caption := 'Guardar';

end;





procedure TfrmMenu.lblTituloCantidadTipoArticuloClick(Sender: TObject);
begin

end;

procedure calcularCantidadArticulosPorTipo();
var
   i: integer;
begin
   cantidadArticulosA := 0;
   cantidadArticulosB := 0;
   cantidadArticulosC := 0;
   for i:=1 to Nro_Articulos do
   begin
        if vectorArticulos[i].tipoArticulo = 'A' then
           cantidadArticulosA := cantidadArticulosA + 1;

        if vectorArticulos[i].tipoArticulo = 'B' then
           cantidadArticulosB := cantidadArticulosB + 1;

        if vectorArticulos[i].tipoArticulo = 'C' then
           cantidadArticulosC := cantidadArticulosC + 1;
   end;
end;




function registrosValidados() : boolean;
var
  esValido: boolean;
  codigo : String;
  precio : String;
  stock : String;
  tipo_articulo : String;
  descripcion: String;
begin
  esValido:= true;

  codigo:= frmMenu.edtCodigo.Text;
  precio:= frmMenu.edtPrecio.Text;
  stock:= frmMenu.edtStock.Text;
  tipo_articulo:= frmMenu.cbxTipo.Text;
  descripcion:= frmMenu.edtDescripcion.Text;

  if(codigo = '') then
     esValido := false;
  if(precio = '') then
     esValido := false;
  if(stock = '') then
     esValido := false;
  if(descripcion = '') then
     esValido := false;
  if(tipo_articulo = '') then
     esValido := false;

  registrosValidados:= esValido;
end;

function existeCodigo(): boolean;
var
  i : integer;
  codigo : integer;
  existe: boolean;
begin
   existe:= false;
   codigo:= StrToInt(frmMenu.edtCodigo.Text);
   for i:=1 to Nro_Articulos do
   begin
        if (codigo = vectorArticulos[i].codigo) then
           existe:= true;
   end;

   // Si se esta editando un articulo, el codigo puede seguir siendo el mismo
   if(modoEdicion) then
      existe := false;
   existeCodigo:= existe;

end;

function getEstado(): String;
var
    estado: String;
begin
   if(frmMenu.chkEstado.Checked) then
      estado:= 'Activo'
   else
      estado:= 'Inactivo';
   getEstado:= estado;
end;

function getArticulo(): TArticulo;
var
    articulo: TArticulo;
begin
     articulo.codigo:= StrToInt(frmMenu.edtCodigo.Text);
     articulo.precioUnitario:= frmMenu.edtPrecio.Value;
     articulo.stock:= StrToInt(frmMenu.edtStock.Text);
     articulo.tipoArticulo:= frmMenu.cbxTipo.Text[1];
     articulo.descripcion:= frmMenu.edtDescripcion.Text;

     articulo.estado := getEstado();

     articulo.tipoArticulo:= frmMenu.cbxTipo.Text[1];

     getArticulo:= articulo;
end;



procedure agregarArticulo(articulo: TArticulo; var vectorArticulos: TListaArticulos; var Nro_Articulos: integer);
begin
   // Si la varible modoEdicion es True significa que se esta editando un articulo
  if modoEdicion then
     // El indice del articulo que es esta editando esta en la variable indiceArticuloEditar
     begin
        vectorArticulos[indiceArticuloEditar] := articulo;
        modoEdicion := false;
        frmMenu.lblEditando.Visible := False;
        frmMenu.btnRegistrar.Caption := 'Registrar';
     end
  else
      // Si no se esta editando un articulo, solo se agrega un articulo mas
      begin
         Nro_Articulos :=  Nro_Articulos+1;
         vectorArticulos[Nro_Articulos] := articulo;
      end;
end;

procedure mostrarEnTabla(vectorArticulos:TListaArticulos;Nro_Articulos:integer;buscarPorCodigo: boolean = false; codigoIngresado: String = '');
var
    i,fila: integer;
    codigo : String;
    precioUnitario: String;
    stock: String;
    tipoArticulo: char;
    descripcion: TString50;
    estado: TString10;

begin
   frmMenu.grdArticulos.RowCount := 1;
    if (not buscarPorCodigo) then
    begin

       end;
    for i:=1 to Nro_Articulos do
    begin
         if (not buscarPorCodigo) then
         begin
           frmMenu.grdArticulos.RowCount := frmMenu.grdArticulos.RowCount+1;
           fila := frmMenu.grdArticulos.RowCount;

           codigo := IntToStr(vectorArticulos[i].codigo);
           precioUnitario:= FloatToStr(vectorArticulos[i].precioUnitario);
           stock:= IntToStr(vectorArticulos[i].stock);
           tipoArticulo:= vectorArticulos[i].tipoArticulo;
           descripcion:=  vectorArticulos[i].descripcion;
           estado :=  vectorArticulos[i].estado;

           frmMenu.grdArticulos.Cells[1, fila-1] := codigo;
           frmMenu.grdArticulos.Cells[2, fila-1] := ('$'+precioUnitario);
           frmMenu.grdArticulos.Cells[3, fila-1] := stock;
           frmMenu.grdArticulos.Cells[4, fila-1] := tipoArticulo;
           frmMenu.grdArticulos.Cells[5, fila-1] := descripcion;
           frmMenu.grdArticulos.Cells[6, fila-1] := estado;

         end
         else
         begin
             if (codigoIngresado = IntToStr(vectorArticulos[i].codigo)) then
             begin
               frmMenu.grdArticulos.RowCount := frmMenu.grdArticulos.RowCount+1;
               fila := frmMenu.grdArticulos.RowCount;

               codigo := IntToStr(vectorArticulos[i].codigo);
               precioUnitario:= FloatToStr(vectorArticulos[i].precioUnitario);
               stock:= IntToStr(vectorArticulos[i].stock);
               tipoArticulo:= vectorArticulos[i].tipoArticulo;

               frmMenu.grdArticulos.Cells[0, fila-1] := codigo;
               frmMenu.grdArticulos.Cells[1, fila-1] := ('$'+precioUnitario);
               frmMenu.grdArticulos.Cells[2, fila-1] := stock;
               frmMenu.grdArticulos.Cells[3, fila-1] := tipoArticulo;
               frmMenu.grdArticulos.Cells[4, fila-1] := descripcion;
               frmMenu.grdArticulos.Cells[5, fila-1] := estado;
             end;
         end;

    end;
end;

procedure limpiarFormulario();
begin
   frmMenu.edtCodigo.Text := '';
   frmMenu.edtPrecio.Text := '';
   frmMenu.edtStock.Text := '';
   frmMenu.edtDescripcion.Text := '';
   frmMenu.chkEstado.Checked:= true;

end;

function buscarPorCodigo(codigoIngresado: String): integer;
var
    i,longitudCadena, posicionCodigo: integer;

begin

    longitudCadena := Length(codigoIngresado);

    for i:=1 to Nro_Articulos do
    begin
       if LeftStr(codigoIngresado,longitudCadena) = LeftStr(IntToStr(vectorArticulos[i].codigo),longitudCadena) then
          posicionCodigo := i
    end;
    buscarPorCodigo := posicionCodigo
end;

procedure TfrmMenu.btnBuscarPorCodigoClick(Sender: TObject);
var
  indice : integer;
  codigoIngresado,codigoEncontrado : String;
begin
  codigoIngresado := frmMenu.edtBuscarPorCodigo.Text;
  frmMenu.edtBuscarPorCodigo.Text := '';
  if codigoIngresado <> '' then
  begin
     indice := buscarPorCodigo(codigoIngresado);
     codigoEncontrado := IntToStr(vectorArticulos[indice].codigo);
     mostrarEnTabla(vectorArticulos, Nro_Articulos,true,codigoEncontrado)
  end
  else
     mostrarEnTabla(vectorArticulos, Nro_Articulos);

end;

procedure TfrmMenu.btnCargarAlAzarClick(Sender: TObject);
var
   codigo: integer;
   stock: integer;
   descripcion : String;
   precioUnitario: real;
   tipoArticulo: String;
   estado: String;
begin

end;



procedure ordenarMetodoSeleccion(Var vectorArticulos : TListaArticulos; Nro_Articulos : Integer);
Var
I, J, K: Integer;
Y: TArticulo;
Begin
  For I := 1 To Nro_Articulos - 1 Do
  Begin
    K := I;
    Y := vectorArticulos[I];
    For J := (I + 1) To Nro_Articulos Do

      if (vectorArticulos[J].precioUnitario > Y.precioUnitario) Then
      Begin
        K := J;
        Y := vectorArticulos[J];
      End;
    vectorArticulos[K] := vectorArticulos[I];
    vectorArticulos[I] := Y;


  End
End;

procedure intercambiar(var vectorArticulos : TListaArticulos; articuloA : integer; articuloB: integer);
var
  aux: TArticulo;
begin
  aux:= vectorArticulos[articuloA];
  vectorArticulos[articuloA] :=   vectorArticulos[articuloB];
  vectorArticulos[articuloB] := aux;
end;

Procedure ordenarMetodoShell(Var vectorArticulos : TListaArticulos; Nro_Articulos : Integer);
Var
  Done: Boolean;
  Jump,
  I,
  J : Integer;
Begin
  Jump := Nro_Articulos;
  While (Jump > 1) Do
  Begin
    Jump := Jump Div 2;
    Repeat
      Done := true;
      For J := 1 To (Nro_Articulos - Jump) Do
      Begin
        I := J + Jump;
        If (vectorArticulos[J].descripcion > vectorArticulos[I].descripcion) Then
        Begin
          intercambiar(vectorArticulos,J, I);
          Done := false
        End;
      End;
    Until Done;
  End
End;




procedure TfrmMenu.btnOrdenarPrecioClick(Sender: TObject);
begin
    ordenarMetodoSeleccion(vectorArticulos,Nro_Articulos);
    mostrarEnTabla(vectorArticulos,Nro_Articulos);

end;

procedure TfrmMenu.btnOrdenarDescrpcionClick(Sender: TObject);
begin
  ordenarMetodoShell(vectorArticulos,Nro_Articulos);
    mostrarEnTabla(vectorArticulos,Nro_Articulos);
end;




procedure TfrmMenu.btnRegistrarClick(Sender: TObject);
var
  articulo: TArticulo;
begin
  if (not registrosValidados) then
     ShowMessage('Ingrese todos los campos correctamente')
  else
      if(existeCodigo()) then
         ShowMessage('Este codigo ya existe')
      else
        begin
           articulo := getArticulo();
           agregarArticulo(articulo,vectorArticulos,Nro_Articulos);
           mostrarEnTabla(vectorArticulos,Nro_Articulos);
           calcularCantidadArticulosPorTipo();
           actualizarCantidadProductos();
           limpiarFormulario();
        end;
end;



end.
initialization
    Nro_Articulos:= 0;
    cantidadArticulosA:= 0;
    cantidadArticulosB:= 0;
    cantidadArticulosC:= 0;
    modoEdicion:= false;
    TListaDescripcion := ['Manzana','Remera','Pantalon','Microfono','Celular'.'CD','Auricular','Monitor','Papa','Lechuga','Tomate','Bicicleta','Mouse','Lapicera','Pendrive','Impresora'.'Pantalon','Campera'];

