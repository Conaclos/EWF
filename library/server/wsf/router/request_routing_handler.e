note
	description: "Summary description for {REQUEST_ROUTING_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_ROUTING_HANDLER [H -> REQUEST_HANDLER [C],
							 C -> REQUEST_HANDLER_CONTEXT]

inherit
	REQUEST_HANDLER [C]

feature -- Access

	count: INTEGER
			-- Count of maps handled by current
		do
			Result := router.count
		end

	base_url: detachable READABLE_STRING_8
		do
			Result := router.base_url
		end

feature -- Element change

	set_base_url (a_base_url: like base_url)
			-- Set `base_url' to `a_base_url'
			-- make sure no map is already added (i.e: count = 0)
		require
			no_handler_set: count = 0
		do
			router.set_base_url (a_base_url)
		end

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		local
			hdl: detachable H
		do
			hdl := router.dispatch_and_return_handler (req, res)
			if hdl = Void then
				res.put_header ({HTTP_STATUS_CODE}.not_found, <<[{HTTP_HEADER_NAMES}.header_content_length, "0"]>>)
			end
		end

feature {NONE} -- Routing

	router: REQUEST_ROUTER [H, C]
		deferred
		end

feature -- Mapping

	map_default (h: detachable H)
			-- Map default handler
			-- If no route/handler is found,
			-- then use `default_handler' as default if not Void
		do
			router.map_default (h)
		end

	map (a_resource: READABLE_STRING_8; h: H)
			-- Map handler `h' with `a_resource'
		do
			router.map (a_resource, h)
		end

	map_with_request_methods (a_resource: READABLE_STRING_8; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
			-- Map handler `h' with `a_resource' and `rqst_methods'
		do
			router.map_with_request_methods (a_resource, h, rqst_methods)
		end

	map_agent (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]])
		do
			router.map_agent (a_resource, a_action)
		end

	map_agent_with_request_methods (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable ARRAY [READABLE_STRING_8])
		do
			router.map_agent_with_request_methods (a_resource, a_action, rqst_methods)
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
