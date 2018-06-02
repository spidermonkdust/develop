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

using Alcadica.LibValaProject.Entities;
using Granite.Widgets;

namespace Alcadica.Views.Partials.Editor { 
	protected class DirectoryTreeViewItem {
		public ProjectItem project_item { get; set; }
		public SourceList.Item source_item { get; set; }
	}
	
	public class DirectoryTreeView : Gtk.Grid {
		public Gtk.Label project_name = new Gtk.Label (null);
		public SourceList root = new SourceList ();
		public SourceList.ExpandableItem sources { get; set; }
		public List<DirectoryTreeViewItem> project_tree = new List<DirectoryTreeViewItem> ();

		construct {
			this.orientation = Gtk.Orientation.VERTICAL;
			
			this.sources = new SourceList.ExpandableItem (_("Sources"));

			this.root.root.add (this.sources);
			
			this.add (this.project_name);
			this.add (this.root);

			this.sources.expanded = true;
		}

		protected DirectoryTreeViewItem? get_by_name (string? name) {
			DirectoryTreeViewItem? item = null;

			if (name == null) {
				return item;
			}

			for (int a = 0; a < this.project_tree.length (); a++) {
				var found = this.project_tree.nth_data (a);

				if (found.project_item.nodepath == name) {
					item = found;
					break;
				}
			}
			
			return item;
		}

		protected void render_nodes (ProjectItem node) {
			if (node == null || !node.has_children) {
				return;
			}

			SourceList.ExpandableItem parent;
			var _item = this.get_by_name (node.nodepath);

			if (_item != null) {
				parent = _item.source_item as SourceList.ExpandableItem;				
			} else {
				parent = this.sources;
			}
			
			for (int i = 0; i < node.length; i++) {
				DirectoryTreeViewItem? current = this.get_by_name (node.get_child (i).nodepath);

				if (current != null) {
					parent.add (current.source_item);
					this.render_nodes (current.project_item);
				}
			}
		}

		public void show_project (Project project) {
			var children = project.sources.get_flatterned_children ();

			this.project_name.label = project.project_name + " - " + project.version.to_string ();

			print ("\n [count] " + children.length ().to_string ());

			foreach (var child in children) {
				DirectoryTreeViewItem item = new DirectoryTreeViewItem ();

				item.project_item = child;
				
				if (child.nodename == NODE_DIRECTORY) {
					item.source_item = new SourceList.ExpandableItem (child.friendlyname);
				} else if (child.nodename == NODE_FILE) {
					item.source_item = new SourceList.Item (child.friendlyname);
				}

				this.project_tree.append (item);
			}

			this.render_nodes (project.sources);
		}
	}
}