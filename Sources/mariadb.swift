import PerfectLib
import MariaDB
import PerfectHTTP

let testHost = "127.0.0.1"
let testUser = "jason"
let testPassword = "jason123"
let testSchema = "demo"
let testTable = "demoCloudtest"

let dataMysql = MySQL()
public func useMysql(_ request: HTTPRequest, response: HTTPResponse) {

    let mysql = MySQL()
    let connected = mysql.connect(host: testHost, user: testUser, password: testPassword)

    guard connected else { print(mysql.errorMessage()); return }

    defer { mysql.close() }

    var isDatabase = mysql.selectDatabase(named:testSchema)

    if !isDatabase {
        isDatabase = mysql.query(statement: "CREATE DATABASE \(testSchema);")
    }

    let isTable = mysql.query(statement: "CREATE TABLE IF NOT EXISTS \(testTable) (deviceID VARCHAR(20), sensorValue1 FLOAT(8,5),sensorValue2 FLOAT(8,5), sensorValue3 FLOAT(8,5),sensorValue4 FLOAT(8,5),sensorValue5 FLOAT(8,5),sensorValue6 FLOAT(8,5),sensorValue7 FLOAT(8,5),sensorValue8 FLOAT(8,5),ts TIMESTAMP);")

    guard isDatabase && isTable else {
        print(mysql.errorMessage()); return
    }
}
