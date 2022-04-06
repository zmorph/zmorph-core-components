/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

import ZMorph.UiElements 1.0

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    property color color: Style.c_secondaryGray
    property color textColor: Style.c_fontGray
    property var textLeftMargin: 12

    property color dropDownListColor: Style.c_secondaryGray
    property color dropDownListItemPressedColor: Style.c_primaryGray
    property color dropDownListItemHighlightedColor: Style.c_accent

    property color dropDownListTextColor: Style.c_fontGray
    property color dropDownListTextHighlightedColor: Style.c_secondaryGray

    delegate: ItemDelegate {
        width: parent.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData

        palette.text: control.dropDownListTextColor
        palette.highlightedText: control.dropDownListTextHighlightedColor
        palette.light: control.dropDownListItemHighlightedColor
        palette.midlight: control.dropDownListItemPressedColor

        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: ColorImage {
        x: control.mirrored ? control.padding : control.width - 2 * width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
//        color: control.palette.dark
        color: Qt.darker(Style.c_fontGray)
        defaultColor: "#353637"
        source: "qrc:/icons/down-chevron.svg"
        sourceSize.width: Style.chevronSize
//        source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/images/double-arrow.png"
        opacity: enabled ? 1 : 0.3
    }

    contentItem: T.TextField {
        leftPadding: !control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        topPadding: 6 - control.padding
        bottomPadding: 6 - control.padding

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        font: control.font
        color: control.editable ? control.palette.text : control.textColor
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            visible: control.enabled && control.editable && !control.flat
            border.width: parent && parent.activeFocus ? 2 : 1
            border.color: parent && parent.activeFocus ? control.palette.highlight : control.palette.button
            color: control.palette.base
        }
    }

    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 40

        color: control.down ? Qt.darker(control.color) : control.color
        border.color: control.palette.highlight
        border.width: !control.editable && control.visualFocus ? 2 : 0
        visible: !control.flat || control.down

        Behavior on color {
            ColorAnimation {
                duration: 70
            }
        }
    }

    popup: T.Popup {
        y: control.height
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        topMargin: 6
        bottomMargin: 6

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: control.dropDownListColor
        }
    }
}
