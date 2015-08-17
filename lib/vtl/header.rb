require 'hashie'

class VTL::Header < Hashie::Mash

  include Hashie::Extensions::Coercion

  ATTRS = {
    'origin'     => { name: 'origin' },
    'originUniq' => { name: 'origin_uniq' },
    'createDate' => { name: 'create_date' },
    'hashAlg'    => { name: 'hash_alg' } }

end
