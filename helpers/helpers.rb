module Helpers
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end
  
  def self.pick_random(array)
    return array[ (rand * array.length) % array.length ]
  end
  
  def self.generate_name_old
    # it would be nice to store these name parts in the db somewhere...
    prefixes = ["eri", "anti", "sur", "la", "fa", "mal", "bene", "ra", "to"]
    mids = ["da", "fo", "mi", "ma"]
    suffixes = ["ani", "os", "tos", "tion", "th", "st", "ton"]
    return Helpers.pick_random(prefixes) + Helpers.pick_random(mids) + Helpers.pick_random(suffixes)
  end    
  
  def self.generate_name
    prefixes = ["an", "ab", "ac", "acro", "adeno", "aero", "agro", "an", "ana", "ano", "andr", "anem", "anglo", "ante", "anthropo", "anti", "auto", "baro", "bathy", "be", "bi", "bio", "biblio", "blasto", "brady", "bromo", "broncho", "caco", "cardio", "cent", "cephalo", "chromo", "chrono", "circum", "ciono", "co", "colpo", "com", "contra", "cosmo", "counter", "crino", "cryo", "crypto", "cyto", "dactylo", "de", "deca", "deci", "demo", "dermo", "di", "didacto", "dynamo", "dis", "doxo", "dys", "eco", "ectos", "edapho", "electro", "embryo", "encephalo", "endo", "ennea", "entero", "eo", "epi", "ergo", "erythro", "eroto", "stomo", "ethno", "eu", "ex", "exo", "extra", "flori", "fore", "gyn", "hemi", "hexa", "hyper", "hypo", "in", "in", "inter", "intra", "kilo", "mal", "maxi", "mega", "meta", "micro", "mid", "milli", "mini", "mis", "mono", "multi", "non", "non", "octo", "oo", "out", "over", "penta", "post", "pre", "pro", "quadr", "quin", "quinti", "re", "recti", "sclero", "semi", "septa", "sexi", "Sino", "spasmo", "spermo", "sphero", "sphygmo", "spleno", "splanchno", "schizo", "staphylo", "stylo", "sub", "super", "syn", "tachy", "tele", "telo", "trans", "tri", "ultra", "un", "uni", "ur", "zoo"]
    suffixes = ["agogy", "archy", "cele", "cele", "centesis", "chondrion", "cide", "cracy", "cycle", "ectasia", "ectomy", "emesis", "emia", "enchyma", "ess", "esthesis", "fugal", "ful", "hedron", "holic", "ic", "id", "ism", "ist", "itis", "itude", "ium", "kinesis", "less", "ly", "mania", "ography", "oid", "ology", "omics", "onomy", "onym", "osis", "osis", "osis", "phagy", "philia", "phobia", "phone", "science", "scope", "ship", "stan", "tropism", "us", "ward", "wise"]
    return Helpers.pick_random(prefixes) + Helpers.pick_random(suffixes)
  end
  
  
    
end