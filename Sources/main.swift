import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

let server = HTTPServer()

var routes = Routes()

routes.add(method: .get, uri: "/getmessage", handler: getAllMessages)
//routes.add(method: .get, uri: "/getmessage/{deviceID}", handler: getMessagesForID)
routes.add(method: .post, uri: "/postmessage", handler: postMessage)

routes.add(method: .get, uri: "/getlatest/{deviceID}", handler: latestDeviceMessage)
let dir = Dir(server.documentRoot)
if !dir.exists {
    try Dir(server.documentRoot).create()
}
routes.add(method: .get, uri: "/morris", handler: {
                request, response in
                response.setHeader(.contentType, value: "text/html")
                mustacheRequest(
                request: request,
                response: response,
                handler: ListHandler(),
                templatePath: request.documentRoot + "/morris-data.mustache"
        )
                response.completed()
        }
)

routes.add(method: .get, uri: "/", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")
		mustacheRequest(
                request: request,
                response: response,
                handler: ListHandler(),
                templatePath: request.documentRoot + "/index.mustache"
        )
		response.completed()
	}
)

routes.add(method: .get, uri: "/table", handler: {
                request, response in
                response.setHeader(.contentType, value: "text/html")
                mustacheRequest(
                request: request,
                response: response,
                handler: ListHandler(),
                templatePath: request.documentRoot + "/table.mustache"
        )
                response.completed()
        }
)

server.addRoutes(routes)
routes.add(method: .get, uri: "/db", handler: useMysql)

server.serverPort = 8181

server.documentRoot = "./webroot"

configureServer(server)

do {
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}

