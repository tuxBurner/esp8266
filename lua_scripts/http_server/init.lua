  
function handleReq(params)
  print("bbla") 
end

  
httpserver=require('http_server')
httpserver.init(80,handleReq)