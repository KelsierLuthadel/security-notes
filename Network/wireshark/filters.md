# Wireshark filtering

## contains
The `contains` filter will look for an exact string. It is important to note that this filter is case-sensitive.

**example**   
`frame contains "google"`   
   
`http.request.method contains "GET"`   

## matches
The `matches` filter uses regular expressions to find results. This filter is not case-sensitive.   

**example**   
`http.host matches "\.(com|org|net)"`   
   
`frame matches GooGle`   
   
`http.request.method matches "POST"`   

## in
The `in` filter will look for a range of values.   

**example**   
`tcp.port in {80 443 8080..8082}`   
   
`http.request.method in {GET,POST}`



