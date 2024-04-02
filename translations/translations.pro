# Copyright 2015 CybrTech Labs Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPLATE = subdirs
# TEMPLATE = lib
include(../global.pri)
TRANSLATIONS_DIR=$$system_quote($$DESTDIR/translations/)
win32:TRANSLATIONS_DIR=$$system(cygpath -u $$TRANSLATIONS_DIR)
system(bash -c $$system_quote(find $$shell_quote($$PWD) -name $$shell_quote('*.ts') -print0 | xargs -0 $$[QT_HOST_BINS/get]/lrelease -removeidentical))
system(bash -c $$system_quote(rsync -vrdmR  --remove-source-files --include='*/' --include='*.qm' --exclude='*' ./ $$TRANSLATIONS_DIR))
system(bash -c $$system_quote(rsync -vrdmR  --include='*/' --include='*.ini' --exclude='*' ./ $$TRANSLATIONS_DIR))
# TRANSLATIONS_DIR=$$DESTDIR/translations/
# LRELEASE_DIR=$$DESTDIR/translations/

TRANSLATIONS += \
        $$PWD/trikRuntime_ru.ts \
        $$PWD/trikRuntime_fr.ts \
        $$PWD/trikRuntime_de.ts \

# CONFIG += lrelease

OTHER_FILES += \
        $$PWD/*.ts \
installAdditionalSharedFiles($$DESTDIR/translations)
