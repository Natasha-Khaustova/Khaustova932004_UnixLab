#include "myform.h"
#include <QApplication>

MyForm::MyForm(QWidget *parent) : QMainWindow(parent)
{
    this->setGeometry(0, 0, 680, 570);
    this->setWindowTitle("MainWindow");

    centralWidget = new QWidget(this);

    startBtn = new QPushButton("Start/Stop", centralWidget);
    startBtn->setGeometry(250, 390, 171, 61);
    startBtn->setFont(QFont("", 15));
    connect(startBtn, &QPushButton::clicked, this, &MyForm::onStartStopClicked);

    clearBtn = new QPushButton("Clear", centralWidget);
    clearBtn->setGeometry(140, 400, 71, 41);
    connect(clearBtn, &QPushButton::clicked, this, &MyForm::onClearClicked);

    saveBtn = new QPushButton("Save", centralWidget);
    saveBtn->setGeometry(450, 400, 71, 41);
    connect(saveBtn, &QPushButton::clicked, this, &MyForm::onSaveClicked);

    listView = new QListView(centralWidget);
    listView->setGeometry(160, 140, 331, 221);

    label = new QLabel(centralWidget);
    label->setGeometry(240, 40, 161, 71);
    label->setFont(QFont("", 15));

    this->setCentralWidget(centralWidget);

    menubar = new QMenuBar(this);
    menubar->setGeometry(0, 0, 680, 22);

    statusbar = new QStatusBar(this);

    this->setMenuBar(menubar);
    this->setStatusBar(statusbar);

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &MyForm::updateTimer);

    listViewModel = new QStandardItemModel(this);
    listView->setModel(listViewModel);
}

void MyForm::onStartStopClicked()
{
    if (timer->isActive()) {
        // Stop the timer
        timer->stop();
    } else {
        // Start the timer or resume if paused
        if (!startTime.isValid()) {
            startTime = QDateTime::currentDateTime();
        }
        timer->start(1000); // Update every second
    }

    updateLabel();
}

void MyForm::onClearClicked()
{
    // Stop the timer and reset
    timer->stop();
    startTime = QDateTime();
    updateLabel();
}

void MyForm::onSaveClicked()
{
    if (startTime.isValid()) {
        // Calculate elapsed time
        QDateTime currentTime = QDateTime::currentDateTime();
        qint64 elapsedSeconds = startTime.secsTo(currentTime);

        // Add the time to the list view
        QString formattedTime = QTime(0, 0).addSecs(elapsedSeconds).toString("hh:mm:ss");
        QStandardItem *item = new QStandardItem(formattedTime);
        listViewModel->appendRow(item);
    }
}

void MyForm::updateTimer()
{
    updateLabel();
}

void MyForm::updateLabel()
{
    if (startTime.isValid()) {
        QDateTime currentTime = QDateTime::currentDateTime();
        qint64 elapsedSeconds = startTime.secsTo(currentTime);

        // Format and update the label
        QString formattedTime = QTime(0, 0).addSecs(elapsedSeconds).toString("hh:mm:ss");
        label->setText(formattedTime);
    } else {
        label->clear();
    }
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MyForm w;
    w.show();
    return a.exec();
}
