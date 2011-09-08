note
	description: "Summary description for {DEFAULT_WGI_APPLICATION}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFAULT_WGI_APPLICATION

inherit
	WGI_APPLICATION

feature {NONE} -- Initialization

	make_and_launch
		local
			app: NINO_APPLICATION
		do
			port_number := 8123
			print ("Example: start a Nino web server on port " + port_number.out + ", %Nand reply Hello World for any request such as http://localhost:" + port_number.out + "/%N")
			create app.make_custom (agent execute, "")
			app.listen (port_number)
		end

	port_number: INTEGER

invariant
	port_number_valid: port_number > 0
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
