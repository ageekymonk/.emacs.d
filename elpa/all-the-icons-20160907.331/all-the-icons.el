;;; all-the-icons.el --- A library for inserting Developer icons

;; Copyright (C) 2016  Dominic Charlesworth <dgc336@gmail.com>

;; Author: Dominic Charlesworth <dgc336@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((dash "2.12.0") (emacs "24.3"))
;; URL: https://github.com/domtronn/all-the-icons.el
;; Keywords: convenient, lisp

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package is a utility for using and formatting various Icon
;; fonts within Emacs.  Icon Fonts allow you to propertize and format
;; icons the same way you would normal text.  This enables things such
;; as better scaling of and anti aliasing of the icons.

;; This package was inspired by

;; - `mode-icons' for Emacs, found at https://github.com/ryuslash/mode-icons
;; - `file-icons' for Atom, found at https://atom.io/packages/file-icons

;; Currently, this package provides an interface to the following Icon Fonts

;; - Atom File Icons,   found at https://atom.io/packages/file-icons
;; - DevIcons,          found at http://vorillaz.github.io/devicons/#/main
;; - FontAwesome Icons, found at http://fontawesome.io/
;; - GitHub Octicons,   found at http://octicons.github.com
;; - Weather Icons,     found at https://erikflowers.github.io/weather-icons/
;; - AllTheIcons,       a custom Icon Font maintained as part of this package

;; Requests for new icons will be accepted and added to the AllTheIcons Icon Font

;;; Usage:

;; The simplest usage for this package is to use the following functions;

;;   `all-the-icons-icon-for-buffer'
;;   `all-the-icons-icon-for-file'
;;   `all-the-icons-icon-for-mode'

;; Which can be used to get a formatted icon for the current buffer, a
;; file name or a major mode respectively.  e.g.

;;   (insert (all-the-icons-icon-for-file "foo.js"))

;; Inserts a JavaScript icon formatted like this

;;   #("" 0 1 (display (raise -0.24)
;;              face (:family "dev-icons" :height 1.08 :foreground "#FFD446")))

;; You can also insert icons directly using the individual icon family
;; functions

;;   `all-the-icons-alltheicon'     // Custom font with fewest icons
;;   `all-the-icons-devicon'        // Developer Icons
;;   `all-the-icons-faicon'         // Font Awesome Icons
;;   `all-the-icons-fileicon'       // File Icons from the Atom File Icons package
;;   `all-the-icons-octicon'        // GitHub Octicons
;;   `all-the-icons-wicon'          // Weather Icons

;; You can call these functions with the icon name you want to insert, e.g.

;;   (all-the-icons-octicon "file-binary")  // GitHub Octicon for Binary File
;;   (all-the-icons-faicon  "cogs")         // FontAwesome icon for cogs
;;   (all-the-icons-wicon   "tornado")      // Weather Icon for tornado

;; A list of all the icon names for the different font families can be
;; found in the data directory, or by inspecting the alist variables.
;; All the alist varaiables are prefixed with `all-the-icons-data/'

;;; Code:

