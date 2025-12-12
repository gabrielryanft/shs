/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no standard bar */
static const int topbar             = 1;        /* 0 means standard bar at bottom */
static const int extrabar           = 1;        /* 0 means no extra bar */
static const char statussep         = ';';      /* separator between statuses */
static const char *fonts[]          = { "DejaVuSansMNerdFont:pixelsize=14" };
static const char dmenufont[]       = "DejaVuSansMNerdFont:pixelsize=14";
static const char col_gray1[]       = "#000000";
static const char col_gray2[]       = "#444444";
// static const char col_gray3[]       = "#bbbbbb";
static const char col_gray3[]       = "#54be0d";
static const char col_gray4[]       = "#000000";
// static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#429609";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class	instance		title		tags mask	isfloating   monitor */
	{ "XTerm",	NULL,		      "AF-Z",		0,		1,		-1 },
	{ "anki",	NULL,		      NULL,		1 << 2,		1,		-1 },
	{ "",		"Do_what_thumbnail",  "nsxiv",		1 << 8,		0,		-1 },
	{ "",		"Do_what_one",	      "nsxiv",		1 << 8,		0,		-1 },
	{ "st",		NULL,		      "TheTerminal",	2,		0,		-1 },
	{ "XTerm",	NULL,		      "TheTerminal",	2,		1,		-1 },
	{ "XTerm",	NULL,		      "Music MPV",	0,	     	1,		-1 },
	{ "XTerm",	NULL,		      "CalculosTotosos",0,	     	1,		-1 },
	{ "kdenlive",	NULL,		      NULL,		2,	  	0,		-1 },
	{ "Chromium",	NULL,		      NULL,		1,	  	0,		-1 },
	{ "Anki",	NULL,		      NULL,		2,	  	0,		-1 },
	{ "librewolf",	NULL,		      NULL,		1,	  	0,		-1 },
	{ "Gimp",	NULL,		      NULL,		1 << 7,		0,		-1 },
	{ "Dia",	NULL,		      NULL,		1 << 7,		0,		-1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[M]",      monocle },
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|Mod1Mask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/bash", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-f", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_x,      spawn,                 SHCMD("bash $HOME/.command") },

	{ MODKEY|ShiftMask,             XK_t,      spawn,                 SHCMD("pkill librewolf") },

	{ MODKEY|ShiftMask,             XK_t,      spawn,                 SHCMD("pkill librewolf") },

	{ MODKEY,                       XK_r,      spawn,                 SHCMD("bash $HOME/shs/dwm/blank_reading.sh") },

	{ MODKEY|ShiftMask,             XK_n,  focusmon,              {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_h, focusmon,              {.i = +1 } },
	{ MODKEY|ControlMask,  		XK_comma,  tagmon,                {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, tagmon,                {.i = +1 } },

	{ MODKEY,                       XK_p,      spawn,                 {.v = dmenucmd } },

	{ MODKEY|ControlMask|ShiftMask,	XK_Return, spawn,                 SHCMD("xterm") },
	{ MODKEY|ControlMask,		XK_Return, spawn,                 SHCMD(" ( $(tmux has -t $TTL) ) && xterm -e tmux a -t $TTL || xterm -e tmux new-session -s $TTL") },
	{ MODKEY|ShiftMask,		XK_Return, spawn,                 {.v = termcmd } },
	{ MODKEY,			XK_Return, spawn,                 SHCMD("st -e tmux a -t $TTL || st -e tmux new-session -s $TTL") },

	{ MODKEY,                       XK_b,      togglebar,             {0} },
	{ MODKEY,		        XK_b,      toggleextrabar,		  {0} },
	{ MODKEY|ShiftMask,		XK_b,      spawn,			  SHCMD("echo `fortune` > ~/.msg") },

	{ MODKEY,			XK_End,	   spawn,			  SHCMD("xkill") },

	{ MODKEY,                       XK_h,      setmfact,              {.f = -0.025} },
	{ MODKEY,                       XK_j,      focusstack,            {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,            {.i = -1 } },
	{ MODKEY,                       XK_l,      setmfact,              {.f = +0.025} },

	{ MODKEY,                       XK_i,      incnmaster,            {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,            {.i = -1 } },

	{ MODKEY,			XK_g,	   zoom,                  {0} },

	{ Mod1Mask,                     XK_Tab,    view,                  {0} },
	{ MODKEY,                       XK_Tab,    view,                  {0} },

	{ MODKEY,			XK_q,      killclient,            {0} },

	{ MODKEY,                       XK_w,      setlayout,             {.v = &layouts[0]} },
	{ MODKEY|ShiftMask|ControlMask, XK_f,      setlayout,             {.v = &layouts[1]} },
	{ MODKEY,                       XK_e,      setlayout,             {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,             {0} },

	{ MODKEY|ShiftMask,             XK_space,  togglefloating,        {0} },
	{ MODKEY|ShiftMask,             XK_0,      tag,                   {.ui = ~0 } },
	{ MODKEY,		        XK_0,      view,                  {.ui = ~0 } },

	{ MODKEY,                       XK_c,	   spawn,		  SHCMD("$HOME/shs/dwm/Calcsh.sh") },
	{ MODKEY|ShiftMask,             XK_c,	   spawn,		  SHCMD("$HOME/shs/dwm/clip.sh") },

	{ MODKEY,                       XK_f,	   spawn,		  SHCMD("$HOME/shs/dwm/todo_list.sh") },
	{ MODKEY|ShiftMask,             XK_f,	   spawn,		  SHCMD("$HOME/shs/dwm/todo_list.sh add") },

	{ MODKEY,		        XK_a,	   spawn,		  SHCMD("feh -x -F --class 'PeriodicTable' -B '#2f2f1f' $HOME/settings/Periodic_table_large-pt_BR.png") },

	{ MODKEY,                       XK_comma,  spawn,		  SHCMD("pactl -- set-sink-volume  $(sed -n $(($(pactl list sinks | grep -i -n running | cut -d':' -f 1) -1 ))p <(pactl list sinks) | cut -d '#' -f 2) -5%") },
	{ MODKEY,                       XK_period, spawn,  		  SHCMD("pactl -- set-sink-volume  $(sed -n $(($(pactl list sinks | grep -i -n running | cut -d':' -f 1) -1 ))p <(pactl list sinks) | cut -d '#' -f 2) +5%") },

	{ MODKEY,			XK_m,	   spawn,		  SHCMD("$HOME/shs/Musicsh/theMenu.sh") },
	{ MODKEY|ShiftMask,		XK_m,	   spawn,		  SHCMD("tmux kill-session -t 'Music MPV' && $HOME/shs/Musicsh/theMenu.sh") },
	{ MODKEY|ShiftMask,		XK_l,	   spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 'L'") },
	{ MODKEY|ShiftMask,		XK_comma,  spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 '<'") },
	{ MODKEY|ShiftMask,		XK_period, spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 '>'") },
	{ MODKEY|ShiftMask,		XK_slash,  spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 'p' && $HOME/shs/Musicsh/is_it_playing.sh || $HOME/shs/Musicsh/theMenu.sh") },
	{ MODKEY|ControlMask,		XK_9,	   spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 '9' && $HOME/shs/Musicsh/MPV_Vol.sh") },
	{ MODKEY|ControlMask,		XK_0,	   spawn,		  SHCMD("tmux send-keys -t 'Music MPV'.1 '0' && $HOME/shs/Musicsh/MPV_Vol.sh") },

	{ MODKEY|ShiftMask,		XK_s,      spawn,		  SHCMD("bash ~/shs/dwm/displays.sh") },

	{ MODKEY|ShiftMask,             XK_equal,  spawn,		  SHCMD("$HOME/shs/dwm/brightness.sh +") },
	{ MODKEY|ShiftMask,             XK_minus,  spawn,  		  SHCMD("$HOME/shs/dwm/brightness.sh") },

	{ MODKEY|ShiftMask,             XK_a,	   spawn,  		  SHCMD("echo $HOME/settings/Wallpaper/usable_ones/$(shuf -n 1 <<<$(ls -1 $HOME/settings/Wallpaper/usable_ones/)) > $HOME/settings/.bg.info && $(feh --bg-scale $(cat $HOME/settings/.bg.info))") },

	{ MODKEY,		        XK_Pause,  spawn,		  SHCMD("shutdown -h now") },
	{ MODKEY,		        XK_Print,  spawn,		  SHCMD("shutdown -h now") },
	{ MODKEY,		        XK_Scroll_Lock,  spawn,	          SHCMD("shutdown -h now") },

	{ MODKEY|ShiftMask,		XK_p,	   spawn,		  SHCMD("$HOME/shs/dwm/sshot_all.sh") },
	{ MODKEY|ControlMask,		XK_p,  	   spawn,	  	  SHCMD("$HOME/shs/dwm/sshot_part.sh") },

	{ MODKEY|ShiftMask,		XK_r,  	   spawn,	  	  SHCMD("$HOME/shs/dwm/record.sh") },

	{ MODKEY,		        XK_backslash,  spawn,	          SHCMD("$HOME/shs/dwm/lock_screen_dpms.sh something") },
	{ MODKEY,		        XK_z,	   spawn,  		  SHCMD("$HOME/shs/dwm/lock_screen_dpms.sh something") },
	{ MODKEY,		        XK_x, 	   spawn,  		  SHCMD("$HOME/shs/dwm/lock_screen_dpms.sh") },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarLeftStatus,   0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarMiddle,       0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkExBarRightStatus,  0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

