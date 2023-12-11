#ifndef MYFORM_H
#define MYFORM_H

#include <QMainWindow>
#include <QPushButton>
#include <QListView>
#include <QLabel>
#include <QMenuBar>
#include <QStatusBar>
#include <QTimer>
#include <QDateTime>
#include <QStandardItemModel>

class MyForm : public QMainWindow
{
    Q_OBJECT

public:
    MyForm(QWidget *parent = nullptr);

private slots:
    void onStartStopClicked();
    void onClearClicked();
    void onSaveClicked();
    void updateTimer();

private:
    void updateLabel();

    QWidget *centralWidget;
    QPushButton *startBtn;
    QPushButton *clearBtn;
    QPushButton *saveBtn;
    QListView *listView;
    QLabel *label;
    QMenuBar *menubar;
    QStatusBar *statusbar;
    QTimer *timer;
    QDateTime startTime;
    QStandardItemModel *listViewModel;
};

#endif // MYFORM_H
