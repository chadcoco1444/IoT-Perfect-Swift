import PerfectLib
import MariaDB
import PerfectHTTP

public func getMessagesForID(request: HTTPRequest, response: HTTPResponse) {
        let mysql = MySQL()
        let connected = mysql.connect(host:testHost, user: testUser, password: testPassword)
	
        guard connected else {
            print(mysql.errorMessage())
            response.appendBody(string:"500, message: couldnt connect to mysql")
            response.completed();
        return
        }
		let params = request.urlVariables
       	let deviceID = params["deviceid"]!
	
		guard !deviceID.isEmpty else{
            response.appendBody(string:"400, message: give me an deviceID")
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
	
		let querySuccess = mysql.query(statement: "SELECT deviceID,sensorValue1,sensorValue2,sensorValue3,sensorValue4,sensorValue5,sensorValue6,sensorValue7,sensorValue8,ts+0 FROM \(testTable) WHERE deviceID='\(deviceID)';")
        guard querySuccess else {
            print(mysql.errorMessage())
            response.appendBody(string:"500, message: Query Error ")
            response.completed();
        return
        }
		let results = mysql.storeResults()!
		//response.appendBody(string:"{")
		results.forEachRow{ row in
        	let deviceID = row[0]
        	let sensorValue1 = row[1]
        	let sensorValue2 = row[2]
        	let sensorValue3 = row[3]
        	let sensorValue4 = row[4]
			let sensorValue5 = row[5]
			let sensorValue6 = row[6]
			let sensorValue7 = row[7]
			let sensorValue8 = row[8]
			let timestamp = row[5]
		/*response.appendBody(string:"\"\(timestamp!)\":[{\"deviceID\":\(deviceID!),\"sensorValue1\":\(sensorValue1!),\"sensorValue2\":\(sensorValue2!),\"sensorValue3\":\(sensorValue3!),\"sensorValue4\":\(sensorValue4!)}],")    	
*/
		response.appendBody(string:"{\"deviceID\":\(deviceID!),\"sensorValue1\":\(sensorValue1!),\"sensorValue2\":\(sensorValue2!),\"sensorValue3\":\(sensorValue3!),\"sensorValue4\":\(sensorValue4!),\"sensorValue5\":\(sensorValue5!),\"sensorValue6\":\(sensorValue6!),\"sensorValue7\":\(sensorValue7!),\"sensorValue8\":\(sensorValue8!),\"timestamp\":\"\(timestamp!)\"}\n")
	}
		//response.appendBody(string:"}")
		response.addHeader(.contentType, value: "application/json")
        response.addHeader(.accessControlAllowOrigin, value: "*")
        response.status = HTTPResponseStatus.ok
        //response.appendBody(string:"200, message: Mission Success ")
        response.completed()
}

