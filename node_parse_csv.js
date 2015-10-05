var columns = ["column1", "column2" ];
require("csv-to-array")({
  file: "/home/ubuntu/workspace/e27_delay.csv",
  columns: columns
}, function (err, array) {
//   console.log(err || array);
  
//   console.log("The column_1: " +  array); 
    for (var i = 0; i < array.length; i++) { 
        var text = array[i]; 
        
        var id = console.dir(text["column1"]);
        var url = console.dir(text["column2"]);
        // console.log( text ) ;
    }
});

 