from textual.app import App, ComposeResult
from textual.containers import Container
from textual.widgets import Footer, Tabs, Static, Button, DirectoryTree

class Path(Tabs):
    """Path display"""

class Navbar(Static):
    """Navigation bar, showed below the header, above the file view"""

    def compose(self) -> ComposeResult:
        """Create navigation bar"""
        yield Button("←", id="prev")
        yield Button("→", id="next")
        yield Path('C:')

class tifm(App):
    """File manager written with Textual"""

    CSS_PATH = "style.css"
    BINDINGS = [("d", "toggle_dark", "Toggle dark mode"), ("o", "zoom_object", "Zoom on object")]

    def on_mount(self) -> None:
        """Focus the tabs when the app starts."""
        tab_bar = self.query_one(Tabs)
        for tab in ['A', 'Path', 'Rises']:
            tab_bar.add_tab(tab)
        

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Navbar()
        yield DirectoryTree("..", id="tree-view")
        yield Footer()

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.dark = not self.dark

    def action_zoom_object(self) -> None:
        """An action to zoom on a selected file tree object"""
        tree = self.query_one('#tree-view')
        tree.path = './'

if __name__ == "__main__":
    app = tifm()
    app.run()