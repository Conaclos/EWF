note
	description: "Summary description for WSF_URI_ROUTED_SERVICE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_ROUTED_SERVICE

inherit
	WSF_ROUTED_SERVICE_I [WSF_HANDLER [WSF_URI_HANDLER_CONTEXT], WSF_URI_HANDLER_CONTEXT]
		redefine
			router
		end

feature {NONE} -- Initialization

	create_router
			-- Create router
			--| it can be redefine to create with precise count if needed.
		do
			create router.make (0)
		end
feature -- Router

	router: WSF_URI_ROUTER

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
