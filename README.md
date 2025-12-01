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

The syntax is defined by the environment variable `KRAMDOWN_PARSER`.  If `MetadataGFM` is used, then the syntax follows [GitHub Flavored Markdown](https://help.github.com/articles/basic-writing-and-formatting-syntax/), and supports custom titles via [Jekyll-style front matter](https://jekyllrb.com/docs/frontmatter/).

# Static Generation

    ./gen_static -f doc -o static_output -h IndexPage -t "Documentation Title"

# Installation

    gem install kramdown kramdown-parser-gfm kramdown-metadata-parsers rouge rexml

## Offline Installation

Download the required gems from a computer with internet access.  This command downloads the `.gem` files in the current directory.

    gem fetch kramdown kramdown-metadata-parsers rouge rexml

Copy the `.gem` files to the computer without internet access and install.

    gem install -f --local *.gem

## Apache Configuration

### Enable Modules

* cgi_module
* expires_module
* rewrite_module

### Write configuration

Save this in /etc/httpd/sites or /etc/http/extras and make sure it's included in httpd.conf

    <VirtualHost doc.example.com:80>
        ServerAdmin admin@example.com
        ServerName doc.example.com
        DocumentRoot "/var/www/md-site/public"
        ErrorLog "/var/log/doc-example_error_log"

        # Determine this by running:
        #   gem env gemdir
        SetEnv GEM_PATH "/usr/local/lib/ruby/gems/3.5.5"

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

        # Page that will load as the index
        SetEnv HOME_PAGE "IndexPage"
    </VirtualHost>

    # Can have multiple VirtualHost(s) using the same application
    # Customize through SetEnv
    <VirtualHost notes.example.com:80>
        ServerAdmin admin@example.com
        ServerName notes.example.com
        DocumentRoot "/var/www/md-site/public"
        ErrorLog "/private/var/log/apache2/notes-example_error_log"
        SetEnv GEM_PATH "/usr/local/lib/ruby/gems/3.5.5"
        SetEnv SITE_PREFIX ""
        SetEnv PAGE_DIR "/var/notes"
        SetEnv KRAMDOWN_PARSER "MetadataGFM"
        SetEnv SHOW_DEBUG "False"
        SetEnv SITE_TITLE "Example Notes"
        SetEnv HOME_PAGE "IndexPage"
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

        RewriteRule alpha$ list.rb [L,PT]
        RewriteRule mtime$ list.rb?sort=mtime [L,PT]
        RewriteRule search$ search.rb [L,PT]

        RewriteCond %{REQUEST_URI} !^.*\.(jpg|css|js|gif|png)$ [NC]
        RewriteCond %{REQUEST_URI} !^gem_test.rb$ [NC]
        RewriteRule ^/$ index.rb?file=HOME_PAGE [B,L,PT]
        RewriteRule ^([^\.]+)$ index.rb?file=$1 [B,L,PT]
        RewriteRule ^([^\.]+.md)$ index.rb?file=$1 [B,L,PT]
    </Directory>
