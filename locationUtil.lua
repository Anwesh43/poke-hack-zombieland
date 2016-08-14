locationHelper = {}
locationHelper.calculateDistance = function(lat1,lon1,lat2,lon2)
    fi = (lat2-lat1)*(3.14)/180
    theta = (lon2-lon1)*(3.14)/180
    print(fi)
    print(theta)
    R=6371000
    a = math.sin(fi/2)*math.sin(fi/2)+math.sin(theta/2)*math.sin(theta/2)*math.cos(lat1*3.14/180)*math.cos(lat2*3.14/180)
    print("a is",a)
    c = math.atan2(math.sqrt(a),math.sqrt(1-a))
    return 2*R*c
end
return locationHelper
