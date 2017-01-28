/* modifier 0 means no modifier */
static int surfuseragent    = 1;  /* Append Surf version to default WebKit user agent */
static char *fulluseragent  = ""; /* Or override the whole user agent string */
static char *cookiefile     = "~/.cache/surf/cookies";
static char *scriptfile     = "~/.config/surf/script.js";
static char *styledir       = "~/.config/surf/styles/";
static char *cachedir       = "~/.cache/surf/";

/* Webkit default features */
static Parameter defconfig[ParameterLast] = {
	SETB(AcceleratedCanvas,  1),
	SETB(CaretBrowsing,      0),
	SETV(CookiePolicies,     "@Aa"),
	SETB(DiskCache,          1),
	SETB(DNSPrefetch,        0),
	SETI(FontSize,           12),
	SETB(FrameFlattening,    0),
	SETB(Geolocation,        0),
	SETB(HideBackground,     0),
	SETB(Inspector,          0),
	SETB(JavaScript,         1),
	SETB(KioskMode,          0),
	SETB(LoadImages,         1),
	SETB(MediaManualPlay,    0),
	SETB(Plugins,            1),
	SETV(PreferredLanguages, ((char *[]){ NULL })),
	SETB(RunInFullscreen,    0),
	SETB(ScrollBars,         0),
	SETB(ShowIndicators,     1),
	SETB(SiteQuirks,         1),
	SETB(SpellChecking,      0),
	SETV(SpellLanguages,     ((char *[]){ "en_US", NULL })),
	SETB(StrictSSL,          0),
	SETB(Style,              1),
	SETF(ZoomLevel,          1.4),
};

static UriParameters uriparams[] = {
	{ "(://|\\.)suckless\\.org(/|$)", {
	  FSETB(JavaScript, 0),
	  FSETB(Plugins,    0),
	}, },
};

static WebKitFindOptions findopts = WEBKIT_FIND_OPTIONS_CASE_INSENSITIVE |
                                    WEBKIT_FIND_OPTIONS_WRAP_AROUND;

#define URLS "grep -Eo 'http[s]?://[^ >]+' ~/books/bbamv.yml | sed \"s/'$//\" | sort -u"
#define SLUGIFY "perl -MURI::Escape -e 'print uri_escape(<>);' "
#define DMENU "dmenu -i -sb '#404040'" \
			  "  -sf '#909090' -nb '#0e0e0e'" \
              "  -nf '#909090' -fn 'Terminus (TTF):pixelsize=24:antialias=true'"
#define MAGNET_CMD "/home/sohorx/bin/magnet"

#define DUCK_ENGINE "https://www.duckduckgo.com/?q="
/* Duckduckgo settings:
 * see: https://duckduckgo.com/params
 * ('%23' = encoded char '#')
 * kae = theme
 * k9 = url color
 * ka = body font
 * ko = search bar
 * k1 = adds
 */
#define DUCK_PREFERENCE "&kae=%230e0e0e" \
						"&k9=%23b1222b" \
						"&ks=t" \
						"&kw=w" \
						"&ka=Ubuntu" \
						"&kt=Ubuntu" \
						"&ko=-2" \
						"&k1=-1"

#define DUCK_COMPLETE	"!google " \
						"\n!baidu " \
						"\n!youtube " \
						"\n!kat " \
						"\n!nyaa " \
						"\n!maps " \
						"\n!wiki " \
						"\n!vndb " \
						"\n!reddit " \
						"\n!4chanb " \
						"\n!8chb " \
						"\n!ebay " \
						"\n!amazon "

#define SEARCH_ENGINE(p, q) { \
	.v = (const char *[]){ "/bin/sh", "-c", \
		"prop=\"" \
		DUCK_ENGINE \
		"`echo -n \"" \
		DUCK_COMPLETE \
		"\" | " \
	   	DMENU \
		" | " \
		SLUGIFY \
		"` " \
		DUCK_PREFERENCE \
		"\" &&" \
		"xprop -id $2 -f $1 8s -set $1 \"$prop\"", \
		p, q, winid, NULL \
	} \
}
#define SETEPROP(p, q) { \
	.v = (const char *[]){ "/bin/sh", "-c", \
		"prop=\"` " \
		"xprop -id $2 $0 " \
		"| sed \"s/^$0(STRING) = \\(\\\\\"\\?\\)\\(.*\\)\\1$/\\2/\" " \
		"| xargs -0 printf %b " \
	    "| " \
	   	DMENU \
		" `\" && xprop -id $2 -f $1 8s -set $1 \"$prop\"", \
		p, q, winid, NULL \
	} \
}

#define SETPROP(p, q) { \
	.v = (const char *[]){ "/bin/sh", "-c", \
		"prop=\"` " \
		"(xprop -id $2 $0 " \
		"| sed \"s/^$0(STRING) = \\(\\\\\"\\?\\)\\(.*\\)\\1$/\\2/\" " \
		"| xargs -0 printf %b " \
	    "&& " \
		URLS \
		") |" \
	   	DMENU \
		" -l 20`\" && xprop -id $2 -f $1 8s -set $1 \"$prop\"", \
		p, q, winid, NULL \
	} \
}

/* SETPROP {{{
#define SETPROP(p, q) { \
        .v = (const char *[]){ "/bin/sh", "-c", \
             "prop=\"`xprop -id $2 $0 " \
             "| sed \"s/^$0(STRING) = \\(\\\\\"\\?\\)\\(.*\\)\\1$/\\2/\" " \
             "| xargs -0 printf %b | dmenu`\" &&" \
             "xprop -id $2 -f $1 8s -set $1 \"$prop\"", \
             p, q, winid, NULL \
        } \
} }}} */