(require 'dash)

(require 'data-alltheicons  "./data/data-alltheicons.el")
(require 'data-devicons     "./data/data-devicons.el")
(require 'data-faicons      "./data/data-faicons.el")
(require 'data-fileicons    "./data/data-fileicons.el")
(require 'data-octicons     "./data/data-octicons.el")
(require 'data-weathericons "./data/data-weathericons.el")

(require 'all-the-icons-faces)

;;; Custom Variables
(defgroup all-the-icons nil
  "Manage how All The Icons formats icons."
  :prefix "all-the-icons-"
  :group 'tools
  :group 'convenience)

(defcustom all-the-icons-color-icons t
  "Whether or not to include a foreground colour when formatting the icon."
  :group 'all-the-icons
  :type 'boolean)

(defcustom all-the-icons-scale-factor 1.2
  "The bsae Scale Factor for the `height' face property of an icon."
  :group 'all-the-icons
  :type 'number)

(defcustom all-the-icons-default-adjust -0.2
  "The default adjustment to be made to the `raise' display property of an icon."
  :group 'all-the-icons
  :type 'number)

(defvar all-the-icons-icon-alist
  '(
    ;; Meta
    ("\\.tags"          all-the-icons-octicon "tag"                       :height 1.0 :v-adjust 0.0 :face all-the-icons-blue)
    ("^TAGS$"           all-the-icons-octicon "tag"                       :height 1.0 :v-adjust 0.0 :face all-the-icons-blue)
    ("\\.log"           all-the-icons-octicon "bug"                       :height 1.0 :v-adjust 0.0 :face all-the-icons-maroon)

    ;;
    ("\\.key$"          all-the-icons-octicon "key"                       :v-adjust 0.0 :face all-the-icons-lblue)
    ("\\.pem$"          all-the-icons-octicon "key"                       :v-adjust 0.0 :face all-the-icons-orange)
    ("\\.p12$"          all-the-icons-octicon "key"                       :v-adjust 0.0 :face all-the-icons-dorange)
    ("\\.crt$"          all-the-icons-octicon "key"                       :v-adjust 0.0 :face all-the-icons-lblue)
    ("\\.pub$"          all-the-icons-octicon "key"                       :v-adjust 0.0 :face all-the-icons-blue)

    ("^TODO$"           all-the-icons-octicon "checklist"                 :v-adjust 0.0 :face all-the-icons-lyellow)
    ("^LICENSE$"        all-the-icons-octicon "book"                      :height 1.0 :v-adjust 0.0 :face all-the-icons-blue)
    ("^readme"          all-the-icons-octicon "book"                      :height 1.0 :v-adjust 0.0 :face all-the-icons-lcyan)

    ("\\.fish"          all-the-icons-devicon "terminal"                  :face all-the-icons-lpink)
    ("\\.zsh"           all-the-icons-devicon "terminal"                  :face all-the-icons-lcyan)
    ("\\.sh"            all-the-icons-devicon "terminal"                  :face all-the-icons-purple)

    ;; Config
    ("\\.node"          all-the-icons-devicon "nodejs-small"              :height 1.0  :face all-the-icons-green)
    ("\\.babelrc$"      all-the-icons-fileicon "babel"                    :face all-the-icons-yellow)
    ("\\.bashrc$"       all-the-icons-alltheicon "script"                 :height 0.9  :face all-the-icons-dpink)
    ("\\.bowerrc$"      all-the-icons-devicon "bower"                     :height 1.2  :face all-the-icons-silver)
    ("^bower.json$"     all-the-icons-devicon "bower"                     :height 1.2  :face all-the-icons-lorange)
    ("\\.ini$"          all-the-icons-octicon "settings"                  :v-adjust 0.0 :face all-the-icons-yellow)
    ("\\.eslintignore"  all-the-icons-fileicon "eslint"                   :height 0.8  :face all-the-icons-purple)
    ("\\.eslint"        all-the-icons-fileicon "eslint"                   :height 0.8  :face all-the-icons-lpurple)
    ("\\.git"           all-the-icons-alltheicon "git"                    :height 1.0  :face all-the-icons-lred)
    ("nginx"            all-the-icons-fileicon "nginx"                    :height 0.9  :face all-the-icons-dgreen)
    ("apache"           all-the-icons-alltheicon "apache"                 :height 0.9  :face all-the-icons-dgreen)

    ("\\.dockerignore$" all-the-icons-fileicon "dockerfile"               :height 1.2  :face all-the-icons-dblue)
    ("^\\.?Dockerfile"  all-the-icons-fileicon "dockerfile"               :face all-the-icons-blue)
    ("^Brewfile$"       all-the-icons-faicon "beer"                       :face all-the-icons-lsilver)
    ("\\.npmignore"     all-the-icons-fileicon "npm"                      :face all-the-icons-dred)
    ("^package.json$"   all-the-icons-fileicon "npm"                      :face all-the-icons-red)

    ;; ;; AWS
    ("^stack.*.json$"   all-the-icons-alltheicon "aws"                    :face all-the-icons-orange)


    ("\\.[jc]son$"      all-the-icons-octicon "settings"                  :v-adjust 0.0 :face all-the-icons-yellow)
    ("\\.yml$"          all-the-icons-octicon "settings"                  :v-adjust 0.0 :face all-the-icons-dyellow)

    ("\\.pkg$"          all-the-icons-octicon "package"                   :v-adjust 0.0 :face all-the-icons-dsilver)
    ("\\.rpm$"          all-the-icons-octicon "package"                   :v-adjust 0.0 :face all-the-icons-dsilver)

    ("\\.elc$"          all-the-icons-octicon "file-binary"               :v-adjust 0.0 :face all-the-icons-dsilver)

    ("\\.gz$"           all-the-icons-octicon "file-binary"               :v-adjust 0.0 :face all-the-icons-lmaroon)
    ("\\.zip$"          all-the-icons-octicon "file-zip"                  :v-adjust 0.0 :face all-the-icons-lmaroon)
    ("\\.7z$"           all-the-icons-octicon "file-zip"                  :v-adjust 0.0 :face all-the-icons-lmaroon)


    ;; lock files
    ("~$"               all-the-icons-octicon "lock"                      :v-adjust 0.0 :face all-the-icons-maroon)

    ("\\.dmg$"          all-the-icons-octicon "tools"                     :v-adjust 0.0 :face all-the-icons-lsilver)
    ("\\.dll$"          all-the-icons-faicon "cogs"                       :face all-the-icons-silver)
    ("\\.DS_STORE$"     all-the-icons-faicon "cogs"                       :face all-the-icons-silver)

    ;; Source Codes
    ("\\.scpt$"         all-the-icons-fileicon "apple"                    :face all-the-icons-pink)
    ("\\.aup$"          all-the-icons-fileicon "audacity"                 :face all-the-icons-yellow)

    ("\\.java$"         all-the-icons-devicon "java"                      :height 1.0  :face all-the-icons-purple)

    ("\\.mp3$"          all-the-icons-faicon "volume-up"                  :face all-the-icons-dred)
    ("\\.wav$"          all-the-icons-faicon "volume-up"                  :face all-the-icons-dred)
    ("\\.m4a$"          all-the-icons-faicon "volume-up"                  :face all-the-icons-dred)

    ("\\.jl$"           all-the-icons-fileicon "julia"                    :v-adjust 0.0 :face all-the-icons-purple)
    ("\\.matlab$"       all-the-icons-fileicon "matlab"                   :face all-the-icons-orange)

    ("\\.pl$"           all-the-icons-alltheicon "perl"                   :face all-the-icons-lorange)
    ("\\.pl6$"          all-the-icons-fileicon "perl6"                    :face all-the-icons-cyan)
    ("\\.pod$"          all-the-icons-devicon "perl"                      :height 1.2  :face all-the-icons-lgreen)

    ("\\.php$"          all-the-icons-fileicon "php"                      :face all-the-icons-lsilver)
    ("\\.pony$"         all-the-icons-fileicon "pony"                     :face all-the-icons-maroon)
    ("\\.prol?o?g?$"    all-the-icons-devicon "prolog"                    :height 1.1  :face all-the-icons-lmaroon)
    ("\\.py$"           all-the-icons-devicon "python"                    :height 1.0  :face all-the-icons-dblue)

    ("\\.gem$"          all-the-icons-devicon "ruby-rough"                :face all-the-icons-red)
    ("\\.rb$"           all-the-icons-octicon "ruby"                      :v-adjust 0.0 :face all-the-icons-lred)
    ("\\.rs$"           all-the-icons-devicon "rust"                      :height 1.2  :face all-the-icons-maroon)
    ("\\.rlib$"         all-the-icons-devicon "rust"                      :height 1.2  :face all-the-icons-dmaroon)
    ("\\.r[ds]?x?$"     all-the-icons-fileicon "R"                        :face all-the-icons-lblue)

    ("\\.scala$"        all-the-icons-alltheicon "scala"                  :face all-the-icons-red)

    ("\\.swift$"        all-the-icons-devicon "swift"                     :height 1.0 :v-adjust -0.1 :face all-the-icons-green)

    ("-?spec\\.js$"     all-the-icons-alltheicon "jasmine"                :height 0.9 :v-adjust -0.1 :face all-the-icons-lpurple)
    ("-?test\\.js$"     all-the-icons-alltheicon "jasmine"                :height 0.9 :v-adjust -0.1 :face all-the-icons-lpurple)
    ("-?spec\\."        all-the-icons-faicon "flask"                      :height 1.0 :v-adjust 0.0 :face all-the-icons-dgreen)
    ("-?test\\."        all-the-icons-faicon "flask"                      :height 1.0 :v-adjust 0.0 :face all-the-icons-dgreen)

    ;; There seems to be a a bug with this font icon which does not
    ;; let you propertise it without it reverting to being a lower
    ;; case phi
    ("\\.c$"            all-the-icons-alltheicon "c-line"                 :face all-the-icons-blue)
    ("\\.h$"            all-the-icons-alltheicon "c-line"                 :face all-the-icons-purple)

    ("\\.cpp$"          all-the-icons-alltheicon "cplusplus-line"         :v-adjust -0.2 :face all-the-icons-blue)
    ("\\.hpp$"          all-the-icons-alltheicon "cplusplus-line"         :v-adjust -0.2 :face all-the-icons-purple)

    ("\\.csx?$"         all-the-icons-alltheicon "csharp-line"            :face all-the-icons-dblue)

    ("\\.clj$"          all-the-icons-devicon "clojure"                   :height 1.0  :face all-the-icons-blue)

    ("\\.coffee$"       all-the-icons-alltheicon "coffeescript"           :height 1.0  :face all-the-icons-maroon)
    ("\\.iced$"         all-the-icons-alltheicon "coffeescript"           :height 1.0  :face all-the-icons-lmaroon)

    ;; Git
    ("^MERGE_"          all-the-icons-octicon "git-merge"                 :v-adjust 0.0 :face all-the-icons-red)
    ("^COMMIT_EDITMSG"  all-the-icons-octicon "git-commit"                :v-adjust 0.0 :face all-the-icons-red)

    ;; Lisps
    ("\\.cl$"           all-the-icons-fileicon "clisp"                    :face all-the-icons-lorange)
    ("\\.l$"            all-the-icons-fileicon "lisp"                     :face all-the-icons-orange)
    ("\\.el$"           all-the-icons-fileicon "elisp"                    :height 1.0 :v-adjust -0.2 :face all-the-icons-purple)

    ;; Stylesheeting
    ("\\.css$"          all-the-icons-devicon "css3-full"                 :face all-the-icons-yellow)
    ("\\.scss$"         all-the-icons-devicon "sass"                      :face all-the-icons-pink)
    ("\\.sass$"         all-the-icons-devicon "sass"                      :face all-the-icons-dpink)
    ("\\.less$"         all-the-icons-alltheicon "less"                   :height 0.8  :face all-the-icons-dyellow)
    ("\\.postcss$"      all-the-icons-fileicon "postcss"                  :face all-the-icons-dred)
    ("\\.sss$"          all-the-icons-fileicon "postcss"                  :face all-the-icons-dred)
    ("\\.styl$"         all-the-icons-devicon "stylus"                    :face all-the-icons-lgreen)
    ("stylelint"        all-the-icons-fileicon "stylelint"                :face all-the-icons-lyellow)
    ("\\.csv$"          all-the-icons-octicon "graph"                     :v-adjust 0.0 :face all-the-icons-dblue)

    ("\\.hs$"           all-the-icons-devicon "haskell"                   :height 1.0  :face all-the-icons-red)

    ;; Web modes
    ("\\.haml$"         all-the-icons-fileicon "haml"                     :face all-the-icons-lyellow)
    ("\\.html?$"        all-the-icons-devicon "html5"                     :face all-the-icons-orange)
    ("\\.erb$"          all-the-icons-devicon "html5"                     :face all-the-icons-lred)
    ("\\.hbs$"          all-the-icons-fileicon "moustache"                :face all-the-icons-green)
    ("\\.slim$"         all-the-icons-octicon "dashboard"                 :v-adjust 0.0 :face all-the-icons-yellow)
    ("\\.jade$"         all-the-icons-fileicon "jade"                     :face all-the-icons-red)
    ("\\.pug$"          all-the-icons-fileicon "pug"                      :face all-the-icons-red)

    ;; JavaScript
    ("^gulpfile"        all-the-icons-devicon "gulp"                      :height 1.0  :face all-the-icons-lred)
    ("^gruntfile"       all-the-icons-devicon "grunt"                     :height 1.0 :v-adjust -0.1 :face all-the-icons-lyellow)

    ("\\.d3\\.?js"      all-the-icons-alltheicon "d3"                     :height 0.8  :face all-the-icons-lgreen)

    ("\\.react"         all-the-icons-devicon "react"                     :height 1.1  :face all-the-icons-lblue)
    ("\\.js$"           all-the-icons-alltheicon "javascript"             :height 0.9  :face all-the-icons-yellow)
    ("\\.es[0-9]$"      all-the-icons-alltheicon "javascript"             :height 0.9  :face all-the-icons-yellow)
    ("\\.jsx$"          all-the-icons-fileicon "jsx"                      :height 0.8  :face all-the-icons-dyellow)
    ("\\.njs$"          all-the-icons-devicon "nodejs-small"              :height 1.2  :face all-the-icons-lgreen)
    ("^webpack"         all-the-icons-fileicon "webpack"                  :face all-the-icons-lblue)

    ;; File Types
    ("\\.ico$"          all-the-icons-octicon "file-media"                :v-adjust 0.0 :face all-the-icons-blue)
    ("\\.png$"          all-the-icons-octicon "file-media"                :v-adjust 0.0 :face all-the-icons-orange)
    ("\\.gif$"          all-the-icons-octicon "file-media"                :v-adjust 0.0 :face all-the-icons-green)
    ("\\.jpe?g$"        all-the-icons-octicon "file-media"                :v-adjust 0.0 :face all-the-icons-dblue)
    ("\\.svg$"          all-the-icons-alltheicon "svg"                    :height 0.9  :face all-the-icons-lgreen)

    ;; Video
    ("\\.mov"           all-the-icons-faicon "film"                       :face all-the-icons-blue)
    ("\\.mp4"           all-the-icons-faicon "film"                       :face all-the-icons-blue)
    ("\\.ogv"           all-the-icons-faicon "film"                       :face all-the-icons-dblue)

    ;; Fonts
    ("\\.ttf$"          all-the-icons-fileicon "font"                     :v-adjust 0.0 :face all-the-icons-dcyan)
    ("\\.woff2?$"       all-the-icons-fileicon "font"                     :v-adjust 0.0 :face all-the-icons-cyan)

    ;; Doc
    ("\\.pdf"           all-the-icons-octicon "file-pdf"                  :v-adjust 0.0 :face all-the-icons-dred)
    ("\\.te?xt"         all-the-icons-octicon "file-text"                 :v-adjust 0.0 :face all-the-icons-cyan)
    ("\\.doc[xm]?$"     all-the-icons-fileicon "word"                     :face all-the-icons-blue)
    ("\\.texi?$"        all-the-icons-fileicon "tex"                      :face all-the-icons-lred)
    ("\\.md$"           all-the-icons-octicon "markdown"                  :v-adjust 0.0 :face all-the-icons-lblue)
    ("\\.bib$"          all-the-icons-fileicon "bib"                      :face all-the-icons-maroon)
    ("\\.org$"          all-the-icons-fileicon "org"                      :face all-the-icons-lgreen)

    ("\\.pp[st]$"       all-the-icons-fileicon "ppt"                      :face all-the-icons-orange)
    ("\\.pp[st]x$"      all-the-icons-fileicon "ppt"                      :face all-the-icons-red)
    ("\\.knt$"          all-the-icons-fileicon "presentall-the-iconson"   :face all-the-icons-cyan)

    ("bookmark"         all-the-icons-octicon "bookmark"                  :height 1.1 :v-adjust 0.0 :face all-the-icons-lpink)
    ("\\.cache$"        all-the-icons-octicon "database"                  :height 1.0 :v-adjust 0.0 :face all-the-icons-green)

    ("^\\."             all-the-icons-octicon "gear"                      :v-adjust 0.0)
    ("."                all-the-icons-faicon "file-o"                     :height 0.8 :v-adjust 0.0 :face all-the-icons-dsilver)))

(defvar all-the-icons-dir-icon-alist
  '(
    ("trash"            all-the-icons-faicon "trash-o"         :height 1.2 :v-adjust -0.1)
    ("dropbox"          all-the-icons-faicon "dropbox"         :height 1.2 :v-adjust -0.1)
    ("google[ _-]drive" all-the-icons-devicon "google-drive"   :height 1.3 :v-adjust -0.1)
    ("atom"             all-the-icons-devicon "atom"           :height 1.2 :v-adjust -0.1)
    ("documents"        all-the-icons-faicon "book"            :height 1.2 :v-adjust -0.1)
    ("download"         all-the-icons-octicon "cloud-download" :height 1.2 :v-adjust -0.1)
    ("desktop"          all-the-icons-faicon "desktop"         :height 1.2 :v-adjust -0.1)
    ("pictures"         all-the-icons-faicon "picture-o"       :height 1.2 :v-adjust -0.1)
    ("photos"           all-the-icons-faicon "camera-retro"    :height 1.2 :v-adjust -0.1)
    ("music"            all-the-icons-faicon "headphones"      :height 1.2 :v-adjust -0.1)
    ("movies"           all-the-icons-faicon "video-camera"    :height 1.2 :v-adjust -0.1)
    ("code"             all-the-icons-octicon "code"           :height 1.2 :v-adjust -0.1)
    ("workspace"        all-the-icons-octicon "code"           :height 1.2 :v-adjust -0.1)
    (".git"             all-the-icons-alltheicon "git"         :height 0.9)
    ("."                all-the-icons-octicon "file-directory" :height 1.2)
    ))

(defvar all-the-icons-weather-icon-alist
  '(
    ("tornado"               all-the-icons-wicon "tornado")
    ("hurricane"             all-the-icons-wicon "hurricane")
    ("thunderstorms"         all-the-icons-wicon "thunderstorm")
    ("sunny"                 all-the-icons-wicon "day-sunny")
    ("rain.*snow"            all-the-icons-wicon "rain-mix")
    ("rain.*hail"            all-the-icons-wicon "rain-mix")
    ("sleet"                 all-the-icons-wicon "sleet")
    ("hail"                  all-the-icons-wicon "hail")
    ("drizzle"               all-the-icons-wicon "sprinkle")
    ("rain"                  all-the-icons-wicon "showers" :height 1.1 :v-adjust 0.0)
    ("showers"               all-the-icons-wicon "showers")
    ("blowing.*snow"         all-the-icons-wicon "snow-wind")
    ("snow"                  all-the-icons-wicon "snow")
    ("dust"                  all-the-icons-wicon "dust")
    ("fog"                   all-the-icons-wicon "fog")
    ("haze"                  all-the-icons-wicon "day-haze")
    ("smoky"                 all-the-icons-wicon "smoke")
    ("blustery"              all-the-icons-wicon "cloudy-windy")
    ("windy"                 all-the-icons-wicon "cloudy-gusts")
    ("cold"                  all-the-icons-wicon "snowflake-cold")
    ("partly.*cloudy.*night" all-the-icons-wicon "night-alt-partly-cloudy")
    ("partly.*cloudy"        all-the-icons-wicon "day-cloudy-high")
    ("cloudy.*night"         all-the-icons-wicon "night-alt-cloudy")
    ("cxloudy.*day"          all-the-icons-wicon "day-cloudy")
    ("cloudy"                all-the-icons-wicon "cloudy")
    ("clear.*night"          all-the-icons-wicon "night-clear")
    ("fair.*night"           all-the-icons-wicon "stars")
    ("fair.*day"             all-the-icons-wicon "horizon")
    ("hot"                   all-the-icons-wicon "hot")
    ("not.*available"        all-the-icons-wicon "na")
    ))

(defvar all-the-icons-mode-icon-alist
  '(
    (emacs-lisp-mode          all-the-icons-fileicon "elisp"           :v-adjust -0.1)
    (dired-mode               all-the-icons-octicon "file-directory"   :v-adjust 0.0)
    (lisp-interaction-mode    all-the-icons-fileicon "lisp"            :v-adjust -0.1)
    (js2-mode                 all-the-icons-devicon "javascript-badge" :v-adjust -0.1)
    (term-mode                all-the-icons-octicon "terminal"         :v-adjust 0.0)
    (eshell-mode              all-the-icons-octicon "terminal"         :v-adjust 0.0)
    (magit-refs-mode          all-the-icons-octicon "git-branch"       :v-adjust 0.0)
    (magit-process-mode       all-the-icons-octicon "mark-github"      :v-adjust 0.0)
    (magit-diff-mode          all-the-icons-octicon "git-compare"      :v-adjust 0.0)
    (ediff-mode               all-the-icons-octicon "git-compare"      :v-adjust 0.0)
    (comint-mode              all-the-icons-faicon "terminal"          :v-adjust 0.0)
    (eww-mode                 all-the-icons-faicon "firefox"           :v-adjust -0.1)
    (org-agenda-mode          all-the-icons-octicon "checklist"        :v-adjust 0.0)
    (cfw:calendar-mode        all-the-icons-octicon "calendar"         :v-adjust 0.0)
    (ibuffer-mode             all-the-icons-faicon "files-o"           :v-adjust 0.0)
    (messages-buffer-mode     all-the-icons-faicon "stack-overflow"    :v-adjust -0.1)
    (help-mode                all-the-icons-faicon "info"              :v-adjust -0.1)
    (benchmark-init/tree-mode all-the-icons-octicon "dashboard"        :v-adjust 0.0)
    (jenkins-mode             all-the-icons-fileicon "jenkins")
    (magit-popup-mode         all-the-icons-alltheicon "git")
    (magit-status-mode        all-the-icons-alltheicon "git")
    ))

;; ====================
;;   Functions Start
;; ====================

(defun all-the-icons-auto-mode-match? (&optional file)
  "Whether or not FILE's `major-mode' match against its `auto-mode-alist'."
  (let* ((file (or file (buffer-file-name) (buffer-name)))
         (auto-mode (all-the-icons-match-to-alist file auto-mode-alist)))
    (eq major-mode auto-mode)))

(defun all-the-icons-match-to-alist (file alist)
  "Match FILE against an entry in ALIST using `string-match'."
  (cdr (--first (string-match (car it) file) alist)))

(defun all-the-icons-dir-is-submodule (dir)
  "Checker whether or not DIR is a git submodule."
  (let* ((gitmodule-dir (locate-dominating-file dir ".gitmodules"))
         (modules-file  (expand-file-name (format "%s.gitmodules" gitmodule-dir)))
         (module-search (format "submodule \".*?%s\"" (file-name-base dir))))

    (when (and gitmodule-dir (file-exists-p (format "%s/.git" dir)))
      (with-temp-buffer
        (insert-file-contents modules-file)
        (search-forward-regexp module-search (point-max) t)))))

;; Icon functions
(defun all-the-icons-icon-for-dir (dir &optional chevron)
  "Format an icon for DIR with CHEVRON similar to tree based directories.

Produces different symbols by inspeting DIR to distinguish
symlinks and git repositories which do not depend on the
directory contents"
  (let* ((matcher (all-the-icons-match-to-alist (file-name-base dir) all-the-icons-dir-icon-alist))
         (path (expand-file-name dir))
         (chevron (or (all-the-icons-octicon (format "chevron-%s" chevron) 0.8 -0.1) ""))
         (icon (cond
                ((file-symlink-p path)
                 (all-the-icons-octicon "file-symlink-directory" 1.2))
                ((all-the-icons-dir-is-submodule path)
                 (all-the-icons-octicon "file-submodule" 1.2))
                ((file-exists-p (format "%s/.git" path))
                 (all-the-icons-octicon "repo" 1.2))
                (t (apply (car matcher) (cdr matcher))))))
    (format "\t%s\t%s " chevron icon)))

(defun all-the-icons-icon-for-buffer ()
  "Get the formatted icon for the current buffer.

This function priotises the use of the buffers file extension to
discern the icon when its `major-mode' matches its auto mode,
otherwise it will use the buffers `major-mode' to decide its
icon."
  (all-the-icons--icon-info-for-buffer))

(defun all-the-icons-icon-family-for-buffer ()
  "Get the icon font family for the current buffer."
  (all-the-icons--icon-info-for-buffer "family"))

;; Icon Functions

(defun all-the-icons-icon-for-file (file)
  "Get the formatted icon for FILE."
  (let ((icon (all-the-icons-match-to-alist file all-the-icons-icon-alist)))
    (apply (car icon) (cdr icon))))

(defun all-the-icons-icon-for-mode (mode)
  "Get the formatted icon for MODE."
  (let ((icon (cdr (assoc mode all-the-icons-mode-icon-alist))))
    (if icon (apply (car icon) (cdr icon)) mode)))

;; Family Face Functions
(defun all-the-icons-icon-family-for-file (file)
  "Get the icons font family for FILE."
  (let ((icon (all-the-icons-match-to-alist file all-the-icons-icon-alist)))
    (funcall (intern (format "%s-family" (car icon))))))

(defun all-the-icons-icon-family-for-mode (mode)
  "Get the icons font family for MODE."
  (let ((icon (cdr (assoc mode all-the-icons-mode-icon-alist))))
    (if icon (funcall (intern (format "%s-family" (car icon)))) nil)))

(defun all-the-icons--icon-info-for-buffer (&optional f)
  "Get icon info for the current buffer.

When F is provided, the info function is calculated with the format
`all-the-icons-icon-%s-for-file' or `all-the-icons-icon-%s-for-mode'."
  (let* ((base-f (concat "all-the-icons-icon" (when f (format "-%s" f))))
         (file-f (intern (concat base-f "-for-file")))
         (mode-f (intern (concat base-f "-for-mode"))))
    (if (and (buffer-file-name)
             (all-the-icons-auto-mode-match?))
      (funcall file-f (file-name-nondirectory (buffer-file-name)))
      (funcall mode-f major-mode))))

;; Weather icons
(defun all-the-icons-icon-for-weather (weather)
  "Get an icon for a WEATHER status."
  (let ((icon (all-the-icons-match-to-alist weather all-the-icons-weather-icon-alist)))
    (if icon (apply (car icon) (cdr icon)) weather)))

;; Definitions

(defun all-the-icons--function-name (name)
  "Get the symbol for an icon function name for icon set NAME."
  (intern (concat "all-the-icons-" (downcase (symbol-name name)))))

(defun all-the-icons--family-name (name)
  "Get the symbol for an icon family function for icon set NAME."
  (intern (concat "all-the-icons-" (downcase (symbol-name name)) "-family")))

(defmacro define-icon (name alist family)
  "Macro to generate functions for inserting icons for icon set NAME.

NAME defines is the name of the iconset and will produce a
function of the for `all-the-icons-NAME'.

ALIST is the alist containing maps between icon names and the
UniCode for the character.  All of these can be found in the data
directory of this package.

FAMILY is the font family to use for the icons."
  `(prog1
       (defun ,(all-the-icons--family-name name) () ,family);
       (defun ,(all-the-icons--function-name name) (icon-name &rest args)
         (let ((icon (cdr (assoc icon-name ,alist)))
               (other-face (if all-the-icons-color-icons (plist-get args :face) 'default))
               (height  (* all-the-icons-scale-factor (or (plist-get args :height) 1.0)))
               (v-adjust (* all-the-icons-scale-factor (or (plist-get args :v-adjust) all-the-icons-default-adjust)))
               (family ,family))
           (propertize icon
                       'face `(:family ,family :height ,height :inherit ,other-face)
                       'display `(raise ,v-adjust))))))

(define-icon alltheicon all-the-icons-data/alltheicons-alist "dev-icons")
(define-icon octicon all-the-icons-data/octicons-alist       "github-octicons")
(define-icon devicon all-the-icons-data/devicons-alist       "icomoon")
(define-icon fileicon all-the-icons-data/file-icon-alist     "file-icons")
(define-icon faicon all-the-icons-data/fa-icon-alist         "FontAwesome")
(define-icon wicon all-the-icons-data/weather-icons-alist    "Weather Icons")

(provide 'all-the-icons)

;;; all-the-icons.el ends here