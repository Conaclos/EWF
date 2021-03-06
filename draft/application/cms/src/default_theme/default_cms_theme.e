note
	description: "Summary description for {CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_CMS_THEME

inherit
	CMS_THEME

create
	make

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			service := a_service
		end

	service: CMS_SERVICE

feature -- Access

	name: STRING = "CMS"

	regions: ARRAY [STRING]
		once
			Result := <<"header", "content", "footer", "first_sidebar", "second_sidebar">>
		end

	html_template: DEFAULT_CMS_HTML_TEMPLATE
		local
			tpl: like internal_html_template
		do
			tpl := internal_html_template
			if tpl = Void then
				create tpl.make (Current)
				internal_html_template := tpl
			end
			Result := tpl
		end

	page_template: DEFAULT_CMS_PAGE_TEMPLATE
		local
			tpl: like internal_page_template
		do
			tpl := internal_page_template
			if tpl = Void then
				create tpl.make (Current)
				internal_page_template := tpl
			end
			Result := tpl
		end

feature -- Conversion

	prepare (page: CMS_HTML_PAGE)
		do
			page.add_style (url ("/theme/style.css", Void), Void)
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		local
			l_content: STRING_8
		do
			prepare (page)
			page_template.prepare (page)
			l_content := page_template.to_html (page)
			html_template.prepare (page)
			html_template.register (l_content, "page")
			Result := html_template.to_html (page)
		end

feature {NONE} -- Internal

	internal_page_template: detachable like page_template

	internal_html_template: detachable like html_template

invariant
	attached internal_page_template as inv_p implies inv_p.theme = Current
end
