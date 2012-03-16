note
	description: "Summary description for {DEFAULT_REQUEST_URI_TEMPLATE_ROUTING_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_ROUTING_HANDLER

inherit
	WSF_URI_TEMPLATE_ROUTING_HANDLER_I [WSF_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT], WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		redefine
			router
		end

create
	make

feature {NONE} -- Routing

	router: WSF_URI_TEMPLATE_ROUTER

;note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
