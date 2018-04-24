# Database connection
conCapteurs = mongo(collection = "capteurs", db="trafic", url = "mongodb://193.51.82.104:2343")
conCapteurs_geo = mongo(collection = "capteurs_geo", db="trafic", url = "mongodb://193.51.82.104:2343")
conTrafic = mongo(collection = "trafic", db="trafic", url = "mongodb://193.51.82.104:2343")

toJSON(conCapteurs_geo$find(limit = 1), pretty = T)
