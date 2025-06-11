# ----- Build-In Modules -----
import sys
from pathlib import Path

# ----- PyQt6 Modules -----
from PyQt6.QtCore import (
    QEasingCurve,
    QPropertyAnimation,
    QRegularExpression,
    Qt,
    QTimer,
)
from PyQt6.QtGui import QFont, QGuiApplication, QIcon, QRegularExpressionValidator
from PyQt6.QtWidgets import (
    QApplication,
    QFrame,
    QGraphicsDropShadowEffect,
    QGraphicsOpacityEffect,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMessageBox,
    QVBoxLayout,
    QWidget,
)


class TimeConverter(QWidget):
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("Time to Decimal Hours")
        self.setWindowFlag(Qt.WindowType.WindowStaysOnTopHint)  # 👈 Always on top
        self.setFixedSize(550, 420)

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

    def init_ui(self) -> None:
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(40, 40, 40, 40)
        main_layout.setSpacing(25)

        # Create card-like container
        card = QFrame()
        card.setStyleSheet(
            """
            QFrame {
                background-color: rgba(255, 255, 255, 0.05);
                border-radius: 15px;
                padding: 20px;
            }
            """
        )

        # Add shadow effect
        shadow = QGraphicsDropShadowEffect()
        shadow.setBlurRadius(20)
        shadow.setColor(Qt.GlobalColor.black)
        shadow.setOffset(0, 0)
        card.setGraphicsEffect(shadow)

        card_layout = QVBoxLayout(card)
        card_layout.setSpacing(20)

        # Enhanced Title Label
        title = QLabel("Convert Time to Decimal Hours")
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title.setFont(QFont("JetBrainsMono Nerd Font", 16, QFont.Weight.Bold))
        title.setStyleSheet(
            """
            color: #e0e0e0;
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            """
        )
        card_layout.addWidget(title)

        # Input Layout with modern styling
        input_layout = QHBoxLayout()
        input_layout.setSpacing(15)

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

        input_layout.addWidget(self.input_field)

        card_layout.addLayout(input_layout)

        # Enhanced Output Label
        self.output_label = QLabel("")
        self.output_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.output_label.setFont(
            QFont("JetBrainsMono Nerd Font", 14, QFont.Weight.Bold)
        )
        self.output_label.setStyleSheet(
            """
            color: #6c63ff;
            padding: 15px;
            background: rgba(108, 99, 255, 0.1);
            border-radius: 8px;
            """
        )

        self.opacity_effect = QGraphicsOpacityEffect()
        self.output_label.setGraphicsEffect(self.opacity_effect)
        self.opacity_effect.setOpacity(0)  # Initially invisible

        card_layout.addWidget(self.output_label)

        main_layout.addWidget(card)

        # Modern Footer
        footer = QLabel("Built with ❤️ using PyQt6")
        footer.setAlignment(Qt.AlignmentFlag.AlignCenter)
        footer.setFont(QFont("JetBrainsMono Nerd Font", 10))
        footer.setStyleSheet("color: #8a8a8a;")
        main_layout.addWidget(footer)

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

            # Show and animate output
            self.output_label.setText(f"✨ {rounded_hours} hours")
            self.animate_fade_in()

            # 🔁 Fade out after 1000 ms (1 second)
            QTimer.singleShot(1_000, self.animate_fade_out)

            # 🔗 Copy to clipboard
            clipboard = QGuiApplication.clipboard()
            clipboard.setText(f"{rounded_hours}")

            self.input_field.clear()
        except ValueError:
            QMessageBox.warning(
                self,
                "Invalid Format",
                "Please enter time in HH:MM:SS format (e.g. 01:30:00).",
            )
            self.output_label.setText("")

    def animate_fade_in(self) -> None:
        self.fade_in_anim = QPropertyAnimation(self.opacity_effect, b"opacity")
        self.fade_in_anim.setDuration(300)
        self.fade_in_anim.setStartValue(0)
        self.fade_in_anim.setEndValue(1)
        self.fade_in_anim.setEasingCurve(QEasingCurve.Type.OutCubic)
        self.fade_in_anim.start()

    def animate_fade_out(self) -> None:
        self.fade_out_anim = QPropertyAnimation(self.opacity_effect, b"opacity")
        self.fade_out_anim.setDuration(300)
        self.fade_out_anim.setStartValue(1)
        self.fade_out_anim.setEndValue(0)
        self.fade_out_anim.setEasingCurve(QEasingCurve.Type.InCubic)
        self.fade_out_anim.start()

    def keyPressEvent(self, event) -> None:
        key = event.key()

        if key == Qt.Key.Key_Escape:
            self.close()
            return

        if key in (Qt.Key.Key_Enter, Qt.Key.Key_Return):
            self.convert_time()
            return

        if key == Qt.Key.Key_F:
            self.input_field.setFocus()
            return

        super().keyPressEvent(event)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = TimeConverter()
    window.show()
    sys.exit(app.exec())