/* DOWNLOAD(URI, referer) */
#define DOWNLOAD(d, r) { \
	.v = (const char *[]){ "/bin/sh", "-c", \
		"urxvtc -e /bin/sh -c \"cd ~/downloads ; " \
		"curl -g -L -J -O --user-agent '$1' --referer '$1' -b $3 -c $3 '$0';" \
		" sleep 3;\"", \
		d, useragent, r, cookiefile, NULL \
	} \
}

/* PLUMB(URI) */
/* This called when some URI which does not begin with "about:",
 * "http://" or "https://" should be opened.
 */
#define PLUMB(u) {\
        .v = (const char *[]){ "/bin/sh", "-c", \
             "xdg-open \"$0\"", u, NULL \
        } \
}

/* VIDEOPLAY(URI) */
#define VIDEOPLAY(u) {\
	.v = (const char *[]){ "/bin/sh", "-c", \
		"mpv --really-quiet \"$0\"", u, NULL \
	} \
}

/* styles */
/*
 * The iteration will stop at the first match, beginning at the beginning of
 * the list.
 */
static SiteStyle styles[] = {
	/* regexp               file in $styledir */
	{ ".*",                 "default.css" },
};

#define MODKEY GDK_CONTROL_MASK

static UriPrefix uriprefix[] = {
	/* ignore decision, prefix    fonction   command followed by uri */
	{ TRUE,            "magnet:", spawn,     MAGNET_CMD },
};
/* hotkeys */
/*
 * If you use anything else but MODKEY and GDK_SHIFT_MASK, don't forget to
 * edit the CLEANMASK() macro.
 */
static Key keys[] = {
	/* modifier              keyval          function    arg */
	{ MODKEY,                GDK_KEY_u,      spawn,      SETPROP("_SURF_URI", "_SURF_GO") },
	{ MODKEY,                GDK_KEY_e,      spawn,      SEARCH_ENGINE("_SURF_URI", "_SURF_GO") },
	{ MODKEY,                GDK_KEY_slash,  spawn,      SETEPROP("_SURF_FIND", "_SURF_FIND") },

	{ 0,                     GDK_KEY_Escape, stop,       { 0 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_r,      reload,     { .b = 1 } },
	{ MODKEY,                GDK_KEY_r,      reload,     { .b = 0 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_l,      navigate,   { .i = +1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_h,      navigate,   { .i = -1 } },

	/* Currently we have to use scrolling steps that WebKit2GTK+ gives us
	 * d: step down, u: step up, r: step right, l:step left
	 * D: page down, U: page up */
	/*{ MODKEY,                GDK_KEY_j,      scroll,     { .i = 'd' } },*/
	/*{ MODKEY,                GDK_KEY_k,      scroll,     { .i = 'u' } },*/
	/*{ MODKEY,                GDK_KEY_l,      scroll,     { .i = 'r' } },*/
	/*{ MODKEY,                GDK_KEY_h,      scroll,     { .i = 'l' } },*/
	/* script.js does the work */
	{ MODKEY,                GDK_KEY_space,  scroll,     { .i = 'D' } },
	{ MODKEY,                GDK_KEY_b,      scroll,     { .i = 'U' } },


	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_j,      zoom,       { .i = -1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_k,      zoom,       { .i = +1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_q,      zoom,       { .i = 0  } },
	{ MODKEY,                GDK_KEY_minus,  zoom,       { .i = -1 } },
	{ MODKEY,                GDK_KEY_plus,   zoom,       { .i = +1 } },

	{ MODKEY,                GDK_KEY_p,      clipboard,  { .b = 1 } },
	{ MODKEY,                GDK_KEY_y,      clipboard,  { .b = 0 } },

	{ MODKEY,                GDK_KEY_n,      find,       { .i = +1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_n,      find,       { .i = -1 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_p,      print,      { 0 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_a,      togglecookiepolicy, { 0 } },
	{ 0,                     GDK_KEY_F11,    togglefullscreen, { 0 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_o,      toggleinspector, { 0 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_c,      toggle,     { .i = CaretBrowsing } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_f,      toggle,     { .i = FrameFlattening } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_g,      toggle,     { .i = Geolocation } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_s,      toggle,     { .i = JavaScript } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_i,      toggle,     { .i = LoadImages } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_v,      toggle,     { .i = Plugins } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_b,      toggle,     { .i = ScrollBars } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_m,      toggle,     { .i = Style } },
};

/* button definitions */
/* target can be OnDoc, OnLink, OnImg, OnMedia, OnEdit, OnBar, OnSel, OnAny */
static Button buttons[] = {
	/* target       event mask      button  function        argument        stop event */
	{ OnLink,       0,              2,      clicknewwindow, { .b = 0 },     1 },
	{ OnLink,       MODKEY,         2,      clicknewwindow, { .b = 1 },     1 },
	{ OnLink,       MODKEY,         1,      clicknewwindow, { .b = 1 },     1 },
	{ OnAny,        0,              8,      clicknavigate,  { .i = -1 },    1 },
	{ OnAny,        0,              9,      clicknavigate,  { .i = +1 },    1 },
	{ OnMedia,      0,         1,      clickexternplayer, { 0 },       1 },
};
