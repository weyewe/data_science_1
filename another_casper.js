
var fs = require('fs');

var casper = require('casper').create({
    verbose: true,
    logLevel: 'error',
    pageSettings: {
        loadImages: false,
        loadPlugins: false,
        userAgent: 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36'
    }
});
casper.start();
casper.then(function readFile() {
	stream = fs.open('e27_delay.csv', 'r');
	line = stream.readLine();
	i = 0;
	while(line) {
		casper.echo(line);
		line = stream.readLine();
		i++;
	}
});

casper.run();