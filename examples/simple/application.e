note
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			s: DEFAULT_SERVICE_LAUNCHER
		do
			create s.make_and_launch (agent execute)
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			-- To send a response we need to setup, the status code and
			-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/plain"], ["Content-Length", "11"]>>)
			res.put_string ("Hello World")
		end

end
