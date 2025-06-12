# ----- Build-In Modules -----
import sys
from pathlib import Path

# ----- PyQt6 Modules -----
from PyQt6.QtCore import QPropertyAnimation, QRect, QRegularExpression, Qt, QTimer
from PyQt6.QtGui import QFont, QGuiApplication, QIcon, QRegularExpressionValidator
from PyQt6.QtWidgets import QApplication, QLineEdit, QMessageBox, QVBoxLayout, QWidget

# ----- Configurable Constants -----
MessageIcon: Path = Path(__file__).parent / "Assets" / "Info.ico"


def msg_box(
    *,
    title: str,
    text: str,
    icon: QMessageBox.Icon,
    icon_path: Path,
    buttons: QMessageBox.StandardButton,
    timeout: int = 5_000,
) -> int:
    """
    Displays a modal message box with a custom title, text, icon, and buttons, and automatically closes it after a specified timeout.
    Parameters:
        title (str): The title of the message box window.
        text (str): The main text displayed in the message box.
        icon (QMessageBox.Icon): The icon to display in the message box (e.g., information, warning, critical).
        icon_path (Path): The file path to the window icon for the message box.
        buttons (QMessageBox.StandardButton): The standard buttons to display (e.g., Ok, Cancel).
        timeout (int, optional): The time in milliseconds before the message box automatically closes. Defaults to 5,000 ms (5 seconds).
    Returns:
        int: The result code indicating which button was pressed, or -1 if the message box was closed automatically due to timeout.
    """
    msg_box = QMessageBox()
    msg_box.setWindowFlag(Qt.WindowType.WindowStaysOnTopHint)  # 👈 Always on top
    msg_box.setWindowTitle(title)
    msg_box.setText(text)
    msg_box.setIcon(icon)
    msg_box.setWindowIcon(QIcon(str(icon_path)))
    msg_box.setStandardButtons(buttons)
    msg_box.setModal(True)

    # Set a timer to close the box after some seconds
    def auto_close() -> None:
        msg_box.done(-1)  # simulate cancel/timeout

    QTimer.singleShot(timeout, auto_close)

    msg_box.exec()


class TimeConverter(QWidget):
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("Time to Decimal Hours")
        self.setWindowFlag(Qt.WindowType.WindowStaysOnTopHint)  # 👈 Always on top
        self.setFixedSize(350, 70)

        # Window Icon Path
        IconPath: Path = Path(__file__).parent / "Assets" / "AppIcon.ico"
        self.setWindowIcon(QIcon(str(IconPath)))

        # Modern dark theme with gradient
        self.setStyleSheet(
            """
            QWidget {
                background: qlineargradient(
                    x1: 0, y1: 0, x2: 1, y2: 1,
                    stop: 0 #1a1a2e,
                    stop: 1 #16213e
                );
            }
            """
        )

        self.init_ui()
        self.center_on_screen()

    def init_ui(self) -> None:
        main_layout = QVBoxLayout()

        self.input_field = QLineEdit()
        self.input_field.setPlaceholderText("Enter time (HH:MM:SS)")
        self.input_field.setFont(QFont("JetBrainsMono Nerd Font", 12))
        self.input_field.setStyleSheet(
            """
            QLineEdit {
                padding: 12px;
                border: 2px solid #4a4a4a;
                border-radius: 8px;
                background-color: rgba(255, 255, 255, 0.1);
                color: #ffffff;
            }
            QLineEdit:focus {
                border: 2px solid #6c63ff;
                background-color: rgba(255, 255, 255, 0.15);
            }
            """
        )

        # ⛔ Only allow digits and colons
        regex = QRegularExpression(r"^[0-9:]*$")
        validator = QRegularExpressionValidator(regex)
        self.input_field.setValidator(validator)

        self.output_label = QLineEdit()
        self.output_label.setReadOnly(True)
        self.output_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.output_label.setFont(QFont("JetBrainsMono Nerd Font", 12))
        self.output_label.setStyleSheet(
            """
            QLineEdit {
                padding: 12px;
                border: 2px solid #6c63ff;
                border-radius: 8px;
                background-color: rgba(255, 255, 255, 0.1);
                color: #00ff99;
            }
            """
        )
        self.output_label.hide()

        main_layout.addWidget(self.input_field)
        main_layout.addWidget(self.output_label)

        self.setLayout(main_layout)

    def convert_time(self) -> None:
        time_str: str = self.input_field.text().strip()
        try:
            parts = list(map(int, time_str.split(":")))
            if len(parts) == 2:
                h, m = parts
                s = 0
            elif len(parts) == 3:
                h, m, s = parts
            else:
                raise ValueError

            total_hours: float = h + m / 60 + s / 3600
            rounded_hours: float = round(total_hours, 2)

            # Copy to clipboard
            QGuiApplication.clipboard().setText(f"{rounded_hours}")

            # Update output text
            self.output_label.setText(f"✨ {rounded_hours}")

            # Show output and expand window
            self.output_label.show()
            self.setFixedHeight(120)

            # Schedule hiding after delay
            def hide_output() -> None:
                self.output_label.hide()
                self.setFixedHeight(70)
                self.input_field.clear()

            QTimer.singleShot(1_000, hide_output)

        except ValueError:
            msg_box(
                title="Invalid Format",
                text="Please enter time in HH:MM:SS format (e.g. 01:30:00).",
                icon=QMessageBox.Icon.Warning,
                icon_path=MessageIcon,
                buttons=QMessageBox.StandardButton.Ok,
            )

    def center_on_screen(self) -> None:
        """Centers the window on the current screen."""
        # Get the current screen where the window is
        app_instance = QApplication.instance()
        current_screen = (
            app_instance.screenAt(self.pos()) or app_instance.primaryScreen()
        )

        # Get the geometry of the screen
        screen_geometry = current_screen.availableGeometry()

        # Calculate the center position
        x = (screen_geometry.width() - self.width()) // 2 + screen_geometry.x()
        y = (screen_geometry.height() - self.height()) // 2 + screen_geometry.y()

        # Move the window
        self.move(x, y)

    def keyPressEvent(self, event) -> None:
        key = event.key()

        if key == Qt.Key.Key_Escape:
            self.close()
            return

        if key in (Qt.Key.Key_Enter, Qt.Key.Key_Return):
            self.convert_time()
            return

        super().keyPressEvent(event)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = TimeConverter()
    window.show()
    sys.exit(app.exec())
