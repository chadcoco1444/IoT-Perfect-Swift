import PerfectLib
import MariaDB
import PerfectHTTP

public func postMessage(request: HTTPRequest, response: HTTPResponse) {

        let params = request.postBodyString
           
 		var deviceID = 0
        var sensorValue1 = 0.0
        var sensorValue2 = 0.0
        var sensorValue3 = 0.0
        var sensorValue4 = 0.0
		var sensorValue5 = 0.0
		var sensorValue6 = 0.0
		var sensorValue7 = 0.0
		var sensorValue8 = 0.0      
		do {
            
			let encoded = params!

            guard let decoded = try encoded.jsonDecode() as? [String:Any] else {
                return
            }
		
		for (key, value) in decoded {
            switch key {
                case "deviceID":
                    guard value is Int else {
                    	response.appendBody(string:"Params[deviceID] were no good")
                    	response.completed()
                	return 
					}
                    
				deviceID = value as! Int
                
				case "sensorValue1":
                	guard value is Double else {
                        response.appendBody(string:"Params[sensorValue1]  were no good")
                        response.completed()
                    return 
					}

                sensorValue1 = value as! Double
                
				case "sensorValue2":
                	guard value is Double else {
						response.appendBody(string:"Params[sensorValue2] were no good")
						response.completed()
                    return 
					}

                sensorValue2 = value as! Double
            
				case "sensorValue3":
                	guard value is Double else {
						response.appendBody(string:"Params[sensorValue3] were no good")
						response.completed()
					return 
					}

				 sensorValue3 = value as! Double
				
				case "sensorValue4":
                    guard value is Double else {
                        response.appendBody(string:"Params[sensorValue4] were no good")
                        response.completed()
                    return
                    }
                sensorValue4 = value as! Double

				case "sensorValue5":
                    guard value is Double else {
                        response.appendBody(string:"Params[sensorValue5] were no good")
                        response.completed()
                    return
                    }
                sensorValue5 = value as! Double

				case "sensorValue6":
                    guard value is Double else {
                        response.appendBody(string:"Params[sensorValue6] were no good")
                        response.completed()
                    return
                    }
                sensorValue6 = value as! Double

				case "sensorValue7":
                    guard value is Double else {
                        response.appendBody(string:"Params[sensorValue7] were no good")
                        response.completed()
                    return
                    }
                sensorValue7 = value as! Double

				case "sensorValue8":
                    guard value is Double else {
                        response.appendBody(string:"Params[sensorValue8] were no good")
                        response.completed()
                    return
                    }
                sensorValue8 = value as! Double
                default:
                    break
			}//switch
		}//for

     }//do   
		
		catch {
			response.appendBody(string:"Params were no good")
			response.completed();
        return
		}
        
		let mysql = MySQL()
        let connected = mysql.connect(host:testHost, user: testUser, password: testPassword)

        guard connected else {
            print(mysql.errorMessage())
            response.appendBody(string:"500, message: Didnt connect to the database")
            response.completed()
        return
        }

        let selectSuccess = mysql.selectDatabase(named: testSchema)
        guard selectSuccess else {
            print(mysql.errorMessage())
            response.appendBody(string:"Select Database ERROR")
        return
        }

        let querySuccess = mysql.query(statement: "INSERT INTO \(testTable) VALUES ('\(deviceID)', '\(sensorValue1)','\(sensorValue2)','\(sensorValue3)','\(sensorValue4)','\(sensorValue5)','\(sensorValue6)','\(sensorValue7)','\(sensorValue8)',NULL);")

        guard querySuccess else {
            print(mysql.errorMessage())
            response.appendBody(string:"500, message: Could not insert to database")
            response.completed();
        return
        }

 		/*print("\n===================================================================================================\nINSERT DATA TPYE: JSON\n deviceID : \(deviceID)  sensorValue1 : \(sensorValue1)  sensorValue2 : \(sensorValue2)  sensorValue3 : \(sensorValue3)  sensorValue4 : \(sensorValue4) sensorValue5 : \(sensorValue5) sensorValue6 : \(sensorValue6) sensorValue7 : \(sensorValue7) sensorValue8 : \(sensorValue8)")
*/
        response.appendBody(string:"\n============================================================================\nINSERT DATA TPYE: JSON\ndeviceID : \(deviceID) \nTemperature : \(sensorValue1)\nHumidity : \(sensorValue2)\nLongitude : \(sensorValue3)\nLatitude : \(sensorValue4)\nVoltage : \(sensorValue5)\nSwitch : \(sensorValue6)\nFan PWM : \(sensorValue7)\nLed : \(sensorValue8)\n")

        response.appendBody(string:"200, message: post success thank you\n")
        response.completed()
}
