/* Formatting function for row details - modify as you need */
function format(data, header, cols_to_display, row_data) {

    var references = data['References'];

    // put header and row_data on the extended table
    var objHeader = header;
    var objRow = row_data;
    var out = '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
    for (var h = 0; h < Object.keys(objHeader).length; h++){

        col = String.fromCharCode(97 + h).toUpperCase();
        if (cols_to_display.indexOf(objHeader[col]) == -1){
            out +=  '<tr>' + '<td>' + '<span style="font-weight:bold">' + objHeader[col] + '</span>' + 
                '</td>' + '<td>' + objRow[col] + '</td>' + '</tr>';
        }
        if (objHeader[col] == 'reference'){
            ref_code = objRow[col];
            for (var i = 1; i<references.length; i++){
                if (references[i]['B'] == ref_code){
                    out += '<tr>' + '<td>' + '<span style="font-weight:bold">' + 'Detailed Reference' + '</span>' + 
                        '</td>' + '<td>' + references[i]['C'] + '</td>' + '</tr>';
                }
            }
        }
    }
    out += '</table>';
    return out;
}


function add_tableHeader(sheet_data, table_id){

    // put header on the table
    var head = sheet_data[1];
    var tblHeader = "<tr>" + "<th>" + "</th>";
    var column_name = [];
    for (var h = 0; h < Object.keys(head).length; h++){

        col = String.fromCharCode(97 + h).toUpperCase();
        if (cols_to_display.indexOf(head[col]) > -1){
            column_name.push(col);
            tblHeader += "<th>" + head[col] + "</th>";
        }
    }
    tblHeader += "</tr>";
    $(tblHeader).appendTo(table_id + " thead");

    return column_name
}

function add_tableBody(sheet_data, table_id, column_name){

    // put content on the table body
    // i starts from 2 because first index corresponds to header
    for (var i = 2; i < sheet_data.length; i++){

        var obj = sheet_data[i];
        var tblRow = "<tr>" + "<td>" + "</td>";

        for (var j = 0; j < column_name.length; j++){
            tblRow += "<td >" + obj[column_name[j]] + "</td>";
        }
        tblRow += "</tr>";
        $(tblRow).appendTo(table_id + " tbody");
        document.getElementById("myDiv").style.display = "block";
    }
}


// Display Json from Excel
function load_table(field_name, table_id){

    var file_location = 'data/2020_04_22_structured_dataset.json';
    $.getJSON(file_location, function(data) {

        // Initialize variables
        var sheet_data = data[field_name];  // get respective sheet data
        var columns_obj = [{                // create column obj for table obj 
            "className":      'details-control',    
            "orderable":      false,
            "data":           null,
            "defaultContent": ''
        }];

        // Read and display data
        cols_to_display = ["odor", "concentration", "species", "assay",
                            "response", "or", "location", "sensillum", "preparation_type", 
                            "reference"];

        
        // add header and body content to table object
        column_name = add_tableHeader(sheet_data, table_id);   // add table header
        add_tableBody(sheet_data, table_id, column_name);  // add table body 
        
        // Update column object 
        for (var k = 0; k < column_name.length; k++){   
            columns_obj.push({"data": column_name[k]});
        }

        // Hide Loader & Display table-div
        document.getElementById("loader").style.display = "none";   // remove loader
        document.getElementById("myDiv").style.display = "block";   // display main div table

        //  create table object
        var dt  = $(table_id).DataTable(
            {
                // "scrollY": '50vh',
                "scrollCollapse": true,
                "buttons": [{extend: 'excel', text: 'Download filtered data'}],
                "searching": true,
                "oLanguage": {
                    "sSearch": "Search/ Filter"
                  },
                "responsive": false,
                "autoWidth": false,
                "dom": 'lfrtipB', 
                "columns": columns_obj,
                "order": [[1, 'asc']],
                // ajax:       {"url": "./data/2020_04_22_structured_dataset.json", dataType: 'json',"dataSrc": "data"}
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
                row.child(format(data, sheet_data[1], cols_to_display, sheet_data[row.index()])).show();
                tr.addClass('shown');
            }
        } );
        
    });
}

