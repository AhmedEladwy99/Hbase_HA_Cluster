create 'webpages',
  {NAME => 'content', VERSIONS => 3, TTL => 7776000},     
  {NAME => 'metadata', VERSIONS => 1},
  {NAME => 'outlinks', VERSIONS => 2, TTL => 15552000}, 
  {NAME => 'inlinks', VERSIONS => 2, TTL => 15552000}
