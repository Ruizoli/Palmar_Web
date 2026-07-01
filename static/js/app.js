function money(n){
  return 'C$' + (Number(n || 0)).toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  });
}

document.addEventListener('DOMContentLoaded', function(){

  const canvas = document.getElementById('ventasChart');

  if(canvas && window.Chart){
    new Chart(canvas, {
      type: 'line',
      data: {
        labels: window.dashboardLabels || [],
        datasets: [{
          label: 'Ventas',
          data: window.dashboardValues || [],
          tension: 0.35,
          borderWidth: 3,
          pointRadius: 5,
          pointHoverRadius: 7,
          fill: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return money(context.raw);
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            suggestedMax: 15000,
            ticks: {
              stepSize: 2000,
              callback: function(value) {
                return Number(value).toLocaleString('en-US');
              }
            },
            title: {
              display: true,
              text: 'C$'
            },
            grid: {
              color: 'rgba(0,0,0,.10)'
            }
          },
          x: {
            grid: {
              color: 'rgba(0,0,0,.08)'
            }
          }
        }
      }
    });
  }

  // FACTURACIÓN estilo escritorio
  const prodSelect = document.getElementById('producto_select');
  const precioTmp = document.getElementById('precio_tmp');
  const cantidadTmp = document.getElementById('cantidad_tmp');
  const tablaVenta = document.querySelector('#tablaVenta tbody');
  let ventaSeleccionada = null;

  function cargarPrecio(){
    if(!prodSelect || !precioTmp) return;
    const opt = prodSelect.selectedOptions[0];
    if(opt) precioTmp.value = Number(opt.dataset.precio || 0).toFixed(2);
  }

  cargarPrecio();

  if(prodSelect){
    prodSelect.addEventListener('change', cargarPrecio);
  }

  function actualizarVenta(){
    if(!tablaVenta) return;

    let subtotal = 0;

    tablaVenta.querySelectorAll('tr').forEach(tr => {
      subtotal += Number(tr.dataset.subtotal || 0);
    });

    const iva = 0;
    const total = subtotal;

    const st = document.getElementById('subtotalText');
    const it = document.getElementById('ivaText');
    const tt = document.getElementById('totalText');

    if(st) st.textContent = money(subtotal);
    if(it) it.textContent = money(iva);
    if(tt) tt.textContent = money(total);
  }

  const addVenta = document.getElementById('agregarVentaItem');

  if(addVenta){
    addVenta.addEventListener('click', function(){
      const opt = prodSelect.selectedOptions[0];

      if(!opt) return alert('Seleccione un producto');

      const id = prodSelect.value;
      const nombre = opt.dataset.nombre;
      const stock = Number(opt.dataset.stock || 0);
      const cant = Number(cantidadTmp.value || 0);
      const precio = Number(precioTmp.value || 0);

      if(cant <= 0 || precio < 0) return alert('Cantidad o precio inválido');
      if(cant > stock) return alert('Stock insuficiente. Disponible: ' + stock);

      const sub = cant * precio;

      const tr = document.createElement('tr');
      tr.dataset.subtotal = sub;

      tr.innerHTML = `
        <td>${id}<input type="hidden" name="producto_id" value="${id}"></td>
        <td>${nombre}</td>
        <td>${cant}<input type="hidden" name="cantidad" value="${cant}"></td>
        <td>${money(precio)}</td>
        <td>${money(sub)}</td>
        <td><button type="button" class="btn btn-sm btn-outline-danger borrar-fila">X</button></td>
      `;

      tablaVenta.appendChild(tr);

      cantidadTmp.value = 1;
      actualizarVenta();
    });
  }

  if(tablaVenta){
    tablaVenta.addEventListener('click', function(e){
      const tr = e.target.closest('tr');
      if(!tr) return;

      tablaVenta.querySelectorAll('tr').forEach(r => r.classList.remove('table-active'));
      tr.classList.add('table-active');
      ventaSeleccionada = tr;

      if(e.target.classList.contains('borrar-fila')){
        tr.remove();
        ventaSeleccionada = null;
        actualizarVenta();
      }
    });
  }

  const delVenta = document.getElementById('eliminarVentaItem');

  if(delVenta){
    delVenta.addEventListener('click', () => {
      if(ventaSeleccionada){
        ventaSeleccionada.remove();
        ventaSeleccionada = null;
        actualizarVenta();
      } else {
        alert('Seleccione un producto');
      }
    });
  }

  const cancelarVenta = document.getElementById('cancelarVenta');

  if(cancelarVenta){
    cancelarVenta.addEventListener('click', () => {
      if(tablaVenta) tablaVenta.innerHTML = '';
      actualizarVenta();
    });
  }

  const ventaForm = document.getElementById('ventaForm');

  if(ventaForm){
    ventaForm.addEventListener('submit', function(e){
      if(!tablaVenta || tablaVenta.children.length === 0){
        e.preventDefault();
        alert('Debe agregar productos');
      }
    });
  }

  // ORDEN DE COMPRA estilo escritorio
  const poSelect = document.getElementById('producto_po_select');
  const cantPo = document.getElementById('cantidad_po_tmp');
  const precioPo = document.getElementById('precio_po_tmp');
  const tablaPO = document.querySelector('#tablaPO tbody');
  let poSeleccionada = null;

  function actualizarPO(){
    if(!tablaPO) return;

    let productos = 0;
    let unidades = 0;
    let total = 0;

    tablaPO.querySelectorAll('tr').forEach(tr => {
      productos++;
      unidades += Number(tr.dataset.cantidad || 0);
      total += Number(tr.dataset.subtotal || 0);
    });

    const pp = document.getElementById('poProductos');
    const pu = document.getElementById('poUnidades');
    const pt = document.getElementById('poTotal');

    if(pp) pp.textContent = productos;
    if(pu) pu.textContent = unidades;
    if(pt) pt.textContent = money(total);
  }

  const addPO = document.getElementById('agregarPOItem');

  if(addPO){
    addPO.addEventListener('click', function(){
      const opt = poSelect.selectedOptions[0];

      if(!opt) return alert('Seleccione producto');

      const producto = poSelect.value;
      const cant = Number(cantPo.value || 0);
      const precio = Number(precioPo.value || 0);

      if(!producto || cant <= 0 || precio <= 0) {
        return alert('Ingrese cantidad y precio');
      }

      const sub = cant * precio;

      const tr = document.createElement('tr');
      tr.dataset.cantidad = cant;
      tr.dataset.subtotal = sub;
      tr.dataset.precio = precio;

      tr.innerHTML = `
        <td>${producto}<input type="hidden" name="producto" value="${producto}"></td>
        <td>${cant}<input type="hidden" name="cantidad" value="${cant}"></td>
        <td>${money(precio)}<input type="hidden" name="precio" value="${precio}"></td>
        <td>${money(sub)}</td>
        <td><button type="button" class="btn btn-sm btn-outline-danger borrar-fila">X</button></td>
      `;

      tablaPO.appendChild(tr);
      cantPo.value = '';
      precioPo.value = '';
      actualizarPO();
    });
  }

  if(tablaPO){
    tablaPO.addEventListener('click', function(e){
      const tr = e.target.closest('tr');
      if(!tr) return;

      tablaPO.querySelectorAll('tr').forEach(r => r.classList.remove('table-active'));
      tr.classList.add('table-active');
      poSeleccionada = tr;

      if(e.target.classList.contains('borrar-fila')){
        tr.remove();
        poSeleccionada = null;
        actualizarPO();
      }
    });
  }

  const delPO = document.getElementById('eliminarPOItem');

  if(delPO){
    delPO.addEventListener('click', () => {
      if(poSeleccionada){
        poSeleccionada.remove();
        poSeleccionada = null;
        actualizarPO();
      } else {
        alert('Seleccione un producto');
      }
    });
  }

  const editPO = document.getElementById('editarPOItem');

  if(editPO){
    editPO.addEventListener('click', () => {
      if(!poSeleccionada) return alert('Seleccione un producto');

      const producto = poSeleccionada.querySelector('input[name="producto"]').value;

      poSelect.value = producto;
      cantPo.value = poSeleccionada.dataset.cantidad;
      precioPo.value = poSeleccionada.dataset.precio;

      poSeleccionada.remove();
      poSeleccionada = null;
      actualizarPO();
    });
  }

  const ordenForm = document.getElementById('ordenForm');

  if(ordenForm){
    ordenForm.addEventListener('submit', function(e){
      if(!tablaPO || tablaPO.children.length === 0){
        e.preventDefault();
        alert('Debe agregar productos');
      }
    });
  }

});