// Display Json from Excel
function display_json(data, field_name, table_id){

    cols_to_display = ["odor", "concentration", "concentration_type", "species", "gender", "assay",
                        "response", "or", "location", "segment", "sensillum_type", "preparation_type", 
                        "reference"];

    var arr = data[field_name];

    // put header on the table
    var obj = arr[1];
    var tblHeader = "<tr class=\"table100-head\">" + "<th class=\"column\">" + "</th>";
    var column_name = [];
    for (var h = 0; h < Object.keys(obj).length; h++){

        col = String.fromCharCode(97 + h).toUpperCase();
        if (cols_to_display.indexOf(obj[col]) > -1){
            column_name.push(col);
            tblHeader += "<th class=\"column\">" + obj[col] + "</th>";
        }
    }
    tblHeader += "</tr>";
    $(tblHeader).appendTo(table_id + " thead");

    // put content on the table body
    for (var i = 2; i < arr.length; i++){

        var obj = arr[i];
        var tblRow = "<tr>" + "<td >" + "</td>";

        for (var j = 0; j < column_name.length; j++){
            tblRow += "<td >" + obj[column_name[j]] + "</td>";
        }
        tblRow += "</tr>";
        $(tblRow).appendTo(table_id + " tbody");
    }

    document.getElementById("loader").style.display = "none";
    document.getElementById("myDiv").style.display = "block";


    // **customize table using DataTable package**

    // create column obj for table obj 
    var columns_obj = [ {
        "className":      'details-control',
        "orderable":      false,
        "data":           null,
        "defaultContent": ''
    }];
    for (var k = 0; k < column_name.length; k++){
        columns_obj.push({"data": column_name[k]});
    }

    //  create table object
    var dt  = $(table_id).DataTable(
        {
            scrollY: 400,
            buttons: ['excel'],
            
            "autoWidth": false,
            "dom": 'lBfrtip', 
            "columns": columns_obj,
            "order": [[1, 'asc']]
        }

    );

    // Add event listener for opening and closing details
    $(table_id + ' tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = dt.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            row.child( format(data, arr[1], cols_to_display, arr[row.index()])).show();
            tr.addClass('shown');
        }
    } );
    
}

/* Formatting function for row details - modify as you need */
function format(data, header, cols_to_display, row_data) {

    var references = data['References'];

    // put header and row_data on the extended table
    var objHeader = header;
    var objRow = row_data;
    var out = '';
    for (var h = 0; h < Object.keys(objHeader).length; h++){

        col = String.fromCharCode(97 + h).toUpperCase();
        if (cols_to_display.indexOf(objHeader[col]) == -1){
            out += '<b>' + objHeader[col] + '</b>' + ': ' + objRow[col] + '<br>';
        }
        if (objHeader[col] == 'reference'){
            ref_code = objRow[col];
            for (var i = 1; i<references.length; i++){
                if (references[i]['B'] == ref_code){
                    out += '<b>' + 'Detailed Reference' + '</b>' + ': ' + references[i]['C'] + '<br>';
                }
            }
  
        }

    }

    return out;
}
 