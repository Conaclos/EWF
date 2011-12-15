note
	description: "[
				Main interface to send message back to the client
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_RESPONSE

create {WSF_SERVICE}
	make_from_wgi

convert
	make_from_wgi ({WGI_RESPONSE})

feature {NONE} -- Initialization

	make_from_wgi (r: WGI_RESPONSE)
		do
			wgi_response := r
		end

	wgi_response: WGI_RESPONSE
			-- Associated WGI_RESPONSE

feature -- Status report

	header_committed: BOOLEAN
			-- Header committed?
		do
			Result := wgi_response.header_committed
		end

	message_committed: BOOLEAN
			-- Message committed?
		do
			Result := wgi_response.message_committed
		end

	message_writable: BOOLEAN
			-- Can message be written?
		do
			Result := wgi_response.message_writable
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?
		do
			Result := wgi_response.status_is_set
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		require
			status_not_set: not status_is_set
			header_not_committed: not header_committed
		do
			wgi_response.set_status_code (a_code)
		ensure
			status_code_set: status_code = a_code
			status_set: status_is_set
		end

	status_code: INTEGER
			-- Response status
		do
			Result := wgi_response.status_code
		end

feature -- Header output operation

	put_header_text (a_headers: READABLE_STRING_8)
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		do
			wgi_response.put_header_text (a_headers)
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	put_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_set: not status_is_set
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
			i,n: INTEGER
		do
			set_status_code (a_status_code)
			create h.make
			if a_headers /= Void then
				from
					i := a_headers.lower
					n := a_headers.upper
				until
					i > n
				loop
					h.put_header_key_value (a_headers[i].key, a_headers[i].value)
					i := i + 1
				end
			end
			wgi_response.put_header_text (h.string)
		ensure
			header_committed: header_committed
			status_set: status_is_set
			message_writable: message_writable
		end

	put_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		do
			wgi_response.put_header_lines (a_lines)
		end

feature -- Obsolete: Header output operation

	write_header_text (a_headers: READABLE_STRING_8)
		obsolete "[2011-dec-15] use put_header_text"
		do
			put_header_text (a_headers)
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]])
		obsolete "[2011-dec-15] use put_header"
		do
			put_header (a_status_code, a_headers)
		end

	write_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		obsolete "[2011-dec-15] use put_header_lines"
		do
			put_header_lines (a_lines)
		end

feature -- Output operation

	write_string (s: READABLE_STRING_8)
		obsolete "[2011-dec-15] use put_string"
		do
			put_string (s)
		end

	write_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
		obsolete "[2011-dec-15] use put_substring"
		do
			put_substring (s, a_begin_index, a_end_index)
		end

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		do
			wgi_response.put_string (s)
		end

	put_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		do
			wgi_response.put_substring (s, a_begin_index, a_end_index)
		end

	put_chunk (s: detachable READABLE_STRING_8; a_extension: detachable READABLE_STRING_8)
			-- Write chunk `s'
			-- If s is Void, this means this was the final chunk
			-- Note: that you should have header
			-- "Transfer-Encoding: chunked"
		require
			message_writable: message_writable
			valid_chunk_extension: a_extension /= Void implies not a_extension.has ('%N') and not not a_extension.has ('%R')
		local
			l_chunk_size_line: STRING_8
			i: INTEGER
		do
			if s /= Void then
					--| Remove all left '0'
				l_chunk_size_line := s.count.to_hex_string
				from
					i := 1
				until
					l_chunk_size_line[i] /= '0'
				loop
					i := i + 1
				end
				if i > 1 then
					l_chunk_size_line := l_chunk_size_line.substring (i, l_chunk_size_line.count)
				end

				if a_extension /= Void then
					l_chunk_size_line.append_character (';')
					l_chunk_size_line.append (a_extension)
				end
				l_chunk_size_line.append ({HTTP_CONSTANTS}.crlf)
				put_string (l_chunk_size_line)
				put_string (s)
				put_string ({HTTP_CONSTANTS}.crlf)
			else
				put_string ("0" + {HTTP_CONSTANTS}.crlf)
			end
			flush
		end

	flush
			-- Flush if it makes sense
		do
			wgi_response.flush
		end

feature -- Helper

	put_response (obj: WSF_RESPONSE_MESSAGE)
		require
			not header_committed
			not status_is_set
			not message_committed
		do
			obj.send_to (Current)
		end

feature -- Redirect

	redirect_now_with_custom_status_code (a_url: READABLE_STRING_8; a_status_code: INTEGER)
			-- Redirect to the given url `a_url' and precise custom `a_status_code'
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
		require
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
		do
			if header_committed then
				-- This might be a trouble about content-length				
				put_string ("Headers already sent.%NCannot redirect, for now please follow this <a %"href=%"" + a_url + "%">link</a> instead%N")
			else
				create h.make_with_count (1)
				h.put_location (a_url)
				set_status_code (a_status_code)
				put_header_text (h.string)
			end
		end

	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed
		do
			redirect_now_with_custom_status_code (a_url, {HTTP_STATUS_CODE}.moved_permanently)
		end

	redirect_now_with_content (a_url: READABLE_STRING_8; a_content: READABLE_STRING_8; a_content_type: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		local
			h: HTTP_HEADER
		do
			if header_committed then
				-- This might be a trouble about content-length
				put_string ("Headers already sent.%NCannot redirect, for now please follow this <a %"href=%"" + a_url + "%">link</a> instead%N")
			else
				create h.make_with_count (1)
				h.put_location (a_url)
				h.put_content_length (a_content.count)
				h.put_content_type (a_content_type)
				set_status_code ({HTTP_STATUS_CODE}.moved_permanently)
				put_header_text (h.string)
				put_string (a_content)
			end
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
