import PerfectLib
import MariaDB
import PerfectHTTP


public func getAllMessages(request: HTTPRequest, response: HTTPResponse) {
	let mysql = MySQL()
	let connected = mysql.connect(host:testHost, user: testUser, password: testPassword)

	guard connected else {
		print(mysql.errorMessage())
		response.appendBody(string:"500, message: Couldn't connect to MySQL")
    	response.completed();
    return
	}

    let selectSuccess = mysql.selectDatabase(named: testSchema)
    
	guard selectSuccess else {
        print(mysql.errorMessage())
        response.appendBody(string:"Select Database ERROR")
    return
    }

    defer { mysql.close() }

    let querySuccess = mysql.query(statement: "SELECT deviceID,sensorValue1,sensorValue2,sensorValue3,sensorValue4,sensorValue5,sensorValue6,sensorValue7,sensorValue8,ts FROM \(testTable);")

    guard querySuccess else {
		print(mysql.errorMessage())
        response.appendBody(string:"500, message: Things went wrong querying the table")
        response.completed();
     return
    }
	response.setHeader(.contentType,value:"text/html")
	response.appendBody(string:"<html><title>Get All Database Info.</title><style></style><body><table width=100%; border=31px solid #000000; text-align=right;><tr><th>deviceID</th><th>Sensor-1</th><th>Sensor-2</th><th>Sensor-3</th><th>Sensor-4</th><th>Sensor-5</th><th>Sensor-6</th><th>Time</th></tr>")
    let results = mysql.storeResults()!
	results.forEachRow{ row in
		let deviceID = row[0]
		let sensorValue1 = row[1]
		let sensorValue2 = row[2]
		let sensorValue3 = row[3]
		let sensorValue4 = row[4]
		let sensorValue5 = row[5]
		let sensorValue6 = row[6]
		//let sensorValue7 = row[7]
		//let sensorValue8 = row[8]
		let timestamp    = row[9]
		response.appendBody(string:"<tr><td>\(deviceID!)</td><td>\(sensorValue1!)</td><td>\(sensorValue2!)</td><td>\(sensorValue3!)</td><td>\(sensorValue4!)</td><td>\(sensorValue5!)</td><td>\(sensorValue6!)</td><td>\(timestamp!)</td></tr>")		 

	}

	response.appendBody(string:"</table></body></html>")
    /*do{    
	response.completed()
        }
        catch{}*/
	response.addHeader(.contentType, value: "application/json")
    response.addHeader(.accessControlAllowOrigin, value: "*")
    response.status = HTTPResponseStatus.ok
	response.completed()
}

