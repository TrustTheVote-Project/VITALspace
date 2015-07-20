require 'hashie'

class VTL::Header < Hashie::Mash

  include Hashie::Extensions::Coercion

  ATTRS = {
    'origin'     => 'origin',
    'originUniq' => 'origin_uniq',
    'createDate' => 'create_date',
    'hashAlg'    => 'hash_alg' }

end
