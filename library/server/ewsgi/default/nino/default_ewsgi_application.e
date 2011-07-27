note
	description: "Summary description for {DEFAULT_EWSGI_APPLICATION}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFAULT_EWSGI_APPLICATION

inherit
	GW_APPLICATION_IMP

feature {NONE} -- Initialization

	make_and_launch
		do
			print ("Example: start a Nino web server on port " + port_number.out + ", %Nand reply Hello World for any request such as http://localhost:8123/%N")
			(create {NINO_APPLICATION}.make_custom (agent execute, "")).listen (port_number)
		end

	port_number: INTEGER = 80

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
