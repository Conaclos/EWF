﻿note
	description: "Summary description for {JSON_ORDER_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_ORDER_CONVERTER

inherit
	JSON_CONVERTER

create
	make

feature -- Initialization

	make
		do
			create object.make ("", "", "")
		end

feature	 -- Access

	 object: ORDER

	 value: detachable JSON_OBJECT

feature -- Conversion

	from_json (j: attached like value): detachable like object
            -- Convert from JSON value. Returns Void if unable to convert
       local
            s_name, s_key, s_option: detachable STRING_32
            q: INTEGER_8
            o: ORDER
            i : ITEM
            l_array : detachable LIST [JSON_VALUE]
            is_valid_from_json : BOOLEAN
        do
            is_valid_from_json := True

            s_name   ?= json.object (j.item (id_key), Void)
            s_key    ?= json.object (j.item (location_key), Void)
            s_option ?= json.object (j.item (status_key), Void)

         	create o.make (s_name, s_key, s_option)

			if attached {JSON_ARRAY} j.item (items_key) as l_val then
				l_array := l_val.array_representation
				from
					l_array.start
				until
					l_array.after
				loop
					if attached {JSON_OBJECT} l_array.item_for_iteration as jv then
						if attached {INTEGER_8} json.object (jv.item (quantity_key), Void) as l_integer then
							q := l_integer
						else
							q := 0
						end

						s_name   ?= json.object (jv.item (id_key), Void)
						s_key    ?= json.object (jv.item (location_key), Void)
						s_option ?= json.object (jv.item (status_key), Void)

						if s_name /= Void and s_key /= Void and s_option /= Void then
							if is_valid_item_customization (s_name, s_key, s_option,q) then
								create i.make (s_name, s_key, s_option, q)
								o.add_item (i)
							else
								is_valid_from_json := False
							end
						else
							is_valid_from_json := False
						end
					end

					l_array.forth
				end
			end
			if not is_valid_from_json or o.items.is_empty then
				Result := Void
			else
				Result := o
			end
	    end

    to_json (o: like object): like value
            -- Convert to JSON value
        local
        	ja : JSON_ARRAY
        	i : ITEM
        	jv: JSON_OBJECT
        do
        	create Result.make
            Result.put (json.value (o.id), id_key)
            Result.put (json.value (o.location),location_key)
			Result.put (json.value (o.status),status_key)
            from
            	create ja.make_array
            	o.items.start
            until
            	o.items.after
            loop
            	i := o.items.item_for_iteration
            	create jv.make
            	jv.put (json.value (i.name), name_key)
            	jv.put (json.value (i.size), size_key)
            	jv.put (json.value (i.quantity), quantity_key)
            	jv.put (json.value (i.option), option_key)
            	ja.add (jv)
            	o.items.forth
            end
            Result.put(ja,items_key)
        end

 feature {NONE} -- Implementation

	id_key: JSON_STRING
        once
            create Result.make_json ("id")
        end

	location_key: JSON_STRING
        once
            create Result.make_json ("location")
        end

   status_key: JSON_STRING
        once
            create Result.make_json ("status")
        end

    items_key : JSON_STRING
	 	once
    		create Result.make_json ("items")
    	end


	name_key : JSON_STRING

    	once
    		create Result.make_json ("name")
    	end

    size_key : JSON_STRING

    	once
    		create Result.make_json ("size")
    	end

	quantity_key : JSON_STRING

    	once
    		create Result.make_json ("quantity")
    	end

    option_key : JSON_STRING

    	once
    		create Result.make_json ("option")
    	end

feature -- Validation

	is_valid_item_customization ( name :  STRING_32; size: STRING_32; option :  STRING_32; quantity :  INTEGER_8  ) : BOOLEAN
		local
			ic : ITEM_CONSTANTS
		do
				create ic
				Result := ic.is_valid_coffee_type (name) and ic.is_valid_milk_type (option) and ic.is_valid_size_option (size) and quantity > 0
		end

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
