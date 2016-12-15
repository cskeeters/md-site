This is a web application that uses [kramdown](https://kramdown.gettalong.org/)/[Ruby](https://www.ruby-lang.org/) to dynamically render documentation formatted in a user-specified flavor of [Markdown](https://daringfireball.net/projects/markdown/syntax).

![Screenshot of md-site](https://raw.githubusercontent.com/cskeeters/i/master/md-doc-demo.png)

# Usage

When focused in the body of the browser, the following keys are bound:

| Key          | Description
| ------------ | -----------
| <kbd>a</kbd> | Show pages sorted alphabetically
| <kbd>m</kbd> | Show pages sorted by modified time
| <kbd>/</kbd> | Move the cursor to the search box

# Syntax

The is defined by the KRAMDOWN_PARSER environment varible.  If MetadataGFM is used, then the syntax follows [GitHub Flavored Markdown](https://help.github.com/articles/basic-writing-and-formatting-syntax/), and supports custom titles via [Jekyll-style front matter](https://jekyllrb.com/docs/frontmatter/).

# Installation

    gem install kramdown kramdown-metadata-parsers rouge

## Apache Configuration

### Enable Modules

* cgi_module
* expires_module

### Write configuration

Save this in /etc/httpd/sites or /etc/http/extras and make sure it's included in httpd.conf

    <VirtualHost doc.example.com:80>
        ServerAdmin admin@example.com
        ServerName doc.example.com
        DocumentRoot "/var/www/md-site/public"
        ErrorLog "/var/log/doc-example_error_log"

        # Determine this by running:
        #   gem env gemdir
        SetEnv GEM_PATH "/usr/local/lib/ruby/gems/2.3.0"

        # Set to /sub/path if this is a sub app
        SetEnv SITE_PREFIX ""

        # Where the markdown documents live
        SetEnv PAGE_DIR "/var/doc"

        # This will be one of MetadataKramdown, MetadataMarkdown, MetadataGFM, Kramdown, Markdown, or GFM
        # Any of the Metadata* parsers support YAML frontmatter (title)
        # https://jekyllrb.com/docs/frontmatter/
        SetEnv KRAMDOWN_PARSER "MetadataGFM"

        # Whether or not to show exceptions in the browser
        SetEnv SHOW_DEBUG "False"

        # Title of the index and search pages
        SetEnv SITE_TITLE "Example Documentation"
    </VirtualHost>

    # Can have multiple VirtualHost(s) using the same application
    # Customize through SetEnv
    <VirtualHost notes.example.com:80>
        ServerAdmin admin@example.com
        ServerName notes.example.com
        DocumentRoot "/var/www/md-site/public"
        ErrorLog "/private/var/log/apache2/notes-example_error_log"
        SetEnv GEM_PATH "/usr/local/lib/ruby/gems/2.3.0"
        SetEnv SITE_PREFIX ""
        SetEnv PAGE_DIR "/var/notes"
        SetEnv KRAMDOWN_PARSER "MetadataGFM"
        SetEnv SHOW_DEBUG "False"
        SetEnv SITE_TITLE "Example Notes"
    </VirtualHost>

    <Directory "/Library/WebServer/md-site/public">
        Options +ExecCGI

        # Disallow .htaccess configuration
        AllowOverride None

        ExpiresDefault "now"

        # Only allow users from the localmachine
        Require local
        # This allows everyone
        #Require all granted

        AddHandler cgi-script .rb

        DirectoryIndex index.html index.rb

        RewriteEngine on

        # Debug mod_rewrite
        # LogLevel alert rewrite:trace1

        # FLAGS
        # L  : Last
        # NC : no case (case in-sensitive)
        # B  : Escape non-alphanumeric characters in backreferences before applying the transformation - Keep url encoding
        # PT : Don't run the result through the RewriteRules again

        RewriteRule mtime$ index.rb?sort=mtime [L,PT]
        RewriteRule search$ search.rb [L,PT]

        RewriteCond %{REQUEST_URI} !^.*\.(jpg|css|js|gif|png)$ [NC]
        RewriteRule ^([^\.]+)$ md2html.rb?file=$1 [B,L,PT]
        RewriteRule ^([^\.]+.md)$ md2html.rb?file=$1 [B,L,PT]
    </Directory>
