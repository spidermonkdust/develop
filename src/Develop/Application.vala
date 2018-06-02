/*
* Copyright (c) 2011-2018 alcadica (https://www.alcadica.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: alcadica <github@alcadica.com>
*/
using Granite;
using Granite.Widgets;
using Gtk;

namespace Alcadica {

    public const string APP_ID = "com.github.alcadica.develop";
    public const string APP_NAME = "Develop";

    public class Develop : Granite.Application {
        public static Develop _instance = null;
        public static Develop instance {
            get {
                if (_instance == null) {
                    _instance = new Develop ();
                }
                return _instance;
            }
        }
        
        public Develop () {
            Object(
                application_id: APP_ID
            );
            Intl.setlocale (LocaleCategory.ALL, "");
        }

        construct {
            application_id = APP_ID;
            app_launcher = APP_ID + ".desktop";
            program_name = APP_NAME;

            flags |= ApplicationFlags.HANDLES_OPEN;

            Granite.Services.Logger.initialize (APP_NAME);
        }

        protected override void activate () {
            new Alcadica.Window (this);
        }

        protected override void open (File[] files, string hint) {
            activate ();
        }

        public static int main (string[] args) {
            var app = Develop.instance;
            return app.run (args);
        }
    }
}