import PerfectLib
import PerfectHTTP
import PerfectMustache
import MariaDB


struct ListHandler: MustachePageHandler {
        func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
                let mysql = MySQL()
                let connected = mysql.connect(host:testHost, user: testUser, password: testPassword)

		var values = MustacheEvaluationContext.MapType()
                var ary = [Any]()
		var ary2 = [Any]()
                guard connected else {
	                print(mysql.errorMessage())
                return
                }

                let selectSuccess = mysql.selectDatabase(named: testSchema)

                guard selectSuccess else {
                        print(mysql.errorMessage())
                return
                }

                defer { mysql.close() }

                //let querySuccess = mysql.query(statement: "SELECT deviceID,sensorValue1,sensorValue2,sensorValue3,sensorValue4,sensorValue5,sensorValue6,sensorValue7,sensorValue8,date_format(ts+0,'%d') FROM \(testTable) WHERE deviceID='5487' ;")
		let querySuccess = mysql.query(statement: "SELECT deviceID,sensorValue1,sensorValue2,sensorValue3,sensorValue4,sensorValue5,sensorValue6,sensorValue7,sensorValue8,ts FROM \(testTable);")
		guard querySuccess else {
                        print(mysql.errorMessage())
                return
                }

                let results = mysql.storeResults()!
                        results.forEachRow{ row in
                                var thisPost = [String:String]()
				var bydevice = [String:String]()
				thisPost["deviceID"] = row[0]
                                thisPost["sensorValue1"] = row[1]
                                thisPost["sensorValue2"] = row[2]
                                thisPost["sensorValue3"] = row[3]
                                thisPost["sensorValue4"] = row[4]
                                thisPost["sensorValue5"] = row[5]
                                thisPost["sensorValue6"] = row[6]
                                thisPost["timestamp"] = row[9]
                                ary.append(thisPost)
				if(row[0]! == "5487" ){
				bydevice["deviceID"] = row[0]
                                bydevice["sensorValue1"] = row[1]
                                bydevice["sensorValue2"] = row[2]
                                bydevice["sensorValue3"] = row[3]
                                bydevice["sensorValue4"] = row[4]
                                bydevice["sensorValue5"] = row[5]
                                bydevice["sensorValue6"] = row[6]
                                bydevice["timestamp"] = row[9]
                                ary2.append(bydevice)
				}
                }
		values["bydevice"] = ary2
                values["post"] = ary
		//print(ary)
		//values["device123"] = ary["123"]

                contxt.extendValues(with: values)
                do {
                        try contxt.requestCompleted(withCollector: collector)
                } catch {
                        let response = contxt.webResponse
                        response.status = .internalServerError
                        response.appendBody(string: "\(error)")
                        response.completed()
                }
        }
}
